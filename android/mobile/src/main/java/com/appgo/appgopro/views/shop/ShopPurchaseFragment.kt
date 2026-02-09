package com.appgo.appgopro.views.shop

import android.annotation.SuppressLint
import android.content.Intent
import android.os.Bundle
import android.os.Handler
import android.os.Message
import android.support.v4.content.LocalBroadcastManager
import android.text.TextUtils
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Button
import android.widget.ImageButton
import android.widget.TextView
import com.alipay.sdk.app.PayTask
import com.appgo.appgopro.R
import com.appgo.appgopro.controls.AGDialogHelper
import com.appgo.appgopro.models.*
import com.appgo.appgopro.supers.SuperFragment
import com.appgo.appgopro.utils.AGConstants.BROADCAST_SIGNAL_ACOIN_CHANGED
import com.appgo.appgopro.utils.AGConstants.BROADCAST_SIGNAL_PURCHASE_CHANGED
import com.appgo.appgopro.utils.AGUtils
import com.appgo.appgopro.utils.AlipayResult
import com.appgo.appgopro.views.MainActivity
import org.json.JSONObject
import org.w3c.dom.Text
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response

class ShopPurchaseFragment : SuperFragment() {

    private var contentView: View? = null
    private var pay1Btn: ImageButton? = null
    private var pay2Btn: ImageButton? = null
    private var pay3Btn: ImageButton? = null
    private var pay1Txt: TextView? = null
    private var pay2Txt: TextView? = null
    private var pay3Txt: TextView? = null

    var pack: AGPack? = null
    var country: AGCountry? = null
    private var cart: AGCart? = null
    private var paySwitch: AGPayment? = null

    private val ALIPAY = "alipay"
    private val GLOBALALIPAY = "globalAlipayApp"
    private val ACOIN = "acoin"
    private var payMethod = ""
    private var paymentCount = 0;

