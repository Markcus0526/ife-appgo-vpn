package com.appgo.appgopro.models

import com.google.gson.annotations.SerializedName

/**
 * Created by jades on 9/1/2018.
 */
class AGPayment {
    @SerializedName("alipay")
    var alipay: String = "off"

    @SerializedName("global_alipay")
    var global_alipay: String = "off"

    @SerializedName("acoin")
    var acoin: String = "off"
}