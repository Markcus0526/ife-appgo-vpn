package com.appgo.appgopro.views.mine

import android.os.Bundle
import android.os.CountDownTimer
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Button
import android.widget.EditText
import com.appgo.appgopro.R
import com.appgo.appgopro.models.AGPassword
import com.appgo.appgopro.models.AGSms
import com.appgo.appgopro.models.Preference
import com.appgo.appgopro.models.RestService
import com.appgo.appgopro.supers.SuperFragment
import com.appgo.appgopro.utils.AGConstants.SMS_COUNT
import org.json.JSONObject
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response

class MePasswordFragment : SuperFragment() {

    private var contentView: View? = null
    private var smsEdit: EditText? = null
    private var oldPPassEdit: EditText? = null
    private var newPassEdit: EditText? = null
    private var smsBtn: Button? = null

    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View? {
        contentView = super.onCreateView(inflater, container, savedInstanceState)
        if (contentView == null)
            return null

        oldPPassEdit = contentView!!.findViewById<View>(R.id.oldPassEdit) as EditText
        newPassEdit = contentView!!.findViewById<View>(R.id.newPassEdit) as EditText
        smsEdit = contentView!!.findViewById<View>(R.id.smsEdit) as EditText

        smsBtn = contentView!!.findViewById<View>(R.id.smsBtn) as Button
        smsBtn!!.setOnClickListener { requestSms() }

        val resetBtn = contentView!!.findViewById<View>(R.id.passwordBtn) as Button
        resetBtn.setOnClickListener { resetPassword() }

        return contentView
    }

    override fun contentLayout(): Int {
        return R.layout.fragment_me_password
    }

    private fun requestSms() {
        val mobile = Preference.sharedInstance().loadUserName()

        if (mobile.isEmpty()) {
            showErrorDialog(getString(R.string.forgot_password_input_phone_number))
            return
        }

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
        val mobile = Preference.sharedInstance().loadUserName()
        val verifyCode = smsEdit!!.text.toString()
        val password = newPassEdit!!.text.toString()
        val passconfirmEdit = contentView!!.findViewById<View>(R.id.confirmPassEdit) as EditText
        val confrmPassword = passconfirmEdit.text.toString()

        if (verifyCode.isEmpty() || password.isEmpty()) {
            showErrorDialog(getString(R.string.forgot_password_input_all_field))
            return
        }

        if (password != confrmPassword || password.length < 6) {
            showErrorDialog(getString(R.string.forgot_password_dismatch_password))
            return
        }

        showProgressDialog(getString(R.string.signing_in))

        val passwordCall = RestService.sharedInstance().password(mobile, password, verifyCode)
        passwordCall.enqueue(object : Callback<AGPassword> {
            override fun onResponse(call: Call<AGPassword>, response: Response<AGPassword>) {
                dismissProgressDialog()

                if (RestService.successResult(response.code())) {
                    onClickedBackButton()
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

}
