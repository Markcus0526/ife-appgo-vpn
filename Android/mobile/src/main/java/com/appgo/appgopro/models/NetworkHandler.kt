package com.appgo.appgopro.models

import com.appgo.appgopro.models.RestService.Companion.HEADER_ACCEPT
import com.google.gson.Gson
import okhttp3.Interceptor
import okhttp3.OkHttpClient
import okhttp3.Response
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory
import java.security.SecureRandom
import java.security.cert.X509Certificate
import javax.net.ssl.*

class NetworkHandler {

    fun getRetrofit(okHttpClient: OkHttpClient, gson: Gson): Retrofit {
        var url = Preference.sharedInstance().loadBaseUrl()

        return Retrofit.Builder()
                .baseUrl(url)
                .client(okHttpClient)
                .addConverterFactory(GsonConverterFactory.create(gson))
                .build()
    }

    fun getUnsafeOkHttpClient(userToken: String): OkHttpClient {
        try { // Create a trust manager that does not validate certificate chains
            val trustAllCerts = arrayOf<TrustManager>(object : X509TrustManager {
                override fun checkClientTrusted(chain: Array<X509Certificate>, authType: String) {}

                override fun checkServerTrusted(chain: Array<X509Certificate>, authType: String) {}

                override fun getAcceptedIssuers(): Array<X509Certificate>? {
                    return arrayOf()
                }
            })

            // Install the all-trusting trust manager
            val sslContext = SSLContext.getInstance("SSL")
            sslContext.init(null, trustAllCerts, SecureRandom())
            // Create an ssl socket factory with our all-trusting manager
            val sslSocketFactory = sslContext.socketFactory
            val builder = OkHttpClient.Builder()
            builder.sslSocketFactory(sslSocketFactory)
            builder.hostnameVerifier(object: HostnameVerifier {
                override fun verify(hostname: String?, session: SSLSession?): Boolean {
                    return true
                }
            })
            builder.addInterceptor(object: Interceptor {
                override fun intercept(chain: Interceptor.Chain?): Response {

                    val originalRequest = chain!!.request()
                    val newBuilder = originalRequest.newBuilder()
                            .addHeader("Accept", HEADER_ACCEPT)
                            .addHeader("Authorization", "Bearer " + userToken)
                            .addHeader("Content-Language", Preference.sharedInstance().loadDefaultLanguage())
                    val newRequest = newBuilder.build()
                    return chain.proceed(newRequest)
                }
            })
            val okHttpClient = builder.build()
            return okHttpClient
        } catch (e: Exception) {
            throw RuntimeException(e)
        }
    }
}
