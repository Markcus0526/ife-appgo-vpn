package com.appgo.appgopro.models

import com.appgo.appgopro.acl.Acl
import com.google.gson.Gson
import com.google.gson.annotations.SerializedName
import java.util.*

/**
 * Created by KSMA on 4/23/2017.
 */

class AGProfile {

    @SerializedName("ip")
    var ip: String = ""

    @SerializedName("method")
    var method: String = "aes-256-cfb"

    @SerializedName("port")
    var remotPort: Int = 0

    @SerializedName("passwd")
    var password: String = ""

    @SerializedName("transfer_enable")
    var transferEnable: Long = 0

    @SerializedName("upload")
    var upload: Long = 0

    @SerializedName("download")
    var download: Long = 0

    @SerializedName("expire_time")
    var expireTime: String = ""

    @SerializedName("country")
    var country: AGCountry = AGCountry()

    var delayTime = ""

    var qrCode = false

    var route = Acl.INTERNATIONAL

    var remoteDns = "8.8.8.8"

    var proxyApps = false

    var bypass = false

    var udpdns = false

    var ipv6 = false

    var individual = ""

    var tx: Long = 0

    var rx: Long = 0

    var date = Date()

    var plugins = ""

    var portTransproxy: Int = 8200

    var portProxy: Int = 1080

    var portLocalDns: Int = 5450

    fun getJsonString(): String {
        return Gson().toJson(this@AGProfile)
    }

    fun name(): String {
        val lang = Preference.sharedInstance().loadDefaultLanguage()
        if (lang.equals("CN"))
            return country!!.aliasZh!!
        else
            return country!!.aliasEn!!
    }

    companion object {
        fun initWithJsonString(jsonService: String): AGProfile {
            val gson = Gson()
            return gson.fromJson(jsonService, AGProfile::class.java)
        }
    }
}