    @SuppressLint("HandlerLeak")
    private val alipayHandler = object : Handler() {
        override fun handleMessage(msg: Message) {
            when (msg.what) {
                ALIPAY_PAY_FLAG -> {
                    val payResult = AlipayResult(msg.obj as Map<String, String>)
                    /**
                     * 对于支付结果，请商户依赖服务端的异步通知结果。同步通知结果，仅作为支付结束的通知。
                     */
                    val resultInfo = payResult.result// 同步返回需要验证的信息
                    val resultStatus = payResult.resultStatus

                    if (TextUtils.equals(resultStatus, "9000")) {
                        showAlertDialog("", getString(R.string.paid_successfully), object : AGDialogHelper.DialogListener {
                            override fun onOK() {
                                val intent = Intent(BROADCAST_SIGNAL_PURCHASE_CHANGED)
                                intent.putExtra("message", BROADCAST_SIGNAL_PURCHASE_CHANGED)
                                LocalBroadcastManager.getInstance(safeContext!!).sendBroadcast(intent)

                                (parentActivity as MainActivity).popuptoShopCountryFragment()
                            }

                            override fun onCancel() {}
                        })
                    } else {
                        showErrorDialog(getString(R.string.failed_to_pay_with_alipay))
                    }
                }
            }
        }
    }

    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View? {
        contentView = super.onCreateView(inflater, container, savedInstanceState)
        if (contentView == null)
            return null

        val durationText = contentView!!.findViewById<View>(R.id.durationText) as TextView
        val transferText = contentView!!.findViewById<View>(R.id.transferText) as TextView
        val serverNameText = contentView!!.findViewById<View>(R.id.serverNameText) as TextView
        val priceText = contentView!!.findViewById<View>(R.id.priceText) as TextView

        if (pack != null) {
            durationText.setText("%d %s".format(pack!!.duration, resources.getString(R.string.day)))
            transferText.setText(String.format("%s", AGUtils.sharedInstance().humanReadableByteCount(pack!!.transfer, needFloat = false)))
            priceText.setText("%s %d %s".format(resources.getString(R.string.currency), pack!!.price, resources.getString(R.string.unit)))
        }
        if (country != null) {
            val lang = Preference.sharedInstance().loadDefaultLanguage()
            if (lang == "CN")
                serverNameText!!.setText(country!!.aliasZh!!)
            else
                serverNameText!!.setText(country!!.aliasEn!!)
        }

        pay1Btn = contentView!!.findViewById<View>(R.id.pay1Btn) as ImageButton
        pay2Btn = contentView!!.findViewById<View>(R.id.pay2Btn) as ImageButton
        pay3Btn = contentView!!.findViewById<View>(R.id.pay3Btn) as ImageButton

        pay1Txt = contentView!!.findViewById<View>(R.id.pay1Txt) as TextView
        pay2Txt = contentView!!.findViewById<View>(R.id.pay2Txt) as TextView
        pay3Txt = contentView!!.findViewById<View>(R.id.pay3Txt) as TextView

        pay1Btn!!.visibility = View.GONE
        pay2Btn!!.visibility = View.GONE
        pay3Btn!!.visibility = View.GONE

        pay1Btn!!.setOnClickListener {
            if (pay1Txt!!.text.equals(ALIPAY) || pay1Txt!!.text.equals(GLOBALALIPAY))
                pay1Btn!!.setImageResource(R.drawable.alipay)
            else
                pay1Btn!!.setImageResource(R.drawable.acoin)

            if (pay2Txt!!.text.equals(ALIPAY) || pay2Txt!!.text.equals(GLOBALALIPAY))
                pay2Btn!!.setImageResource(R.drawable.alipay_gray)
            else
                pay2Btn!!.setImageResource(R.drawable.acoin_gray)

            if (pay3Txt!!.text.equals(ALIPAY) || pay3Txt!!.text.equals(GLOBALALIPAY))
                pay3Btn!!.setImageResource(R.drawable.alipay_gray)
            else
                pay3Btn!!.setImageResource(R.drawable.acoin_gray)

            payMethod = pay1Txt!!.text.toString()
        }

        pay2Btn!!.setOnClickListener {
            if (pay2Txt!!.text.equals(ALIPAY) || pay2Txt!!.text.equals(GLOBALALIPAY))
                pay2Btn!!.setImageResource(R.drawable.alipay)
            else
                pay2Btn!!.setImageResource(R.drawable.acoin)

            if (pay1Txt!!.text.equals(ALIPAY) || pay1Txt!!.text.equals(GLOBALALIPAY))
                pay1Btn!!.setImageResource(R.drawable.alipay_gray)
            else
                pay1Btn!!.setImageResource(R.drawable.acoin_gray)

            if (pay3Txt!!.text.equals(ALIPAY) || pay3Txt!!.text.equals(GLOBALALIPAY))
                pay3Btn!!.setImageResource(R.drawable.alipay_gray)
            else
                pay3Btn!!.setImageResource(R.drawable.acoin_gray)

            payMethod = pay2Txt!!.text.toString()
        }

        pay3Btn!!.setOnClickListener {
            if (pay3Txt!!.text.equals(ALIPAY) || pay3Txt!!.text.equals(GLOBALALIPAY))
                pay3Btn!!.setImageResource(R.drawable.alipay)
            else
                pay3Btn!!.setImageResource(R.drawable.acoin)

            if (pay1Txt!!.text.equals(ALIPAY) || pay1Txt!!.text.equals(GLOBALALIPAY))
                pay1Btn!!.setImageResource(R.drawable.alipay_gray)
            else
                pay1Btn!!.setImageResource(R.drawable.acoin_gray)

            if (pay2Txt!!.text.equals(ALIPAY) || pay2Txt!!.text.equals(GLOBALALIPAY))
                pay2Btn!!.setImageResource(R.drawable.alipay_gray)
            else
                pay2Btn!!.setImageResource(R.drawable.acoin_gray)

            payMethod = pay3Txt!!.text.toString()
        }

        val payBtn = contentView!!.findViewById<View>(R.id.buynowBtn) as Button
        payBtn.setOnClickListener { payNow() }

        getSwitch();

        return contentView
    }

