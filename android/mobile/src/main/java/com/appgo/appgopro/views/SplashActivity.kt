package com.appgo.appgopro.views

import android.content.Intent
import android.net.Uri
import android.os.Bundle
import android.os.Handler
import com.appgo.appgopro.AppGoApplication.Companion.app
import com.appgo.appgopro.AppGoConfig
import com.appgo.appgopro.R
import com.appgo.appgopro.controls.AGDialogHelper
import com.appgo.appgopro.models.AGLogin
import com.appgo.appgopro.models.AGVersion
import com.appgo.appgopro.models.Preference
import com.appgo.appgopro.models.RestService
import com.appgo.appgopro.supers.SuperActivity
import com.appgo.appgopro.utils.AGLogger
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response
import java.io.File
import java.io.IOException
import java.net.HttpURLConnection
import java.net.URL
import com.crashlytics.android.Crashlytics;
import io.fabric.sdk.android.Fabric;


class SplashActivity : SuperActivity() {
    private val TAG = "SplashActivity"

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_splash)

        val param = intent.getStringExtra("status")
        if (param != null && param == "language_changed") {
            Handler().postDelayed({
                pushNewActivityAnimated(MainActivity::class.java)
                popOverCurActivityAnimated()
            }, SPLASH_TIME_OUT.toLong())
        } else {
            Handler().postDelayed({
                loadAssetFiles()
                getHostUrl()
            }, SPLASH_TIME_OUT.toLong())
        }

        Fabric.with(this, Crashlytics())
    }

    private fun loadAssetFiles() {
        val assetManager = assets
        for (dir in arrayOf("acl", "overture"))
            try {
                for (file in assetManager.list(dir)) assetManager.open(dir + '/' + file).use { input ->
                    File(app.deviceContext.filesDir, file).outputStream().use { output -> input.copyTo(output) }
                }
            } catch (e: IOException) {
                AGLogger.log(TAG, e.message!!)
            }
    }

    private fun getHostUrl() {
        Thread(Runnable {
            val connection = URL(RestService.BASE_URL).openConnection() as HttpURLConnection
            try {
                val data = connection.inputStream.bufferedReader().readText()
                Preference.sharedInstance().saveBaseUrl(data.trim())
                RestService.setupRestClient()
                //Preference.sharedInstance().saveBaseUrl("https://dev.qqmailer.com")
                //RestService.setupRestClient()

                if (Preference.sharedInstance().isLogined) {
                    checkLoginInfo()
                } else {
                    val disable = Preference.sharedInstance().loadWelcomeDisable()
                    if (!disable) {
                        pushNewActivityAnimated(TourActivity::class.java)
                    } else {
                        pushNewActivityAnimated(LoginActivity::class.java)
                    }

                    popOverCurActivityAnimated()
                }

            } catch (ex: Exception) {
                AGLogger.log(TAG, ex.toString())
            } finally {
                connection.disconnect()
            }
        }).start()
    }

    private fun checkLoginInfo() {
        val username = Preference.sharedInstance().loadUserName()
        val password = Preference.sharedInstance().loadPassword()
        val loginCall = RestService.sharedInstance().login(username, password)

        loginCall.enqueue(object: Callback<AGLogin> {
            override fun onResponse(call: Call<AGLogin>, response: Response<AGLogin>) {
                if (RestService.successResult(response.code())) {
                    val result = response.body()
                    Preference.sharedInstance().saveUserToken(result!!.accessToken!!)
                    RestService.setupRestClient()

                    pushNewActivityAnimated(MainActivity::class.java)
                } else {
                    pushNewActivityAnimated(LoginActivity::class.java)
                }

                popOverCurActivityAnimated()
            }

            override fun onFailure(call: Call<AGLogin>, t: Throwable) {
                pushNewActivityAnimated(LoginActivity::class.java)
                popOverCurActivityAnimated()
            }
        })
    }


    companion object {
        private val SPLASH_TIME_OUT = 1000
    }
}
