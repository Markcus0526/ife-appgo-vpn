package com.appgo.appgopro.models

import com.appgo.appgopro.BuildConfig
import com.google.gson.GsonBuilder
import okhttp3.CipherSuite
import okhttp3.ConnectionSpec
import okhttp3.TlsVersion
import retrofit2.Call
import java.util.*


/**
 * Created by KSMA on 4/19/2017.
 */

class RestService {
    public val TAG = "RestService"

    //=============== service ===================//
    fun login(username: String, password: String): Call<AGLogin> {
        return RestService.get()!!.login(username, password, CLIENT_ID, CLIENT_SECRET, GRANT_TYPE)
    }

    fun user(): Call<AGUserData> {
        return RestService.get()!!.user()
    }

    fun countries(): Call<List<AGCountry>> {
        return RestService.get()!!.countries()
    }

    fun countryPackages(countryId: Int): Call<List<AGPack>> {
        return RestService.get()!!.countryPackage(countryId)
    }

    fun cart(packageId: Int, paymentMethod: String): Call<AGCart> {
        return RestService.get()!!.cart(packageId, paymentMethod)
    }

    fun paySwitch(): Call<AGPayment> {
        return RestService.get()!!.paySwitch()
    }

    fun validateACoin(tradeNo: String, fee: Float): Call<AGValidateACoin> {
        return RestService.get()!!.validateACoin(tradeNo, fee)
    }

    fun aboutus(): Call<AGAboutus> {
        return RestService.get()!!.aboutus()
    }

    fun notifications(page: String, perPage: String): Call<AGNotification> {
        return RestService.get()!!.notifications(page, perPage)
    }

    fun tos(): Call<AGTos> {
        return RestService.get()!!.tos()
    }

    fun register(mobile: String, nickname: String, password: String, email: String, verifyCode: String): Call<AGRegister> {
        return RestService.get()!!.register(mobile, nickname, password, email, verifyCode)
    }

    fun sms(type: String, mobile: String): Call<AGSms> {
        return RestService.get()!!.sms(type, mobile)
    }

    fun password(mobile: String, password: String, verifyCode: String): Call<AGPassword> {
        return RestService.get()!!.password(mobile, password, verifyCode)
    }

    fun userServices(): Call<List<AGProfile>> {
        return RestService.get()!!.userServices()
    }

    fun allRuleNames(): Call<List<AGRule>> = RestService.get()!!.getAllRuleNames()

    fun rule(name: String): Call<AGRule> = RestService.get()!!.getRule(name)

    fun ruleUpdatedAt(name: String): Call<AGRuleUpdatedAt> = RestService.get()!!.getRuleUpdatedAt(name)

    fun getVersion(): Call<AGVersion> {
        return RestService.get()!!.version()
    }

    companion object {
        var BASE_URL = "http://39.108.212.90:99"//"https://api.gaga51.com"//https://api.yeseji.com
        var CLIENT_ID = "q32LOhbxR4p8TVKTbLCiHKO4FbZUTQ5m3wI1YtCc"
        var CLIENT_SECRET = "qQB4T6wuMpEqMx8JiJIqrNynQTSrEnsRaJxo71C4"

        val HEADER_ACCEPT = "application/vnd.appgogo.v1+json"
        val GRANT_TYPE = "password"

        init {
            //setupRestClient()
        }

        protected var instance: RestService? = null
        private var rtService: com.appgo.appgopro.models.RestEndpoint? = null
        public var userToken: String? = null
            get() {
                var loadedUserToken: String? = field
                if (loadedUserToken == null || loadedUserToken.length == 0)
                    loadedUserToken = Preference.sharedInstance().loadUserToken()
                return loadedUserToken
            }
            set(value) {
                field = value
                Preference.sharedInstance().saveUserToken(value!!)
                version = BuildConfig.VERSION_NAME
            }
        private var version: String? = null
        val userID: String? = null

        val StatusOk = 200
        val Created = 201
        val Accepted = 202
        val NoContent = 204
        val BadRequest = 400
        val Unauthorize = 401
        val NotFound = 404
        val InternalError = 500

        fun sharedInstance(): RestService {
            if (instance == null)
                instance = RestService()

            return instance as RestService
        }

        fun get(): com.appgo.appgopro.models.RestEndpoint? {
            return rtService
        }

        val isUserLoggedIn: Boolean
            get() = Preference.sharedInstance().loadUserToken().length > 0

        fun setupRestClient() {
            val gson = GsonBuilder()
                    .setDateFormat("yyyy'-'MM'-'dd")
                    .create()

            val spec = ConnectionSpec.Builder(ConnectionSpec.MODERN_TLS)
                    .tlsVersions(TlsVersion.TLS_1_2)
                    .cipherSuites(
                            CipherSuite.TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256,
                            CipherSuite.TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256,
                            CipherSuite.TLS_DHE_RSA_WITH_AES_128_GCM_SHA256)
                    .build()

            val okHttpClient = NetworkHandler().getUnsafeOkHttpClient(userToken!!)
            okHttpClient.newBuilder().connectionSpecs(Collections.singletonList(spec)).build()
            val retrofit = NetworkHandler().getRetrofit(okHttpClient, gson)
            rtService = retrofit.create(com.appgo.appgopro.models.RestEndpoint::class.java)
        }

        fun successResult(code: Int): Boolean {
            return if (code >= StatusOk && code <= NoContent) {
                true
            } else {
                false
            }
        }
    }
}
