/*******************************************************************************
 *                                                                             *
 *  Copyright (C) 2017 by Max Lv <max.c.lv@gmail.com>                          *
 *  Copyright (C) 2017 by Mygod Studio <contact-shadowsocks-android@mygod.be>  *
 *                                                                             *
 *  This program is free software: you can redistribute it and/or modify       *
 *  it under the terms of the GNU General Public License as published by       *
 *  the Free Software Foundation, either version 3 of the License, or          *
 *  (at your option) any later version.                                        *
 *                                                                             *
 *  This program is distributed in the hope that it will be useful,            *
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of             *
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the              *
 *  GNU General Public License for more details.                               *
 *                                                                             *
 *  You should have received a copy of the GNU General Public License          *
 *  along with this program. If not, see <http://www.gnu.org/licenses/>.       *
 *                                                                             *
 *******************************************************************************/

package com.appgo.appgopro.services

import android.annotation.TargetApi
import android.app.Service
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.os.Build
import android.os.IBinder
import android.os.RemoteCallbackList
import android.support.v4.os.UserManagerCompat
import com.appgo.appgopro.AppGoApplication.Companion.app
import com.appgo.appgopro.R
import com.appgo.appgopro.acl.Acl
import com.appgo.appgopro.aidl.IAppGoService
import com.appgo.appgopro.aidl.IAppGoServiceCallback
import com.appgo.appgopro.database.DataStore
import com.appgo.appgopro.database.Profile
import com.appgo.appgopro.database.ProfileManager
import com.appgo.appgopro.plugin.PluginOptions
import com.appgo.appgopro.utils.*
import org.json.JSONObject
import java.io.File
import java.io.IOException
import java.net.InetAddress
import java.net.UnknownHostException
import java.util.*
import kotlin.reflect.KClass

/**
 * This object uses WeakMap to simulate the effects of multi-inheritance.
 */
object BaseService {

    val TAG: String = BaseService::class.java.name

    const val IDLE = 0
    const val CONNECTING = 1
    const val CONNECTED = 2
    const val STOPPING = 3
    const val STOPPED = 4

    const val CONFIG_FILE = "appgo.conf"

    class Data internal constructor(private val service: Interface) {

        @Volatile var state = STOPPED
        //        @Volatile var profile: Profile? = null
        @Volatile var profile: Profile? = null
        @Volatile var plugin = PluginOptions()
        @Volatile var pluginPath: String? = null
        val processes = GuardedProcessPool()

        var timer: Timer? = null
        var trafficMonitorThread: TrafficMonitorThread? = null

        val callbacks = RemoteCallbackList<IAppGoServiceCallback>()
        val bandwidthListeners = HashSet<IBinder>() // the binder is the real identifier

        var notification: ServiceNotification? = null
        val closeReceiver = broadcastReceiver { _, intent ->
            when (intent.action) {
                Action.RELOAD -> service.forceLoad()
                else -> service.stopRunner(true)
            }
        }
        var closeReceiverRegistered = false

        val binder = object : IAppGoService.Stub() {

            override fun getState(): Int {
                return this@Data.state
            }

            override fun getProfileName(): String = profile?.name ?: "Idle"

            override fun registerCallback(cb: IAppGoServiceCallback) {
                callbacks.register(cb)
            }

            override fun startListeningForBandwidth(cb: IAppGoServiceCallback) {
                if (bandwidthListeners.add(cb.asBinder())) {
                    if (timer == null) {
                        val t = Timer(true)
                        t.schedule(object : TimerTask() {
                            override fun run() {
                                if (state == CONNECTED && TrafficMonitor.updateRate()) {
                                    app.handler.post {
                                        if (bandwidthListeners.isNotEmpty()) {
                                            val txRate = TrafficMonitor.txRate
                                            val rxRate = TrafficMonitor.rxRate
                                            val txTotal = TrafficMonitor.txTotal
                                            val rxTotal = TrafficMonitor.rxTotal
                                            val n = callbacks.beginBroadcast()
                                            for (i in 0 until n) try {
                                                val item = callbacks.getBroadcastItem(i)
                                                if (bandwidthListeners.contains(item.asBinder()))
                                                    item.trafficUpdated(txRate, rxRate, txTotal, rxTotal)
                                            } catch (_: Exception) {
                                            }  // ignore
                                            callbacks.finishBroadcast()
                                        }
                                    }
                                }
                            }
                        }, 1000, 1000)
                        timer = t
                    }
                    TrafficMonitor.updateRate()
                    if (state == CONNECTED) {
                        cb.trafficUpdated(TrafficMonitor.txRate, TrafficMonitor.rxRate,
                                TrafficMonitor.txTotal, TrafficMonitor.rxTotal)
                    }
                }
            }

            override fun stopListeningForBandwidth(cb: IAppGoServiceCallback) {
                if (bandwidthListeners.remove(cb.asBinder()) && bandwidthListeners.isEmpty()) {
                    timer!!.cancel()
                    timer = null
                }
            }

            override fun unregisterCallback(cb: IAppGoServiceCallback) {
                stopListeningForBandwidth(cb)   // saves an RPC, and safer
                callbacks.unregister(cb)
            }
        }

