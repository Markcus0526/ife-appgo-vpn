package com.appgo.appgopro.views.mine

import android.content.*
import android.net.Uri
import android.os.Bundle
import android.support.v4.content.LocalBroadcastManager
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Button
import android.widget.ImageView
import android.widget.TextView
import com.appgo.appgopro.AppGoConfig
import com.appgo.appgopro.R
import com.appgo.appgopro.controls.AGDialogHelper
import com.appgo.appgopro.models.AGUserData
import com.appgo.appgopro.models.Preference
import com.appgo.appgopro.models.RestService
import com.appgo.appgopro.supers.SuperFragment
import com.appgo.appgopro.utils.AGConstants
import com.appgo.appgopro.utils.Countries
import com.appgo.appgopro.views.LoginActivity
import com.appgo.appgopro.views.MainActivity
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response
import android.graphics.BitmapFactory
import android.graphics.Bitmap
import android.os.Environment
import android.support.v4.content.FileProvider
import java.io.File
import java.io.FileOutputStream
import android.content.Intent.EXTRA_STREAM
import android.content.Intent.ACTION_SEND
import com.appgo.appgopro.R.mipmap.ic_launcher
import java.io.ByteArrayOutputStream
import java.io.IOException


class MeMenuFragment : SuperFragment() {

    private var contentView: View? = null
    private var intentFilter: IntentFilter? = null

    private val mSuccessKF5 = false
    private var userData: AGUserData? = AGUserData()
    private var badgeImg: ImageView? = null

    private var sendEmail = false

    private val broadcastReceiver = object : BroadcastReceiver() {
        override fun onReceive(context: Context, intent: Intent) {
            if (parentActivity == null)
                return

            val action = intent.action
            when (action) {
                AGConstants.BROADCAST_SIGNAL_ACOIN_CHANGED -> {
                    initViewWithData()
                }

                AGConstants.BROADCAST_SIGNAL_NOTIFICATION_RECEIVED -> {
                    val visible = intent.getBooleanExtra("content", false)
                    badgeImg!!.setVisibility(if (visible) View.VISIBLE else View.GONE)
                }
            }
        }
    }

    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View? {
        contentView = super.onCreateView(inflater, container, savedInstanceState)
        if (contentView == null)
            return null

        if (intentFilter == null) {
            intentFilter = IntentFilter()
            intentFilter!!.addAction(AGConstants.BROADCAST_SIGNAL_ACOIN_CHANGED)
            intentFilter!!.addAction(AGConstants.BROADCAST_SIGNAL_NOTIFICATION_RECEIVED)
            LocalBroadcastManager.getInstance(safeContext!!).registerReceiver(broadcastReceiver, intentFilter!!)
        }

        val notificationMenuBtn = contentView!!.findViewById<View>(R.id.notificationMenuBtn) as Button
        notificationMenuBtn.setOnClickListener {
            val fragment = MeNotificationFragment()
            parentActivity!!.showNewFragment(fragment)
        }

        val feedbackMenuBtn = contentView!!.findViewById<View>(R.id.feedbackMenuBtn) as Button
        feedbackMenuBtn.setOnClickListener { feedbackApp() }

        val websiteMenuBtn = contentView!!.findViewById<View>(R.id.websiteMenuBtn) as Button
        websiteMenuBtn.setOnClickListener { websiteApp() }

        val shareMenuBtn = contentView!!.findViewById<View>(R.id.shareMenuBtn) as Button
        shareMenuBtn.setOnClickListener { sharingToAnother() }

        val rateMenuBtn = contentView!!.findViewById<View>(R.id.rateMenuBtn) as Button
        rateMenuBtn.setOnClickListener { rateApp() }

        val aboutMenuBtn = contentView!!.findViewById<View>(R.id.aboutMenuBtn) as Button
        aboutMenuBtn.setOnClickListener {
            val fragment = MeAboutFragment()
            parentActivity!!.showNewFragment(fragment)
        }

        val langMenuBtn = contentView!!.findViewById<View>(R.id.langMenuBtn) as Button
        langMenuBtn.setOnClickListener {
            val fragment = MeLanguageFragment()
            parentActivity!!.showNewFragment(fragment)
        }

        val changepwMenuBtn = contentView!!.findViewById<View>(R.id.changepwMenuBtn) as Button
        changepwMenuBtn.setOnClickListener {
            val fragment = MePasswordFragment()
            parentActivity!!.showNewFragment(fragment)
        }

        val signoutMenuBtn = contentView!!.findViewById<View>(R.id.signoutMenuBtn) as Button
        signoutMenuBtn.setOnClickListener {

            showQuestionDialog(
                    getString(R.string.me_menu_signout),
                    getString(R.string.me_menu_signout_confirm),
                    getString(R.string.yes),
                    getString(R.string.no),
                    object: AGDialogHelper.DialogListener{
                        override fun onOK() {
                            (parentActivity as MainActivity).connectVPNService(null)
                            Preference.sharedInstance().clearLoginData()

                            val i = Intent(parentActivity, LoginActivity::class.java)
                            startActivity(i)
                            parentActivity!!.finish()
                        }

                        override fun onCancel() {

                        }
                    })
        }

        badgeImg = contentView!!.findViewById<ImageView>(R.id.badgeImg)
        badgeImg!!.setVisibility(
                if (Preference.sharedInstance().loadBadgeVisible()) View.VISIBLE else View.GONE
        )

        initViewWithData()
        return contentView
    }


