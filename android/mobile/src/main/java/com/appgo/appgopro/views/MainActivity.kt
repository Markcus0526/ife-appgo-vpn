package com.appgo.appgopro.views

import android.app.Activity
import android.app.PendingIntent
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.graphics.PorterDuff
import android.net.Uri
import android.net.VpnService
import android.os.Bundle
import android.os.IBinder
import android.os.RemoteException
import android.support.v4.content.LocalBroadcastManager
import android.view.View
import android.widget.ImageView
import android.widget.TextView
import com.appgo.appgopro.AppGoApplication.Companion.app
import com.appgo.appgopro.AppGoConfig
import com.appgo.appgopro.AppGoConnection
import com.appgo.appgopro.R
import com.appgo.appgopro.aidl.IAppGoService
import com.appgo.appgopro.aidl.IAppGoServiceCallback
import com.appgo.appgopro.controls.AGDialogHelper
import com.appgo.appgopro.models.*
import com.appgo.appgopro.services.BaseService
import com.appgo.appgopro.services.Executable
import com.appgo.appgopro.supers.SuperFragment
import com.appgo.appgopro.supers.SuperTabActivity
import com.appgo.appgopro.utils.AGConstants
import com.appgo.appgopro.utils.AGConstants.BROADCAST_SIGNAL_TRANSFER_CHANGED
import com.appgo.appgopro.utils.AGConstants.BROADCAST_SIGNAL_VPN_STATE_CHANGED
import com.appgo.appgopro.utils.AGConstants.REQCODE_START_VPN_SERVICE_REQUEST
import com.appgo.appgopro.utils.AGConstants.TRANSFER_TIME
import com.appgo.appgopro.utils.thread
import com.appgo.appgopro.views.mine.MeMenuFragment
import com.appgo.appgopro.views.run.RunFragment
import com.appgo.appgopro.views.shop.ShopCountryFragment
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response
import java.util.*

class MainActivity : SuperTabActivity(), AppGoConnection.Interface, IBinder.DeathRecipient {

    private val TAB_COUNT = 3

    private var intentFilter: IntentFilter? = null

    // Fragments
    var runFragment: RunFragment? = null
    var shopFragment: ShopCountryFragment? = null
    var meFragment: MeMenuFragment? = null

    private var transferTimer: Timer? = null

    //private var mService: IAppGoService? = null

    // service
    var state = BaseService.IDLE
    override val serviceCallback: IAppGoServiceCallback.Stub by lazy {
        object : IAppGoServiceCallback.Stub() {
            override fun stateChanged(state: Int, profileName: String?, msg: String?) {
                app.handler.post { changeState(state, msg, true) }
            }
            override fun trafficUpdated(txRate: Long, rxRate: Long, txTotal: Long, rxTotal: Long) {
                app.handler.post { /*updateTraffic(profileId, txRate, rxRate, txTotal, rxTotal)*/ }
            }
            override fun trafficPersisted(profileid: Int) {
                app.handler.post { /*ProfilesFragment.instance?.onTrafficPersisted(profileId)*/ }
            }
        }
    }

    fun changeState(state: Int, msg: String? = null, animate: Boolean = false) {
        val intent = Intent(BROADCAST_SIGNAL_VPN_STATE_CHANGED)
        intent.putExtra("message", state)
        LocalBroadcastManager.getInstance(this).sendBroadcast(intent)

        this.state = state

        //ProfilesFragment.instance?.profilesAdapter?.notifyDataSetChanged()  // refresh button enabled state
        stateListener?.invoke(state)
    }

    private var badgeImg: ImageView? = null

    public override val containerViewId: Int
        get() = R.id.mainLayout

