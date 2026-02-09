package com.appgo.appgopro.views.run

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.os.Bundle
import android.os.Handler
import android.os.Message
import android.support.v4.content.LocalBroadcastManager
import android.support.v7.widget.SwitchCompat
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.view.animation.Animation
import android.view.animation.AnimationUtils
import android.widget.*
import com.appgo.appgopro.R
import com.appgo.appgopro.acl.Acl
import com.appgo.appgopro.database.DataStore
import com.appgo.appgopro.models.*
import com.appgo.appgopro.services.BaseService
import com.appgo.appgopro.supers.SuperFragment
import com.appgo.appgopro.utils.AGConstants
import com.appgo.appgopro.utils.AGUtils
import com.appgo.appgopro.utils.Countries
import com.appgo.appgopro.utils.UIManager
import com.appgo.appgopro.views.MainActivity
import com.appgo.appgopro.views.mine.MeNotificationFragment
import org.apache.commons.io.IOUtils
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response
import java.io.BufferedWriter
import java.io.File
import java.io.FileOutputStream
import java.io.FileWriter
import java.text.ParseException
import java.text.SimpleDateFormat
import java.util.*

class RunFragment : SuperFragment() {

    private val TAG = "RunFragment"
    private var contentView: View? = null
    private var nationModeBtn: Button? = null
    private var globalModeBtn: Button? = null
    private var selectedModeBtn: Button? = null
    private var connectImg: ImageView? = null
    private var connectingImg: ImageView? = null
    private var connectingbackImg: ImageView? = null
    private var serverImg: ImageView? = null
    private var detailImg: ImageView? = null
    private var severBtn: Button? = null
    private var udpSwitch: SwitchCompat? = null
    private var connectText: TextView? = null
    private var serverText: TextView? = null
    private var delayText: TextView? = null
    private var transferText: TextView? = null
    private var expireText: TextView? = null
    private var transferProg: ProgressBar? = null
    private var badgeImg: ImageView? = null

    private var intentFilter: IntentFilter? = null

    private var vpnMode: String? = null
    private var connectStatus: Int = 0
    private var curProfile: AGProfile? = null
    private var profileList: List<AGProfile>? = ArrayList()
    private var nationalUpdateTime: String? = null
    private var internationalUpdateTime: String? = null
    private var transferLine: TextView? = null
    private var transferLayout: RelativeLayout? = null
    private var transferProgLayout: RelativeLayout? = null
    private var expireLine: TextView? = null
    private var expireLayout: RelativeLayout? = null
    private var directConnecting: Boolean = false

    // Animation
    private var runAnimRotate: Animation? = null