    override fun contentLayout(): Int {
        return R.layout.fragment_me_menu
    }

    private fun initViewWithData() {
        val userCall = RestService.sharedInstance().user()
        userCall.enqueue(object : Callback<AGUserData> {
            override fun onResponse(call: Call<AGUserData>, response: Response<AGUserData>) {
                if (RestService.successResult(response.code())) {
                    userData = response.body()

                    val nickNameText = contentView!!.findViewById<View>(R.id.nickNameText) as TextView
                    nickNameText.text = userData!!.nickname

                    val mobileText = contentView!!.findViewById<View>(R.id.mobileText) as TextView
                    mobileText.text = Countries.sharedInstance().getNativePhoneNumber(userData!!.mobile!!)

                    val acoinValText = contentView!!.findViewById<View>(R.id.acoinValText) as TextView
                    acoinValText.text = Integer.toString(userData!!.acoin)

                    val levelValText = contentView!!.findViewById<View>(R.id.levelValText) as TextView
                    levelValText.text = "LV." + Integer.toString(userData!!.level)
                } else {
                    val i = Intent(parentActivity, LoginActivity::class.java)
                    startActivity(i)
                    parentActivity!!.finish()
                }
            }

            override fun onFailure(call: Call<AGUserData>, t: Throwable) {
                //val i = new Intent(getParentActivity, classOf[LoginActivity])
                //startActivity(i)
                //getParentActivity.finish()
                dismissProgressDialog()
                showErrorDialog(getString(R.string.cant_connect_to_server))
            }
        })
    }

    private fun sharingToAnother() {
        /*val bm = BitmapFactory.decodeResource(resources, R.drawable.logo_mark)
        val extStorageDirectory = safeContext!!.getExternalFilesDir(Environment.DIRECTORY_PICTURES)
        val file = File(extStorageDirectory, "appgo.png")
        var outStream = FileOutputStream(file)
        bm.compress(Bitmap.CompressFormat.PNG, 100, outStream)
        outStream.flush()
        outStream.close()
        val pictureUri = FileProvider.getUriForFile(safeContext!!, safeContext!!.getApplicationContext().getPackageName() + ".fileprovider", file)*/

        val sendIntent = Intent()
        sendIntent.action = Intent.ACTION_SEND
        sendIntent.putExtra(Intent.EXTRA_TEXT, "AppGo: " + AppGoConfig.WEBSITE_URL)
        //sendIntent.putExtra(Intent.EXTRA_STREAM, pictureUri)
        sendIntent.type = "text/plain"
        sendIntent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
        startActivity(Intent.createChooser(sendIntent, getString(R.string.share_appgo_to)))
    }

    private fun feedbackApp() {
        if (!sendEmail) {
            sendEmail = true

            val emailIntent = Intent(Intent.ACTION_SENDTO)
            emailIntent.data = Uri.parse("mailto:" + AppGoConfig.EMAIL_ACCOUNT)
            emailIntent.putExtra(Intent.EXTRA_SUBJECT, resources.getString(R.string.appgo_feedback))
            emailIntent.putExtra(Intent.EXTRA_TEXT, "")

            parentActivity!!.startActivity(emailIntent)

            sendEmail = false
        }
    }

    private fun websiteApp() {
        val browserIntent = Intent(Intent.ACTION_VIEW, Uri.parse(AppGoConfig.WEBSITE_URL))
        startActivity(browserIntent)
    }

    private fun rateApp() {
        val uri = Uri.parse("market://details?id=" + safeContext!!.packageName)
        val goToMarket = Intent(Intent.ACTION_VIEW, uri)
        // To count with Play market backstack, After pressing back button,
        // to taken back to our application, we need to add following flags to intent.
        goToMarket.addFlags(Intent.FLAG_ACTIVITY_NO_HISTORY or
                Intent.FLAG_ACTIVITY_NEW_DOCUMENT or
                Intent.FLAG_ACTIVITY_MULTIPLE_TASK)
        try {
            startActivity(goToMarket)
        } catch (e: ActivityNotFoundException) {
            startActivity(Intent(Intent.ACTION_VIEW,
                    Uri.parse("http://play.google.com/store/apps/details?id=" + safeContext!!.packageName)))
        }

    }

}
