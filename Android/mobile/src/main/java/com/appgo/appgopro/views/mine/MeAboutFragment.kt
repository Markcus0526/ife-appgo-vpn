package com.appgo.appgopro.views.mine

import android.content.Intent
import android.net.Uri
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Button
import android.widget.TextView
import com.appgo.appgopro.AppGoConfig
import com.appgo.appgopro.R
import com.appgo.appgopro.models.AGAboutus
import com.appgo.appgopro.models.RestService
import com.appgo.appgopro.supers.SuperFragment
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response

class MeAboutFragment : SuperFragment() {

    private var contentView: View? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
    }

    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View? {
        contentView = super.onCreateView(inflater, container, savedInstanceState)
        if (contentView == null)
            return null

        val twitterBtn = contentView!!.findViewById<Button>(R.id.twitterBtn)
        twitterBtn.setOnClickListener({openTwitter()})
        val telegramBtn = contentView!!.findViewById<Button>(R.id.telegramBtn)
        telegramBtn.setOnClickListener({openTelegram()})

        initViewWithData()

        return contentView
    }

    override fun contentLayout(): Int {
        return R.layout.fragment_me_about
    }

    private fun initViewWithData() {
        showProgressDialog()

        val aboutusCall = RestService.sharedInstance().aboutus()
        aboutusCall.enqueue(object : Callback<AGAboutus> {
            override fun onResponse(call: Call<AGAboutus>, response: Response<AGAboutus>) {
                dismissProgressDialog()

                if (RestService.successResult(response.code())) {
                    val aboutus = response.body()
                    val nickNameText = contentView!!.findViewById<View>(R.id.contentText) as TextView
                    nickNameText.text = aboutus!!.content
                } else {
                    //showErrorDialog("failed to connect to server.");
                }
            }

            override fun onFailure(call: Call<AGAboutus>, t: Throwable) {
                dismissProgressDialog()
            }
        })
    }

    private fun openTwitter() {
        val browserIntent = Intent(Intent.ACTION_VIEW, Uri.parse(AppGoConfig.TWITTER_URL))
        startActivity(browserIntent)
    }

    private fun openTelegram() {
        val browserIntent = Intent(Intent.ACTION_VIEW, Uri.parse(AppGoConfig.TELEGRAM_URL))
        startActivity(browserIntent)
    }
}