        internal fun updateTrafficTotal(tx: Long, rx: Long) {
            try {
                // this.profile may have host, etc. modified and thus a re-fetch is necessary (possible race condition)
                val profile = ProfileManager.getProfile((profile ?: return).id) ?: return
                profile.tx += tx
                profile.rx += rx
                ProfileManager.updateProfile(profile)
                app.handler.post {
                    if (bandwidthListeners.isNotEmpty()) {
                        val n = callbacks.beginBroadcast()
                        for (i in 0 until n) {
                            try {
                                val item = callbacks.getBroadcastItem(i)
                                if (bandwidthListeners.contains(item.asBinder())) item.trafficPersisted(profile.id)
                            } catch (e: Exception) {
                                e.printStackTrace()
                                app.track(e)
                            }
                        }
                        callbacks.finishBroadcast()
                    }
                }
            } catch (e: IOException) {
                if (!DataStore.directBootAware) throw e // we should only reach here because we're in direct boot
                val profile = DirectBoot.getDeviceProfile()!!
                profile.tx += tx
                profile.rx += rx
            }
        }

        internal var appgoConfigFile: File? = null
        internal fun buildAppGoConfig(): File {
            val profile = profile!!
            val config = JSONObject()
                    .put("server", profile.ip)
                    .put("server_port", profile.remotePort)
                    .put("password", profile.password)
                    .put("method", profile.method)
            val pluginPath = pluginPath
            if (pluginPath != null) {
                val pluginCmd = arrayListOf(pluginPath)
                if (TcpFastOpen.sendEnabled) pluginCmd.add("--fast-open")
                config
                        .put("plugin", Commandline.toString(service.buildAdditionalArguments(pluginCmd)))
                        .put("plugin_opts", plugin.toString())
            }
            // sensitive AppGo config is stored in
            val file = File(if (UserManagerCompat.isUserUnlocked(app)) app.filesDir else @TargetApi(24) {
                app.deviceContext.noBackupFilesDir  // only API 24+ will be in locked state
            }, CONFIG_FILE)
            appgoConfigFile = file
            file.writeText(config.toString())
            //AGLogger.log(TAG, file.absolutePath);
            return file

            // sensitive AppGo config is stored in
            /*val file = File(
                    if (UserManagerCompat.isUserUnlocked(app))
                        app.deviceContext.filesDir
                    else @TargetApi(24) {
                        app.deviceContext.noBackupFilesDir  // only API 24+ will be in locked state
                    },
                    fileName)
            file.writeText(config.toString())
            return file*/
        }

        val aclFile: File? get() {
            val route = profile!!.route
            return Acl.getFile(route)
        }

        fun changeState(s: Int, msg: String? = null) {
            if (state == s && msg == null) return
            if (callbacks.registeredCallbackCount > 0) app.handler.post {
                val n = callbacks.beginBroadcast()
                for (i in 0 until n) try {
                    callbacks.getBroadcastItem(i).stateChanged(s, binder.profileName, msg)
                } catch (e: Exception) {
                    e.printStackTrace()
                    app.track(e)
                }
                callbacks.finishBroadcast()
            }
            state = s
        }
    }

    interface Interface {
        val tag: String

        fun onBind(intent: Intent): IBinder? = if (intent.action == Action.SERVICE) data.binder else null

        fun checkProfile(profile: Profile): Boolean =
                if (profile.ip.isEmpty() || profile.password.isEmpty()) {
                    stopRunner(true, (this as Context).getString(R.string.proxy_empty))
                    false
                } else true
        fun forceLoad() {
            val profile = app.currentProfile
                    ?: return stopRunner(true, (this as Context).getString(R.string.profile_empty))
            if (!checkProfile(profile)) return

            val s = data.state
            when (s) {
                STOPPED -> startRunner()
                CONNECTED -> {
                    stopRunner(false)
                    startRunner()
                }
                else -> AGLogger.log(tag, "Illegal state when invoking use: $s")
            }
        }

        fun buildAdditionalArguments(cmd: ArrayList<String>): ArrayList<String> = cmd