    override fun contentLayout(): Int {
        return R.layout.fragment_shop_purchase
    }

    fun getSwitch() {
        val cartCall = RestService.sharedInstance().paySwitch()
        cartCall.enqueue(object : Callback<AGPayment> {
            override fun onResponse(call: Call<AGPayment>, response: Response<AGPayment>) {
                if (RestService.successResult(response.code())) {
                    paySwitch = response.body()

                    if (paySwitch!!.alipay.equals("on")) {
                        paymentCount ++;
                    }
                    if (paySwitch!!.global_alipay.equals("on")) {
                        paymentCount ++;
                    }
                    if (paySwitch!!.acoin.equals("on")) {
                        paymentCount ++;
                    }
                    /*paymentCount = 3
                    paySwitch!!.alipay= "on"
                    paySwitch!!.global_alipay= "on"
                    paySwitch!!.acoin= "on"*/
                    updatePayment();
                } else {
                    try {
                        val json = JSONObject(response.errorBody()!!.string())
                        showErrorDialog(json.getString("message"))
                    } catch (e: Exception) {
                        showErrorDialog(getString(R.string.cant_connect_to_server))
                    }
                }
            }

            override fun onFailure(call: Call<AGPayment>, t: Throwable) {
                showErrorDialog(getString(R.string.cant_connect_to_server))
            }
        })
    }

    fun updatePayment() {
        pay1Btn!!.visibility = View.GONE
        pay2Btn!!.visibility = View.GONE
        pay3Btn!!.visibility = View.GONE
        if (paymentCount == 1) {
            if (paySwitch!!.alipay.equals("on")) {
                payMethod = ALIPAY
                pay2Btn!!.setImageResource(R.drawable.alipay)
                pay2Txt!!.text = ALIPAY
            } else if (paySwitch!!.global_alipay.equals("on")) {
                payMethod = GLOBALALIPAY
                pay2Btn!!.setImageResource(R.drawable.alipay)
                pay2Txt!!.text = GLOBALALIPAY
            } else if (paySwitch!!.acoin.equals("on")) {
                payMethod = ACOIN
                pay2Btn!!.setImageResource(R.drawable.acoin)
                pay2Txt!!.text = ACOIN
            }
            pay2Btn!!.visibility = View.VISIBLE
        } else if (paymentCount == 2) {
            if (paySwitch!!.alipay.equals("on") && paySwitch!!.global_alipay.equals("on")) {
                payMethod = ALIPAY
                pay1Btn!!.setImageResource(R.drawable.alipay)
                pay3Btn!!.setImageResource(R.drawable.alipay)
                pay1Txt!!.text = ALIPAY
                pay3Txt!!.text = GLOBALALIPAY
            } else {
                if (paySwitch!!.alipay.equals("on")) {
                    payMethod = ALIPAY
                    pay1Btn!!.setImageResource(R.drawable.alipay)
                    pay1Txt!!.text = ALIPAY
                } else if (paySwitch!!.global_alipay.equals("on")) {
                    payMethod = GLOBALALIPAY
                    pay1Btn!!.setImageResource(R.drawable.alipay)
                    pay1Txt!!.text = GLOBALALIPAY
                }
                if (paySwitch!!.acoin.equals("on")) {
                    pay3Btn!!.setImageResource(R.drawable.acoin_gray)
                    pay3Txt!!.text = ACOIN
                }
            }
            pay1Btn!!.visibility = View.VISIBLE
            pay3Btn!!.visibility = View.VISIBLE
        } else if (paymentCount == 3) {
            payMethod = ALIPAY
            pay1Btn!!.setImageResource(R.drawable.alipay)
            pay2Btn!!.setImageResource(R.drawable.alipay_gray)
            pay3Btn!!.setImageResource(R.drawable.acoin_gray)
            pay1Txt!!.text = ALIPAY
            pay2Txt!!.text = GLOBALALIPAY
            pay3Txt!!.text = ACOIN
            pay1Btn!!.visibility = View.VISIBLE
            pay2Btn!!.visibility = View.VISIBLE
            pay3Btn!!.visibility = View.VISIBLE
        }
    }

