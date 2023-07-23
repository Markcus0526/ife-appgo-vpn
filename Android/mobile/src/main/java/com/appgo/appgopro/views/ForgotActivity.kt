package com.appgo.appgopro.views

import android.app.Activity
import android.content.Intent
import android.os.Bundle
import android.os.CountDownTimer
import android.view.View
import android.widget.Button
import android.widget.EditText
import android.widget.ImageView
import com.appgo.appgopro.R
import com.appgo.appgopro.models.AGPassword
import com.appgo.appgopro.models.AGSms
import com.appgo.appgopro.models.RestService
import com.appgo.appgopro.supers.SuperActivity
import com.appgo.appgopro.utils.AGConstants.SMS_COUNT
import com.appgo.appgopro.utils.Countries
import org.json.JSONObject
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response

class ForgotActivity : SuperActivity() {

    private var phoneNumEdit: EditText? = null
    private var smsEdit: EditText? = null
    private var passwordEdit: EditText? = null
    private var selectCountryBtn: Button? = null
    private var smsBtn: Button? = null
    private var selectedCode = ""

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_forgot_password)

        phoneNumEdit = findViewById<View>(R.id.phoneNumEdit) as EditText
        passwordEdit = findViewById<View>(R.id.passwordEdit) as EditText
        smsEdit = findViewById<View>(R.id.smsEdit) as EditText

        selectCountryBtn = findViewById<View>(R.id.countryCodeBtn) as Button
        selectCountryBtn!!.text = Countries.sharedInstance().getPhoneByCode("")
        selectCountryBtn!!.setOnClickListener { selectCountryCode() }

        val countryCodeImg = findViewById<View>(R.id.countryCodeImg) as ImageView
        countryCodeImg.setOnClickListener { selectCountryCode() }

        smsBtn = findViewById<View>(R.id.smsBtn) as Button
        smsBtn!!.setOnClickListener { requestSms() }

        val resetBtn = findViewById<View>(R.id.resetBtn) as Button
        resetBtn.setOnClickListener { resetPassword() }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        if (requestCode == REQ_COUNTRY_SELECT) {
            if (resultCode == Activity.RESULT_OK) {
                selectedCode = data!!.getStringExtra("code")
                selectCountryBtn!!.text = Countries.sharedInstance().getPhoneByCode(selectedCode)
            }
        }
    }

    private fun selectCountryCode() {
        if (selectedCode.isEmpty())
            selectedCode = Countries.sharedInstance().getCodeByPhone(selectCountryBtn!!.text.toString())

        val extra = Bundle()
        extra.putString("code", selectedCode)
        pushNewActivityAnimated(CountryCodeActivity::class.java, extra, REQ_COUNTRY_SELECT)
    }

    private fun requestSms() {
        var mobile = phoneNumEdit!!.text.toString()

        if (mobile.isEmpty()) {
            showErrorDialog(getString(R.string.forgot_password_input_phone_number))
            return
        }

        mobile = selectCountryBtn!!.text.toString() + mobile

        showProgressDialog()

        val smsCall = RestService.sharedInstance().sms("resetPassword", mobile)
        smsCall.enqueue(object : Callback<AGSms> {
            override fun onResponse(call: Call<AGSms>, response: Response<AGSms>) {
                dismissProgressDialog()

                if (RestService.successResult(response.code())) {
                    val result = response.body()

                    object : CountDownTimer(SMS_COUNT.toLong(), 1000) {

                        override fun onTick(millisUntilFinished: Long) {
                            smsBtn!!.isEnabled = false
                            smsBtn!!.text = String.format("%ds", millisUntilFinished / 1000)
                        }

                        override fun onFinish() {
                            smsBtn!!.isEnabled = true
                            smsBtn!!.text = getString(R.string.signup_vfcode_request)
                        }

                    }.start()

                } else {
                    try {
                        val json = JSONObject(response.errorBody()!!.string())
                        showErrorDialog(json.getString("message"))
                    } catch (e: Exception) {
                        showErrorDialog(getString(R.string.cant_connect_to_server))
                    }

                }
            }

            override fun onFailure(call: Call<AGSms>, t: Throwable) {
                dismissProgressDialog()

                showErrorDialog(getString(R.string.cant_connect_to_server))
            }
        })
    }

    private fun resetPassword() {
        var mobile = phoneNumEdit!!.text.toString()
        val verifyCode = smsEdit!!.text.toString()
        val password = passwordEdit!!.text.toString()
        val passconfirmEdit = findViewById<View>(R.id.passconfirmEdit) as EditText
        val confrmPassword = passconfirmEdit.text.toString()

        if (mobile.isEmpty() || verifyCode.isEmpty() || password.isEmpty()) {
            showErrorDialog(getString(R.string.forgot_password_input_all_field))
            return
        }

        if (password != confrmPassword || password.length < 6) {
            showErrorDialog(getString(R.string.forgot_password_dismatch_password))
            return
        }

        mobile = selectCountryBtn!!.text.toString() + mobile

        showProgressDialog(getString(R.string.signing_in))

        val passwordCall = RestService.sharedInstance().password(mobile, password, verifyCode)
        passwordCall.enqueue(object : Callback<AGPassword> {
            override fun onResponse(call: Call<AGPassword>, response: Response<AGPassword>) {
                dismissProgressDialog()

                if (RestService.successResult(response.code())) {
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

            override fun onFailure(call: Call<AGPassword>, t: Throwable) {
                dismissProgressDialog()

                showErrorDialog(getString(R.string.cant_connect_to_server))
            }
        })
    }

    companion object {

        val REQ_COUNTRY_SELECT = 5
    }

}
