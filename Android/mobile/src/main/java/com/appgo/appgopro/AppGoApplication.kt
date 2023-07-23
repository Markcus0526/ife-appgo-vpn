package com.appgo.appgopro

import android.app.Application
import android.app.NotificationChannel
import android.app.NotificationManager
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.content.pm.PackageInfo
import android.content.pm.PackageManager
import android.content.res.Resources
import android.os.Build
import android.os.Handler
import android.os.Looper
import android.support.annotation.RequiresApi
import cn.jpush.android.api.JPushInterface
import com.appgo.appgopro.database.Profile
import com.appgo.appgopro.database.ProfileManager
import com.appgo.appgopro.models.Preference
import com.appgo.appgopro.services.BaseService
import com.appgo.appgopro.utils.Action
import com.appgo.appgopro.utils.DeviceContext
import com.google.android.gms.analytics.GoogleAnalytics
import com.google.android.gms.analytics.HitBuilders
import com.google.android.gms.analytics.StandardExceptionParser
import com.google.android.gms.analytics.Tracker
import com.google.firebase.remoteconfig.FirebaseRemoteConfig

class AppGoApplication : Application() {

    companion object {
        lateinit var app: AppGoApplication
        private const val TAG = "AppGoApplication"
        var instance: AppGoApplication? = null
    }

    val handler by lazy { Handler(Looper.getMainLooper()) }
    val deviceContext: Context by lazy { if (Build.VERSION.SDK_INT < 24) this else DeviceContext(this) }
    val remoteConfig: FirebaseRemoteConfig by lazy { FirebaseRemoteConfig.getInstance() }
    private val tracker: Tracker by lazy { GoogleAnalytics.getInstance(deviceContext).newTracker(R.xml.tracker) }
    private val exceptionParser by lazy { StandardExceptionParser(this, null) }
    val info: PackageInfo by lazy { getPackageInfo(packageName) }

    fun getPackageInfo(packageName: String) =
            packageManager.getPackageInfo(packageName, PackageManager.GET_SIGNATURES)!!

    fun startService() {
        val intent = Intent(this, BaseService.serviceClass.java)
        if (Build.VERSION.SDK_INT >= 26) startForegroundService(intent) else startService(intent)
    }

    fun reloadService() = sendBroadcast(Intent(Action.RELOAD))
    fun stopService() = sendBroadcast(Intent(Action.CLOSE))

    val currentProfile: Profile? get() = ProfileManager.getProfile(1)

    // send event
    fun track(category: String, action: String) = tracker.send(HitBuilders.EventBuilder()
            .setCategory(category)
            .setAction(action)
            .setLabel(BuildConfig.VERSION_NAME)
            .build())
    fun track(t: Throwable) = track(Thread.currentThread(), t)
    fun track(thread: Thread, t: Throwable) {
        tracker.send(HitBuilders.ExceptionBuilder()
                .setDescription("${exceptionParser.getDescription(thread.name, t)} - ${t.message}")
                .setFatal(false)
                .build())
        t.printStackTrace()
    }

    override fun onCreate() {
        super.onCreate()
        app = this

        checkVersion()

        val lang = Preference.sharedInstance().loadDefaultLanguage()
        if (lang.isEmpty()) {
            val language = Resources.getSystem().configuration.locale.language
            if (language.equals("zh"))
                Preference.sharedInstance().saveDefaultLanguage("CN")
            else
                Preference.sharedInstance().saveDefaultLanguage("US")
        }

        updateNotificationChannels()

        JPushInterface.setDebugMode(true)
        JPushInterface.init(this)
    }

    private fun updateNotificationChannels() {
        if (Build.VERSION.SDK_INT >= 26) @RequiresApi(26) {
            val nm = getSystemService(NotificationManager::class.java)
            nm.createNotificationChannels(listOf(
                    NotificationChannel("service-vpn", getText(R.string.service_vpn),
                            NotificationManager.IMPORTANCE_LOW),
                    NotificationChannel("service-proxy", getText(R.string.service_proxy),
                            NotificationManager.IMPORTANCE_LOW),
                    NotificationChannel("service-transproxy", getText(R.string.service_transproxy),
                            NotificationManager.IMPORTANCE_LOW)))
            nm.deleteNotificationChannel("service-nat") // NAT mode is gone for good
        }
    }

    fun listenForPackageChanges(onetime: Boolean = true, callback: () -> Unit): BroadcastReceiver {
        val filter = IntentFilter(Intent.ACTION_PACKAGE_ADDED)
        filter.addAction(Intent.ACTION_PACKAGE_REMOVED)
        filter.addDataScheme("package")
        val result = object : BroadcastReceiver() {
            override fun onReceive(context: Context, intent: Intent) {
                if (intent.getBooleanExtra(Intent.EXTRA_REPLACING, false)) return
                callback()
                if (onetime) app.unregisterReceiver(this)
            }
        }
        app.registerReceiver(result, filter)
        return result
    }

    fun checkVersion() {
        val orgVer = Preference.sharedInstance().loadVersion()
        if (orgVer < AppGoConfig.VERSION.toFloat()) {
            Preference.sharedInstance().clearAllData()
            Preference.sharedInstance().saveVersion(AppGoConfig.VERSION.toFloat())
        }
    }
}