    private val broadcastReceiver = object : BroadcastReceiver() {
        override fun onReceive(context: Context, intent: Intent) {
            if (parentActivity == null) return
            val action = intent.action
            when (action) {
                AGConstants.BROADCAST_SIGNAL_SERVER_CHANGED -> {
                    curProfile = Preference.sharedInstance().loadCurrentProfile()
                    if (curProfile!!.country.name.equals("CN")) {
                        vpnMode = Acl.ALL
                    } else {
                        vpnMode = Acl.INTERNATIONAL
                    }
                    updateControlValues()
                }

                AGConstants.BROADCAST_SIGNAL_TRANSFER_CHANGED -> {
                    updateServiceTransfer()
                }

                AGConstants.BROADCAST_SIGNAL_VPN_STATE_CHANGED -> {
                    val state = intent.getIntExtra("message", -1)
                    updateConnectionStatus(state)
                }

                AGConstants.BROADCAST_SIGNAL_NOTIFICATION_RECEIVED -> {
                    val visible = intent.getBooleanExtra("content", false)
                    badgeImg!!.setVisibility(if (visible) View.VISIBLE else View.GONE)
                }

                AGConstants.BROADCAST_SIGNAL_PURCHASE_CHANGED -> {
                    updateServiceSelected(object: OnUserServiceResult {
                        override fun finish(success: Boolean) {
                        }
                    })
                }
            }
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        DataStore.initGlobal()
        connectStatus = BaseService.IDLE
    }

    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View? {
        contentView = super.onCreateView(inflater, container, savedInstanceState)
        if (contentView == null)
            return null
        if (intentFilter == null) {
            intentFilter = IntentFilter()
            intentFilter!!.addAction(AGConstants.BROADCAST_SIGNAL_SERVER_CHANGED)
            intentFilter!!.addAction(AGConstants.BROADCAST_SIGNAL_TRANSFER_CHANGED)
            intentFilter!!.addAction(AGConstants.BROADCAST_SIGNAL_VPN_STATE_CHANGED)
            intentFilter!!.addAction(AGConstants.BROADCAST_SIGNAL_NOTIFICATION_RECEIVED)
            intentFilter!!.addAction(AGConstants.BROADCAST_SIGNAL_PURCHASE_CHANGED)
            LocalBroadcastManager.getInstance(safeContext!!).registerReceiver(broadcastReceiver, intentFilter!!)
        }
        connectImg = contentView!!.findViewById<ImageView>(R.id.connectImg)
        connectingImg = contentView!!.findViewById<ImageView>(R.id.connectingImg)
        connectingbackImg = contentView!!.findViewById<ImageView>(R.id.connectingbackImg)
        connectText = contentView!!.findViewById<TextView>(R.id.connectText)
        // load the animation
        runAnimRotate = AnimationUtils.loadAnimation(safeContext, R.anim.rotate)
        serverImg = contentView!!.findViewById<ImageView>(R.id.serverImg)
        detailImg = contentView!!.findViewById<ImageView>(R.id.detailBtn)
        detailImg!!.setOnClickListener({
            val fragment = RunServerFragment()
            parentActivity!!.showNewFragment(fragment)
        })
        serverText = contentView!!.findViewById<TextView>(R.id.serverText)
        delayText = contentView!!.findViewById<TextView>(R.id.delayText)
        transferText = contentView!!.findViewById<TextView>(R.id.transferText)
        expireText = contentView!!.findViewById<TextView>(R.id.expireText)
        val connectBtn = contentView!!.findViewById<Button>(R.id.connectBtn)
        connectBtn.setOnClickListener({
            if (connectStatus == BaseService.IDLE || connectStatus == BaseService.STOPPED) {
                connectVpn()
            } else if (connectStatus == BaseService.CONNECTING) {
            } else if (connectStatus == BaseService.CONNECTED) {
                disconnectVpn()
            }
        })
        severBtn = contentView!!.findViewById<Button>(R.id.selServerBtn)
        severBtn!!.setOnClickListener({
            val fragment = RunServerFragment()
            parentActivity!!.showNewFragment(fragment)
        })
        nationModeBtn = contentView!!.findViewById<Button>(R.id.nationModeBtn)
        nationModeBtn!!.setOnClickListener({
            if (connectStatus == BaseService.CONNECTED && (vpnMode != Acl.CHINA || vpnMode != Acl.INTERNATIONAL)) {
                showAlertDialog("", getString(R.string.change_acceleration_config_after_disconnecting))
            } else {
                curProfile = Preference.sharedInstance().loadCurrentProfile()
                if (curProfile != null) {
                    if (curProfile!!.country.name.equals("CN")) {
                        vpnMode = Acl.ALL
                    } else {
                        vpnMode = Acl.INTERNATIONAL
                    }
                    updateModeStatus()
                }
            }
        })
        globalModeBtn = contentView!!.findViewById<Button>(R.id.globalModeBtn)
        globalModeBtn!!.setOnClickListener({
            if (connectStatus == BaseService.CONNECTED && vpnMode != Acl.ALL) {
                showAlertDialog("", getString(R.string.change_acceleration_config_after_disconnecting))
            } else {
                if (vpnMode != Acl.ALL) {
                    vpnMode = Acl.ALL
                    updateModeStatus()
                }
            }
        })

        udpSwitch = contentView!!.findViewById<SwitchCompat>(R.id.udpSwitch)
        transferProg = contentView!!.findViewById<ProgressBar>(R.id.transferProg)
        transferProg!!.setProgress(0)

        transferLine = contentView!!.findViewById<TextView>(R.id.transferLine)
        transferLayout = contentView!!.findViewById<RelativeLayout>(R.id.transferLayout)
        transferProgLayout = contentView!!.findViewById<RelativeLayout>(R.id.transferProgLayout)
        expireLine = contentView!!.findViewById<TextView>(R.id.expireLine)
        expireLayout = contentView!!.findViewById<RelativeLayout>(R.id.expireLayout)

        directConnecting = false

        val notificationBtn = contentView!!.findViewById<View>(R.id.notificationBtn) as ImageButton
        notificationBtn.setOnClickListener {
            val fragment = MeNotificationFragment()
            parentActivity!!.showNewFragment(fragment)
        }
        badgeImg = contentView!!.findViewById<ImageView>(R.id.badgeImg)

        initViewWithData()
        return contentView
    }


    override fun contentLayout(): Int {
        return R.layout.fragment_run
    }

    private fun connectVpn() {
        if (curProfile == null) {
            showAlertDialog("", getString(R.string.select_server_or_qrcode))
            return
        }

        if (curProfile!!.country.name.equals("CN") && curProfile!!.route == Acl.INTERNATIONAL) {
            showAlertDialog("", getString(R.string.read_notificationas_and_right_acceleration))
            return
        } else if (!curProfile!!.country.name.equals("CN") && curProfile!!.route == Acl.CHINA) {
            showAlertDialog("", getString(R.string.read_notificationas_and_right_acceleration))
            return
        }

        val servicesCall = RestService.sharedInstance().userServices()
        servicesCall.enqueue(object: Callback<List<AGProfile>> {
            override fun onResponse(call: Call<List<AGProfile>>, response: Response<List<AGProfile>>) {
                dismissProgressDialog()
                if (RestService.successResult(response.code())) {
                    profileList = response.body()
                    val serviceArrays = profileList!!.toTypedArray()
                    for (s in serviceArrays) {
                        if (curProfile != null && s.country.id == curProfile!!.country.id) {
                            curProfile = s
                            try {
                                val format = SimpleDateFormat("yyyy-MM-dd HH:mm:ss")
                                val date = format.parse(curProfile!!.expireTime)
                                if (date.before(Date())) {
                                    curProfile = null
                                }
                            } catch (e: ParseException){
                                curProfile = null
                            }
                            if (checkCurProfileExpired()) {
                                showErrorDialog(getString(R.string.profile_is_expired))
                                curProfile = null
                                Preference.sharedInstance().saveCurrentProfile(curProfile)
                                return
                            }
                            updateControlValues()
                            break
                        }
                    }

                    curProfile!!.route = vpnMode!!
                    Preference.sharedInstance().saveCurrentProfile(curProfile)

                    connectingImg!!.setVisibility(View.VISIBLE)
                    connectingImg!!.startAnimation(runAnimRotate)

                    curProfile!!.route = vpnMode!!
                    curProfile!!.udpdns = udpSwitch!!.isChecked
                    curProfile!!.ipv6 = udpSwitch!!.isChecked
                    Preference.sharedInstance().saveLastConnectedRoute(vpnMode!!)
                    Preference.sharedInstance().saveLastUdpEnable(udpSwitch!!.isChecked)

                    var rulename = ""
                    if (curProfile!!.route.equals(Acl.INTERNATIONAL)) {
                        rulename = "android-international"
                    } else if (curProfile!!.route.equals(Acl.CHINA)) {
                        rulename = "android-national"
                    }

                    directConnecting = true

                    if (curProfile!!.route == Acl.INTERNATIONAL || curProfile!!.route == Acl.CHINA) {
                        val ruleUpdateCall = RestService.sharedInstance().ruleUpdatedAt(rulename)
                        ruleUpdateCall.enqueue(object: Callback<AGRuleUpdatedAt> {
                            override fun onResponse(call: Call<AGRuleUpdatedAt>, response: Response<AGRuleUpdatedAt>) {
                                if (RestService.successResult(response.code())) {
                                    val updatedAt = response.body()
                                    val aclFile: File = Acl.getFile(curProfile!!.route)
                                    if (curProfile!!.route.equals(Acl.INTERNATIONAL)) {
                                        if (!updatedAt!!.updatedAt.equals(internationalUpdateTime) || !aclFile.exists()) {
                                            internationalUpdateTime = updatedAt.updatedAt
                                            Preference.sharedInstance().saveInternationalRuleSetTime(internationalUpdateTime!!)

                                            connectVpnWithRule(rulename)
                                        } else {
                                            (parentActivity as MainActivity).connectVPNService(curProfile)
                                        }
                                    } else if (curProfile!!.route.equals(Acl.CHINA)) {
                                        if (!updatedAt!!.updatedAt.equals(nationalUpdateTime) || !aclFile.exists()) {
                                            nationalUpdateTime = updatedAt.updatedAt
                                            Preference.sharedInstance().saveInternationalRuleSetTime(nationalUpdateTime!!)

                                            connectVpnWithRule(rulename)
                                        } else {
                                            (parentActivity as MainActivity).connectVPNService(curProfile)
                                        }
                                    }
                                }
                            }

                            override fun onFailure(call: Call<AGRuleUpdatedAt>, t: Throwable) {
                                updateConnectionStatus(BaseService.STOPPED)
                            }
                        })
                    } else { // global mode
                        if (!curProfile!!.qrCode) {
                            updateServiceSelected(object: OnUserServiceResult {
                                override fun finish(success: Boolean) {
                                    if (curProfile == null) {
                                        updateConnectionStatus(BaseService.STOPPED)
                                    } else {
                                        connectVpnWithGlobal()
                                    }
                                }
                            })
                        } else {
                            connectVpnWithGlobal()
                        }
                    }
                } else {
                    dismissProgressDialog()
                }
            }

            override fun onFailure(call: Call<List<AGProfile>>, t: Throwable) {
                dismissProgressDialog()
                //showErrorDialog(getString(R.string.cant_connect_to_server))
            }
        })
    }

    private fun connectVpnWithRule(rule: String) {
        val ruleCall = RestService.sharedInstance().rule(rule)
        ruleCall.enqueue(object: Callback<AGRule> {
            override fun onResponse(call: Call<AGRule>, response: Response<AGRule>) {
            if (RestService.successResult(response.code())) {
                val rule = response.body()
                var aclFile: File = Acl.getFile(curProfile!!.route)
                val bw = BufferedWriter(FileWriter(aclFile))
                bw.write(rule!!.content)
                bw.close()

                if (!curProfile!!.qrCode) {
                    updateServiceSelected(object: OnUserServiceResult {
                        override fun finish(success: Boolean) {
                            if (curProfile == null) {
                                updateConnectionStatus(BaseService.STOPPED)
                            } else {
                                (parentActivity as MainActivity).connectVPNService(curProfile)
                            }
                        }
                    })
                } else {
                    (parentActivity as MainActivity).connectVPNService(curProfile)
                }
            }
        }

            override fun onFailure(call: Call<AGRule>, t: Throwable) {
            updateConnectionStatus(BaseService.STOPPED)
        }
        })
    }

    private fun connectVpnWithGlobal() {
        val aclFile: File = Acl.getFile(curProfile!!.route)
        val inputStream = AGUtils.sharedInstance().applicationContext.assets.open("acl/global.acl")
        val outputStream = FileOutputStream(aclFile)
        IOUtils.copy(inputStream, outputStream)

        inputStream.close()
        outputStream.close()

        (parentActivity as MainActivity).connectVPNService(curProfile)
    }

    private fun disconnectVpn() {
        connectingImg!!.setVisibility(View.VISIBLE)
        connectingImg!!.startAnimation(runAnimRotate)
        (parentActivity as MainActivity).connectVPNService(null)

        val servicesCall = RestService.sharedInstance().userServices()
        servicesCall.enqueue(object: Callback<List<AGProfile>> {
            override fun onResponse(call: Call<List<AGProfile>>, response: Response<List<AGProfile>>) {
                dismissProgressDialog()
                if (RestService.successResult(response.code())) {
                    profileList = response.body()
                    val serviceArrays = profileList!!.toTypedArray()
                    for (s in serviceArrays) {
                        if (curProfile != null && s.country.id == curProfile!!.country.id) {
                            curProfile = s
                            try {
                                val format = SimpleDateFormat("yyyy-MM-dd HH:mm:ss")
                                val date = format.parse(curProfile!!.expireTime)
                                if (date.before(Date())) {
                                    curProfile = null
                                }
                            } catch (e: ParseException){
                                curProfile = null
                            }
                            if (checkCurProfileExpired()) {
                                showErrorDialog(getString(R.string.profile_is_expired))
                                curProfile = null
                                Preference.sharedInstance().saveCurrentProfile(curProfile)
                                return
                            }
                            Preference.sharedInstance().saveCurrentProfile(curProfile)
                            updateControlValues()
                            break
                        }
                    }
                }
            }

            override fun onFailure(call: Call<List<AGProfile>>, t: Throwable) {
                dismissProgressDialog()
                //showErrorDialog(getString(R.string.cant_connect_to_server))
            }
        })
    }

    private fun testVpnProfile() {
        directConnecting = false

        object: Thread() {
            override fun run() {
                var url: String? = null
                when (curProfile!!.route) {
                    Acl.INTERNATIONAL -> {
                        url = "https://www.youtube.com"
                    }
                    Acl.CHINA -> {
                        url = "https://baidu.com"
                    }
                    Acl.ALL -> {
                        url = "https://www.youtube.com"
                    }
                }

                val ret = AGUtils.sharedInstance().isUrlReachable(url!!, 5000)
                val msg = Message()
                msg.what = if (ret) 1 else 0
                this@RunFragment.threadHandler.sendMessage(msg)
            }
        }.start()
    }

    var threadHandler = object: Handler() {
        override fun handleMessage(msg: Message) {
            if (msg.what == 0) {
                showAlertDialog("", getString(R.string.cant_use_vpnserver))
                connectingImg!!.setVisibility(View.VISIBLE)
                connectingImg!!.startAnimation(runAnimRotate)
                (parentActivity as MainActivity).connectVPNService(null)
            }
        }
    }

    private fun initViewWithData() {
        curProfile = Preference.sharedInstance().loadCurrentProfile()
        internationalUpdateTime = Preference.sharedInstance().loadInternationalRuleSetTime()
        nationalUpdateTime = Preference.sharedInstance().loadNationalRuleSetTime()
        udpSwitch!!.setChecked(Preference.sharedInstance().loadLastUdpEnable())

        var route = Preference.sharedInstance().loadLastConnectedRoute()
        if (route.equals("")) vpnMode = Acl.ALL
        else vpnMode = route
        updateModeStatus()

        if (curProfile != null && !curProfile!!.qrCode) {
            //showProgressDialog()
            updateServiceSelected(object: OnUserServiceResult {
                override fun finish(success: Boolean) {
                    updateControlValues()
                }
            })
        } else {
            updateControlValues()
        }
    }

    private fun updateServiceTransfer() {
        updateControlValues()
    }

    private fun updateControlValues() {
        if (checkCurProfileExpired()) {
            showErrorDialog(getString(R.string.profile_is_expired))
            curProfile = null
            Preference.sharedInstance().saveCurrentProfile(null)
            if (connectStatus == BaseService.CONNECTED) (parentActivity as MainActivity).connectVPNService(null)
        }

        if (curProfile != null) {
            severBtn!!.setText("")
            val drawable = AGUtils.sharedInstance().getFlagDrawable(Countries.sharedInstance().getFlagByCode(curProfile!!.country.name!!))
            serverImg!!.setImageDrawable(drawable)
            val lang = Preference.sharedInstance().loadDefaultLanguage()
            if (lang == "CN") serverText!!.setText(curProfile!!.country.aliasZh!!)
            else serverText!!.setText(curProfile!!.country.aliasEn!!)

            if (curProfile!!.country.name.equals("CN")) {
                nationModeBtn!!.visibility = View.GONE
            } else {
                nationModeBtn!!.setText(R.string.run_vpnmode_in)
                nationModeBtn!!.visibility = View.VISIBLE
            }

            delayText!!.setText(curProfile!!.delayTime)
            transferText!!.setText(String.format("%s / %s",
                    AGUtils.sharedInstance().humanReadableByteCount(curProfile!!.download + curProfile!!.upload, needFloat = true),
                    AGUtils.sharedInstance().humanReadableByteCount(curProfile!!.transferEnable, needFloat = false)))
            transferProg!!.setProgress(((curProfile!!.download + curProfile!!.upload) * 100 / curProfile!!.transferEnable).toInt())
            try {
                var format = SimpleDateFormat("yyyy-MM-dd HH:mm:ss")
                val date = format.parse(curProfile!!.expireTime)
                format = SimpleDateFormat("yyyy-MM-dd")
                expireText!!.setText(format.format(date))
            } catch (e: ParseException){
                expireText!!.setText("")
            }
            if (curProfile!!.qrCode) {
                transferLine!!.setVisibility(View.GONE)
                transferLayout!!.setVisibility(View.GONE)
                transferProgLayout!!.setVisibility(View.GONE)
                expireLine!!.setVisibility(View.GONE)
                expireLayout!!.setVisibility(View.GONE)
            } else {
                transferLine!!.setVisibility(View.VISIBLE)
                transferLayout!!.setVisibility(View.VISIBLE)
                transferProgLayout!!.setVisibility(View.VISIBLE)
                expireLine!!.setVisibility(View.VISIBLE)
                expireLayout!!.setVisibility(View.VISIBLE)
            }
            updateModeStatus()
        } else {
            severBtn!!.setText("")
            serverImg!!.setImageDrawable(null)
            serverText!!.setText(R.string.run_select_server)
            delayText!!.setText("")
            transferText!!.setText("")
            transferProg!!.setProgress(0)
            expireText!!.setText("")
        }
    }

    private fun updateConnectionStatus(state: Int) {
        connectStatus = state
        when (state) {
            BaseService.CONNECTING -> {
                connectImg!!.setImageResource(R.drawable.connect_on)
                connectingImg!!.setVisibility(View.VISIBLE)
                connectingbackImg!!.setVisibility(View.GONE)
                connectText!!.setText(getString(R.string.run_connecting))
                severBtn!!.setTextColor(UIManager.sharedInstance().getColor(R.color.colorGrayText))
                severBtn!!.setEnabled(false)
                nationModeBtn!!.setEnabled(false)
                globalModeBtn!!.setEnabled(false)
                selectedModeBtn!!.setBackgroundResource(R.drawable.vfcode_button_disable)
                serverText!!.setTextColor(UIManager.sharedInstance().getColor(R.color.colorGrayText))
                delayText!!.setTextColor(UIManager.sharedInstance().getColor(R.color.colorGrayText))
                udpSwitch!!.setEnabled(false)
                transferText!!.setTextColor(UIManager.sharedInstance().getColor(R.color.colorGrayText))
                expireText!!.setTextColor(UIManager.sharedInstance().getColor(R.color.colorGrayText))
            }

            BaseService.CONNECTED -> {
                //AGLogger.log(TAG, "directConnecting is false")
                connectImg!!.setImageResource(R.drawable.connect_on)
                connectingImg!!.setVisibility(View.GONE)
                connectingbackImg!!.setVisibility(View.VISIBLE)
                connectingImg!!.clearAnimation()
                connectText!!.setText(getString(R.string.run_connected))
                severBtn!!.setTextColor(UIManager.sharedInstance().getColor(R.color.colorGrayText))
                severBtn!!.setEnabled(false)
                nationModeBtn!!.setEnabled(true)
                globalModeBtn!!.setEnabled(true)
                selectedModeBtn!!.setBackgroundResource(R.drawable.vfcode_button)
                serverText!!.setTextColor(UIManager.sharedInstance().getColor(R.color.colorGrayText))
                delayText!!.setTextColor(UIManager.sharedInstance().getColor(R.color.colorGrayText))
                udpSwitch!!.setEnabled(false)
                transferText!!.setTextColor(UIManager.sharedInstance().getColor(R.color.colorGrayText))
                expireText!!.setTextColor(UIManager.sharedInstance().getColor(R.color.colorGrayText))
            }

            BaseService.STOPPING -> {
                connectImg!!.setImageResource(R.drawable.connect_on)
                connectingImg!!.setVisibility(View.VISIBLE)
                connectingbackImg!!.setVisibility(View.VISIBLE)
                connectText!!.setText(getString(R.string.run_disconnecting))
                severBtn!!.setTextColor(UIManager.sharedInstance().getColor(R.color.colorGrayText))
                severBtn!!.setEnabled(false)
                nationModeBtn!!.setEnabled(false)
                globalModeBtn!!.setEnabled(false)
                selectedModeBtn!!.setBackgroundResource(R.drawable.vfcode_button_disable)
                serverText!!.setTextColor(UIManager.sharedInstance().getColor(R.color.colorGrayText))
                delayText!!.setTextColor(UIManager.sharedInstance().getColor(R.color.colorGrayText))
                udpSwitch!!.setEnabled(false)
                transferText!!.setTextColor(UIManager.sharedInstance().getColor(R.color.colorGrayText))
                expireText!!.setTextColor(UIManager.sharedInstance().getColor(R.color.colorGrayText))
            }

            BaseService.STOPPED -> {
                connectImg!!.setImageResource(R.drawable.connect_off)
                connectingImg!!.setVisibility(View.GONE)
                connectingbackImg!!.setVisibility(View.GONE)
                connectingImg!!.clearAnimation()
                connectText!!.setText(getString(R.string.run_tap_to_connect))
                severBtn!!.setTextColor(UIManager.sharedInstance().getColor(R.color.colorMain))
                severBtn!!.setEnabled(true)
                nationModeBtn!!.setEnabled(true)
                globalModeBtn!!.setEnabled(true)
                selectedModeBtn!!.setBackgroundResource(R.drawable.vfcode_button)
                serverText!!.setTextColor(UIManager.sharedInstance().getColor(R.color.colorMain))
                delayText!!.setTextColor(UIManager.sharedInstance().getColor(R.color.countryCode))
                udpSwitch!!.setEnabled(true)
                transferText!!.setTextColor(UIManager.sharedInstance().getColor(R.color.colorMain))
                expireText!!.setTextColor(UIManager.sharedInstance().getColor(R.color.colorMain))

                if (curProfile != null && !curProfile!!.qrCode) {
                    updateServiceSelected(object: OnUserServiceResult {
                        override fun finish(success: Boolean) {
                            updateControlValues()
                        }
                    })
                }
            }

            else -> {
                connectText!!.setText("")
                severBtn!!.setTextColor(UIManager.sharedInstance().getColor(R.color.colorMain))
                severBtn!!.setEnabled(true)
                nationModeBtn!!.setEnabled(true)
                globalModeBtn!!.setEnabled(true)
                selectedModeBtn!!.setBackgroundResource(R.drawable.vfcode_button)
                serverText!!.setTextColor(UIManager.sharedInstance().getColor(R.color.colorMain))
                delayText!!.setTextColor(UIManager.sharedInstance().getColor(R.color.countryCode))
                udpSwitch!!.setEnabled(true)
                transferText!!.setTextColor(UIManager.sharedInstance().getColor(R.color.colorMain))
                expireText!!.setTextColor(UIManager.sharedInstance().getColor(R.color.colorMain))
            }
        }
    }

    private fun updateModeStatus() {
        nationModeBtn!!.setBackgroundResource(R.drawable.vfcode_button_deselect)
        nationModeBtn!!.setTextColor(UIManager.sharedInstance().getColor(R.color.colorGrayText))
        globalModeBtn!!.setBackgroundResource(R.drawable.vfcode_button_deselect)
        globalModeBtn!!.setTextColor(UIManager.sharedInstance().getColor(R.color.colorGrayText))

        when (vpnMode) {
            Acl.INTERNATIONAL -> {
                nationModeBtn!!.setBackgroundResource(R.drawable.vfcode_button)
                nationModeBtn!!.setTextColor(UIManager.sharedInstance().getColor(R.color.colorWhite))
                selectedModeBtn = nationModeBtn
            }

            Acl.CHINA -> {
                nationModeBtn!!.setBackgroundResource(R.drawable.vfcode_button)
                nationModeBtn!!.setTextColor(UIManager.sharedInstance().getColor(R.color.colorWhite))
                selectedModeBtn = nationModeBtn
            }

            Acl.ALL -> {
                globalModeBtn!!.setBackgroundResource(R.drawable.vfcode_button)
                globalModeBtn!!.setTextColor(UIManager.sharedInstance().getColor(R.color.colorWhite))
                selectedModeBtn = globalModeBtn
            }
        }
    }

    private fun updateServiceSelected(serviceResult: OnUserServiceResult) {
        val servicesCall = RestService.sharedInstance().userServices()
        servicesCall.enqueue(object: Callback<List<AGProfile>> {
            override fun onResponse(call: Call<List<AGProfile>>, response: Response<List<AGProfile>>) {
                dismissProgressDialog()
                if (RestService.successResult(response.code())) {
                    profileList = response.body()
                    val serviceArrays = profileList!!.toTypedArray()
                    for (s in serviceArrays) {
                        if (curProfile != null && s.country.id == curProfile!!.country.id) {
                            curProfile = s
                            try {
                                val format = SimpleDateFormat("yyyy-MM-dd HH:mm:ss")
                                val date = format.parse(curProfile!!.expireTime)
                                if (date.before(Date())) {
                                    curProfile = null
                                }
                            } catch (e: ParseException){
                                curProfile = null
                            }
                            if (curProfile!!.transferEnable < (curProfile!!.upload + curProfile!!.download)) {
                                curProfile = null
                            }
                            break
                        }
                    }
                    serviceResult.finish(true)
                } else {
                    serviceResult.finish(false)
                }

                updateControlValues()
            }

            override fun onFailure(call: Call<List<AGProfile>>, t: Throwable) {
                dismissProgressDialog()
            }
        })
    }

    private fun checkCurProfileExpired() : Boolean {
        var expired = false
        if (curProfile != null) {
            if (curProfile!!.expireTime != null) {
                var format = SimpleDateFormat("yyyy-MM-dd HH:mm:ss")
                val date = format.parse(curProfile!!.expireTime)
                val current = Date()

                expired = when {
                    date <= current -> true
                    date > current -> false
                    else -> true
                }
                if (curProfile!!.transferEnable < (curProfile!!.upload+curProfile!!.download)) {
                    expired = true
                }
            }
        }
        return expired
    }

    //define callback interface
    interface OnUserServiceResult {
        fun finish(success: Boolean)
    }
}
