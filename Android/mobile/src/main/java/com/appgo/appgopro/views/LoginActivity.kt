package com.appgo.appgopro.views

import android.Manifest
import android.app.Activity
import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import android.os.Bundle
import android.support.v4.app.ActivityCompat
import android.support.v4.content.ContextCompat
import android.view.View
import android.widget.Button
import android.widget.EditText
import android.widget.ImageView
import com.appgo.appgopro.AppGoConfig
import com.appgo.appgopro.R
import com.appgo.appgopro.controls.AGDialogHelper
import com.appgo.appgopro.models.AGLogin
import com.appgo.appgopro.models.AGVersion
import com.appgo.appgopro.models.Preference
import com.appgo.appgopro.models.RestService
import com.appgo.appgopro.supers.SuperActivity
import com.appgo.appgopro.utils.AGConstants.PERMISSION_REQUEST_STORAGE
import com.appgo.appgopro.utils.AGLogger
import com.appgo.appgopro.utils.Countries
import org.json.JSONObject
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response


class LoginActivity : SuperActivity() {

    private var phoneNumEdit: EditText? = null
    private var passwordEdit: EditText? = null
    private var selectCountryBtn: Button? = null

    private var selectedCode = ""

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_login)

        phoneNumEdit = findViewById<View>(R.id.phoneNumEdit) as EditText
        passwordEdit = findViewById<View>(R.id.passwordEdit) as EditText

        selectCountryBtn = findViewById<View>(R.id.countryCodeBtn) as Button
        selectCountryBtn!!.text = Countries.sharedInstance().getPhoneByCode("")
        selectCountryBtn!!.setOnClickListener { selectCountryCode() }

        val countryCodeImg = findViewById<View>(R.id.countryCodeImg) as ImageView
        countryCodeImg.setOnClickListener { selectCountryCode() }

        val loginBtn = findViewById<View>(R.id.loginBtn) as Button
        loginBtn.setOnClickListener { login() }

        val signupBtn = findViewById<View>(R.id.signupBtn) as Button
        signupBtn.setOnClickListener { pushNewActivityAnimated(SignupActivity::class.java) }

        val forgotPasswordBtn = findViewById<View>(R.id.forgotPasswordBtn) as Button
        forgotPasswordBtn.setOnClickListener { pushNewActivityAnimated(ForgotActivity::class.java) }


        checkStoragePermission()

        if (AppGoConfig.needVersion)
            checkVersionInfo()
        //phoneNumEdit.setText("15524249274");
        //passwordEdit.setText("123456");
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        if (requestCode == REQ_COUNTRY_SELECT) {
            if (resultCode == Activity.RESULT_OK) {
                selectedCode = data!!.getStringExtra("code")
                selectCountryBtn!!.text = Countries.sharedInstance().getPhoneByCode(selectedCode)
            }
        }
    }

    private fun login() {
        var username = phoneNumEdit!!.text.toString()
        val password = passwordEdit!!.text.toString()

        if (username.isEmpty()) {
            showErrorDialog(getString(R.string.login_input_phone_number))
            return
        }

        if (password.isEmpty()) {
            showErrorDialog(getString(R.string.login_input_password))
            return
        }

        username = selectCountryBtn!!.text.toString() + username

        showProgressDialog(getString(R.string.signing_in))

        val loginCall = RestService.sharedInstance().login(username, password)
        loginCall.enqueue(object : Callback<AGLogin> {
            override fun onResponse(call: Call<AGLogin>, response: Response<AGLogin>) {
                dismissProgressDialog()

                if (RestService.successResult(response.code())) {
                    val result = response.body()
                    val oldUser = Preference.sharedInstance().loadUserName()
                    if (!oldUser.equals(selectCountryBtn!!.text.toString() + phoneNumEdit!!.text.toString())) {
                        Preference.sharedInstance().saveCurrentProfile(null)
                    }
                    Preference.sharedInstance().saveLoginData(selectCountryBtn!!.text.toString() + phoneNumEdit!!.text.toString(), passwordEdit!!.text.toString(), result)

                    RestService.userToken = result!!.accessToken
                    RestService.setupRestClient()

                    pushNewActivityAnimated(MainActivity::class.java)
                    popOverCurActivityAnimated()
                } else {
                    try {
                        val json = JSONObject(response.errorBody()!!.string())
                        showErrorDialog(json.getString("message"))
                    } catch (e: Exception) {
                        showErrorDialog(getString(R.string.cant_connect_to_server))
                    }
                }
            }

            override fun onFailure(call: Call<AGLogin>, t: Throwable) {
                dismissProgressDialog()
                showErrorDialog(getString(R.string.cant_connect_to_server))
            }
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

    private fun selectCountryCode() {
        if (selectedCode.isEmpty())
            selectedCode = Countries.sharedInstance().getCodeByPhone(selectCountryBtn!!.text.toString())

        val extra = Bundle()
        extra.putString("code", selectedCode)
        pushNewActivityAnimated(CountryCodeActivity::class.java, extra, REQ_COUNTRY_SELECT)
    }

    override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<String>, grantResults: IntArray) {
        when (requestCode) {
            PERMISSION_REQUEST_STORAGE -> {
                if (grantResults.size > 0 && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                    //Intent intent = new Intent(AGConstants.BROADCAST_SIGNAL_STORAGE_PERMISSION_SUCCESS);
                    //LocalBroadcastManager.getInstance(this).sendBroadcast(intent);
                } else {
                    //Intent intent = new Intent(AGConstants.BROADCAST_SIGNAL_STORAGE_PERMISSION_FAILED);
                    //LocalBroadcastManager.getInstance(this).sendBroadcast(intent);
                }
            }
        }// other 'case' lines to check for other
        // permissions this app might request
    }

    private fun checkStoragePermission() {
        if (ContextCompat.checkSelfPermission(this,
                Manifest.permission.WRITE_EXTERNAL_STORAGE) != PackageManager.PERMISSION_GRANTED) {

            ActivityCompat.requestPermissions(this@LoginActivity,
                    arrayOf(Manifest.permission.WRITE_EXTERNAL_STORAGE),
                    PERMISSION_REQUEST_STORAGE)
        } else {
            AGLogger.log("Help", "have already storage permission")
        }
    }

    companion object {
        val REQ_COUNTRY_SELECT = 2
    }
}
