package com.appgo.appgopro.views

import android.app.Activity
import android.os.Bundle
import android.view.View
import android.widget.TextView

import com.appgo.appgopro.R
import com.appgo.appgopro.models.AGTos
import com.appgo.appgopro.models.RestService
import com.appgo.appgopro.supers.SuperActivity

import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response

/**
 * Created by KSMA on 4/23/2017.
 */

class TermUseActivity : SuperActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_term)

        initViewWithData()
    }

    override fun onBackPressed() {
        setResult(Activity.RESULT_CANCELED)
        finish()
    }

    private fun initViewWithData() {
        showProgressDialog()

        val tosCall = RestService.sharedInstance().tos()
        tosCall.enqueue(object : Callback<AGTos> {

            override fun onResponse(call: Call<AGTos>, response: Response<AGTos>) {
                dismissProgressDialog()

                if (RestService.successResult(response.code())) {
                    val tos = response.body()

                    val contentText = findViewById<View>(R.id.contentText) as TextView
                    contentText.text = tos!!.content

                } else {
                    //showErrorDialog("failed to connect to server.");
                }
            }

            override fun onFailure(p0: Call<AGTos>?, p1: Throwable?) {
                dismissProgressDialog()
            }
        })
    }

}