    private val broadcastReceiver = object: BroadcastReceiver() {
        override fun onReceive(context: Context?, intent: Intent?) {
            val action = intent!!.action
            when (action) {
                AGConstants.BROADCAST_SIGNAL_NOTIFICATION_RECEIVED -> {
                    //val visible = intent.getBooleanExtra("content", false)
                    //badgeImg!!.setVisibility(if (visible) View.VISIBLE else View.GONE)
                }
            }
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        intentFilter = IntentFilter()
        intentFilter!!.setPriority(IntentFilter.SYSTEM_HIGH_PRIORITY)
        intentFilter!!.addAction(AGConstants.BROADCAST_SIGNAL_NOTIFICATION_RECEIVED)
        LocalBroadcastManager.getInstance(this).registerReceiver(broadcastReceiver, intentFilter!!)

        runFragment = RunFragment()
        shopFragment = ShopCountryFragment()
        meFragment = MeMenuFragment()

        badgeImg = findViewById(R.id.meBadgeImg)

        val tabArraysList = ArrayList<ArrayList<SuperFragment>>()

        val runFragments = ArrayList<SuperFragment>()
        val shopFragmentArrays = ArrayList<SuperFragment>()
        val meFragments = ArrayList<SuperFragment>()

        runFragments.add(runFragment!!)
        shopFragmentArrays.add(shopFragment!!)
        meFragments.add(meFragment!!)


        tabArraysList.add(runFragments)
        tabArraysList.add(shopFragmentArrays)
        tabArraysList.add(meFragments)

        initializeTabContents(tabArraysList, currentTabIndex)
        tabChangedListener = object : SuperTabActivity.OnTabChangedListener {
            override fun onTabChanged(index: Int) {
                highlightTab(currentTabIndex)
            }
        }
        highlightTab(currentTabIndex)


        transferTimer = Timer()
        transferTimer!!.schedule(object : TimerTask() {
            override fun run() {
                refreshServiceInfo()
            }
        }, TRANSFER_TIME.toLong())

        changeState(BaseService.IDLE)   // reset everything to init state
        app.handler.post { connection.connect() }

        if (AppGoConfig.needVersion)
            checkVersionInfo()
    }

    public override fun onPause() {
        super.onPause()
        transferTimer!!.cancel()
        transferTimer!!.purge()
    }

    public override fun onResume() {
        super.onResume()

        checkNotificationInfo()
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        if (requestCode == AGConstants.REQCODE_START_VPN_SERVICE_REQUEST) {
            if (resultCode == Activity.RESULT_OK) {
                app.startService()

                /*try {
                    val server = Preference.sharedInstance().loadCurrentProfile()
                    if (server != null)
                        connection.connect()
                    else
                        connection.disconnect()
                } catch (e: RemoteException){
                    e.printStackTrace()
                }*/
                //mSelectedCode = data.getStringExtra("code");
                //mSelectCountryBtn.setText(Countries.sharedInstance().getPhoneByCode(mSelectedCode));
            }
            else super.onActivityResult(requestCode, resultCode, data)
        } else if (requestCode == AGConstants.REQCODE_QRCODE_REQUEST) {
            if (resultCode == Activity.RESULT_OK) {
                try {
                    val intent = Intent(AGConstants.BROADCAST_SIGNAL_QRCODE_SCANNED)
                    intent.putExtra("message", AGConstants.BROADCAST_SIGNAL_QRCODE_SCANNED)
                    intent.putExtra("content", data!!.getStringExtra("content"))
                    LocalBroadcastManager.getInstance(this).sendBroadcast(intent)
                } catch (e: RemoteException){
                    e.printStackTrace()
                }
            }
            else super.onActivityResult(requestCode, resultCode, data)
        }
    }

    fun OnRunTabSelected(v: View) {
        selectTab(INDEX_FRAGMENT_RUN, true)
    }

    fun OnShopTabSelected(v: View) {
        selectTab(INDEX_FRAGMENT_SHOP, true)
    }

    fun OnMeTabSelected(v: View) {
        selectTab(INDEX_FRAGMENT_ME, true)
    }

    fun connectVPNService(profile: AGProfile?) {
        if (profile == null) {
            app.stopService()
        } else {
            thread {
                if (BaseService.usingVpnMode) {
                    val intent = VpnService.prepare(this)
                    if (intent != null) startActivityForResult(intent, REQCODE_START_VPN_SERVICE_REQUEST)
                    else app.handler.post { onActivityResult(REQCODE_START_VPN_SERVICE_REQUEST, Activity.RESULT_OK, null) }
                } else app.startService()
            }
        }
    }

    /**
     * Called when a tab has been selected on activity
     */
    override fun selectTab(index: Int, addToFragmentLog: Boolean) {
        if (currentTabIndex == index)
            return

        dismissProgressDialog()
        currentTabIndex = index

        val fragmentsForCurrentTab = fragmentsListArray[currentTabIndex]
        if (fragmentsForCurrentTab.size == 0)
            return

        val topFragment = fragmentsForCurrentTab[fragmentsForCurrentTab.size - 1]
        showFragment(topFragment, ANIM_DIRECTION_FROM_NONE)

        if (tabChangedListener != null)
            tabChangedListener!!.onTabChanged(currentTabIndex)
    }

    override fun initializeTabContents(fragmentsListArray: ArrayList<ArrayList<SuperFragment>>, initialTabIndex: Int) {
        this.fragmentsListArray = fragmentsListArray

        currentTabIndex = initialTabIndex

        val fragmentsForCurrentTab = fragmentsListArray[currentTabIndex]
        if (fragmentsForCurrentTab.size == 0)
            return

        val topFragment = fragmentsForCurrentTab[fragmentsForCurrentTab.size - 1]
        showFragment(topFragment, ANIM_DIRECTION_FROM_NONE)
    }

    private fun highlightTab(index: Int) {
        for (i in 0 until TAB_COUNT) {
            val tabTitle: TextView
            val tabIcon: ImageView
            when (i) {
                0 -> {
                    tabTitle = findViewById(R.id.runTabTitle)
                    tabIcon = findViewById(R.id.runTabIcon)
                }
                1 -> {
                    tabTitle = findViewById(R.id.shopTabTitle)
                    tabIcon = findViewById(R.id.shopTabIcon)
                }
                2 -> {
                    tabTitle = findViewById(R.id.meTabTitle)
                    tabIcon = findViewById(R.id.meTabIcon)
                }
                else -> {
                    tabTitle = findViewById(R.id.runTabTitle)
                    tabIcon = findViewById(R.id.runTabIcon)
                }
            }

            if (i == index) {
                tabTitle.setTextColor(resources.getColor(R.color.colorMain))
                tabIcon.setColorFilter(resources.getColor(R.color.colorMain), PorterDuff.Mode.SRC_ATOP)
            } else {
                tabTitle.setTextColor(resources.getColor(R.color.colorGrayText))
                tabIcon.setColorFilter(resources.getColor(R.color.colorGrayText), PorterDuff.Mode.SRC_ATOP)
            }
        }
    }

    fun popuptoShopCountryFragment() {
        while (true) {
            val topFragment = topFragment
            if (topFragment != null && topFragment !is ShopCountryFragment) {
                popFragment()
            } else {
                break
            }
        }
    }

    private fun refreshServiceInfo() {
        val intent = Intent(BROADCAST_SIGNAL_TRANSFER_CHANGED)
        intent.putExtra("message", BROADCAST_SIGNAL_TRANSFER_CHANGED)
        LocalBroadcastManager.getInstance(this).sendBroadcast(intent)
    }

    /**
     * Service Bound Context
     */
    override fun binderDied() {
        super.binderDied()
        app.handler.post {
            connection.disconnect()
            Executable.killAll()
            connection.connect()
        }
    }

    override fun onServiceConnected(service: IAppGoService) {
        changeState(service.state)
    }

    override fun onServiceDisconnected() {
        changeState(BaseService.IDLE)
    }

    private fun checkNotificationInfo() {
        val notificationsCall: Call<AGNotification> = RestService.sharedInstance().notifications("1", "15")
        notificationsCall.enqueue(object: Callback<AGNotification> {
            override fun onResponse(call: Call<AGNotification>, response: Response<AGNotification>) {
                if (RestService.successResult(response.code())) {
                    val notification = response.body()
                    if (notification!!.notificationDatas.size > 0) {
                        val lastTime = Preference.sharedInstance().loadLastNotificationTime()
                        val newTime = notification.notificationDatas.get(0).updatedAt
                        var visible = false

                        if (newTime.equals("")) return

                        if (lastTime.equals("") || !lastTime.equals(newTime)) {
                            visible = true
                        }

                        Preference.sharedInstance().saveBadgeVisible(visible)
                        val intent = Intent(AGConstants.BROADCAST_SIGNAL_NOTIFICATION_RECEIVED)
                        intent.putExtra("message", AGConstants.BROADCAST_SIGNAL_NOTIFICATION_RECEIVED)
                        intent.putExtra("content", visible)
                        LocalBroadcastManager.getInstance(this@MainActivity).sendBroadcast(intent)
                    }
                } else {
                    //showErrorDialog("failed to connect to server.");
                }
            }

            override fun onFailure(call: Call<AGNotification>, t: Throwable) {}
        })
    }

    private fun checkVersionInfo() {
        AppGoConfig.needVersion = false

        val versionCall = RestService.sharedInstance().getVersion()
        versionCall.enqueue(object: Callback<AGVersion> {
            override fun onResponse(call: Call<AGVersion>, response: Response<AGVersion>) {
                if (RestService.successResult(response.code())) {
                    val result = response.body()
                    val version = result!!.version!!.toFloat()
                    if (version > AppGoConfig.VERSION.toFloat()) {
                        showQuestionDialog("",
                                getString(R.string.new_version_is_available),
                                getString(R.string.yes), getString(R.string.no),
                                object: AGDialogHelper.DialogListener {
                                    override fun onOK () {
                                        val browserIntent = Intent(Intent.ACTION_VIEW, Uri.parse(result!!.link!!))
                                        startActivity(browserIntent)
                                    }
                                    override fun onCancel () {}
                                }
                        )
                    }
                }
            }

            override fun onFailure(call: Call<AGVersion>, t: Throwable) {

            }
        })
    }

    companion object {

        val TAG: String = MainActivity::class.java.name
        val INDEX_FRAGMENT_RUN = 0
        val INDEX_FRAGMENT_SHOP = 1
        val INDEX_FRAGMENT_ME = 2

        fun pendingIntent(context: Context) = PendingIntent.getActivity(context, 0,
                Intent(context, MainActivity::class.java).setFlags(Intent.FLAG_ACTIVITY_REORDER_TO_FRONT), 0)

        var stateListener: ((Int) -> Unit)? = null
    }
}