    fun payNow() {
        if (payMethod.equals("")) {
            showErrorDialog(getString(R.string.select_payment_method))
            return
        }

        //Preference.sharedInstance().saveBaseUrl("https://dev.qqmailer.com")
        //RestService.setupRestClient()
        val cartCall = RestService.sharedInstance().cart(pack!!.id, payMethod)
        cartCall.enqueue(object : Callback<AGCart> {
            override fun onResponse(call: Call<AGCart>, response: Response<AGCart>) {
                if (RestService.successResult(response.code())) {
                    cart = response.body()

                    if (payMethod == ALIPAY || payMethod == GLOBALALIPAY)
                        payWithAlipay()
                    else if (payMethod == ACOIN)
                        payWithAcoin()
                } else {
                    try {
                        val json = JSONObject(response.errorBody()!!.string())
                        showErrorDialog(json.getString("message"))
                    } catch (e: Exception) {
                        showErrorDialog(getString(R.string.cant_connect_to_server))
                    }
                }
            }

            override fun onFailure(call: Call<AGCart>, t: Throwable) {
                showErrorDialog(getString(R.string.cant_connect_to_server))
            }
        })
    }

    private fun payWithAlipay() {
        val payRunnable = Runnable {
            val alipay = PayTask(parentActivity)
            val result = alipay.payV2(cart!!.url, true)

            val msg = Message()
            msg.what = ALIPAY_PAY_FLAG
            msg.obj = result
            alipayHandler.sendMessage(msg)
        }

        val payThread = Thread(payRunnable)
        payThread.start()
    }

    private fun payWithAcoin() {
        val acoinCall = RestService.sharedInstance().validateACoin(cart!!.tradeNo!!, cart!!.fee)
        acoinCall.enqueue(object : Callback<AGValidateACoin> {
            override fun onResponse(call: Call<AGValidateACoin>, response: Response<AGValidateACoin>) {
                dismissProgressDialog()

                if (RestService.successResult(response.code())) {
                    showAlertDialog("", getString(R.string.paid_successfully), object : AGDialogHelper.DialogListener {
                        override fun onOK() {
                            var intent = Intent(BROADCAST_SIGNAL_PURCHASE_CHANGED)
                            intent.putExtra("message", BROADCAST_SIGNAL_PURCHASE_CHANGED)
                            LocalBroadcastManager.getInstance(safeContext!!).sendBroadcast(intent)

                            intent = Intent(BROADCAST_SIGNAL_ACOIN_CHANGED)
                            intent.putExtra("message", BROADCAST_SIGNAL_ACOIN_CHANGED)
                            LocalBroadcastManager.getInstance(safeContext!!).sendBroadcast(intent)

                            (parentActivity as MainActivity).popuptoShopCountryFragment()
                        }

                        override fun onCancel() {}
                    })
                } else {
                    try {
                        val json = JSONObject(response.errorBody()!!.string())
                        showErrorDialog(json.getString("message"))
                    } catch (e: Exception) {
                        showErrorDialog(getString(R.string.cant_connect_to_server))
                    }
                }
            }

            override fun onFailure(call: Call<AGValidateACoin>, t: Throwable) {
                showErrorDialog(getString(R.string.cant_connect_to_server))
            }
        })
    }

    private fun payWithGooglepay() {
        dismissProgressDialog()
    }

    companion object {
        private val ALIPAY_PAY_FLAG = 1
    }

}