        fun startNativeProcesses() {
            val data = data
            val profile = data.profile!!
            val cmd = buildAdditionalArguments(arrayListOf(
                    File((this as Context).applicationInfo.nativeLibraryDir, Executable.SS_LOCAL).absolutePath,
                    "-u",
                    "-b", "127.0.0.1",
                    "-l", DataStore.portProxy.toString(),
                    "-t", "600",
                    "-c", data.buildAppGoConfig().absolutePath))

            val acl = data.aclFile
            if (acl != null) {
                cmd += "--acl"
                cmd += acl.absolutePath
            } else {
                AGLogger.log(TAG, "acl is NULL");
            }

            if (profile.udpdns) cmd += "-D"

            if (TcpFastOpen.sendEnabled) cmd += "--fast-open"

            data.processes.start(cmd)
        }

        fun createNotification(profileName: String): ServiceNotification

        fun startRunner() {
            this as Context
            if (Build.VERSION.SDK_INT >= 26) startForegroundService(Intent(this, javaClass))
            else startService(Intent(this, javaClass))
        }

        fun killProcesses() = data.processes.killAll()

        fun stopRunner(stopService: Boolean, msg: String? = null) {
            // channge the state
            val data = data
            this as Context
            data.changeState(STOPPING)

            killProcesses()

            // clean up recevier
            this as Service
            if (data.closeReceiverRegistered) {
                unregisterReceiver(data.closeReceiver)
                data.closeReceiverRegistered = false
            }

            data.appgoConfigFile?.delete()    // remove old config possibly in device storage
            data.appgoConfigFile = null

            data.notification?.destroy()
            data.notification = null

            // Make sure update total traffic when stopping the runner
            data.updateTrafficTotal(TrafficMonitor.txTotal, TrafficMonitor.rxTotal)

            TrafficMonitor.reset()
            data.trafficMonitorThread?.stopThread()
            data.trafficMonitorThread = null

            // change the state
            data.changeState(STOPPED, msg)

            // stop the service if nothing has bound to it
            if (stopService) stopSelf()

            data.profile = null
        }

        val data: Data get() = instances[this]!!

        fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
            val data = data
            if (data.state != STOPPED) return Service.START_NOT_STICKY

            val profile = app.currentProfile

            this as Context
            if (profile == null) {
                data.notification = createNotification("")  // gracefully shutdown: https://stackoverflow.com/questions/47337857/context-startforegroundservice-did-not-then-call-service-startforeground-eve
                stopRunner(true, getString(R.string.profile_empty))
                return Service.START_NOT_STICKY
            }
            AGLogger.log(TAG, profile!!.name!!)
            AGLogger.log(TAG, profile!!.route)

            data.profile = profile

            TrafficMonitor.reset()
            val thread = TrafficMonitorThread()
            thread.start()
            data.trafficMonitorThread = thread

            if (!data.closeReceiverRegistered) {
                // register close receiver
                val filter = IntentFilter()
                filter.addAction(Action.RELOAD)
                filter.addAction(Intent.ACTION_SHUTDOWN)
                filter.addAction(Action.CLOSE)
                registerReceiver(data.closeReceiver, filter)
                data.closeReceiverRegistered = true
            }


            data.notification = createNotification(profile!!.name!!)

            data.changeState(CONNECTING)

            thread("$tag-Connecting") {
                try {
                    // Clean up
                    killProcesses()

                    if (!profile.ip.isNumericAddress())
                        profile.ip = InetAddress.getByName(profile.ip).hostAddress ?: throw UnknownHostException()

                    startNativeProcesses()

                    //AclSyncJob.schedule(profile.route)

                    data.changeState(CONNECTED)
                } catch (_: UnknownHostException) {
                    stopRunner(true, getString(R.string.invalid_server))
                } catch (_: VpnService.NullConnectionException) {
                    stopRunner(true, getString(R.string.reboot_required))
                } catch (exc: Throwable) {
                    stopRunner(true, "${getString(R.string.service_failed)}: ${exc.message}")
                }
            }
            return Service.START_NOT_STICKY
        }
    }

    private val instances = WeakHashMap<Interface, Data>()
    internal fun register(instance: Interface) = instances.put(instance, Data(instance))

    val usingVpnMode: Boolean get() = DataStore.serviceMode == Key.modeVpn
    val serviceClass: KClass<out Any> get() = when (DataStore.serviceMode) {
        Key.modeProxy -> ProxyService::class
        Key.modeVpn -> VpnService::class
        Key.modeTransproxy -> TransproxyService::class
        else -> throw UnknownError()
    }


}
