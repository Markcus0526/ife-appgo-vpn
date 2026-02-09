package com.appgo.appgopro.models

import com.google.gson.annotations.SerializedName

/**
 * Created by KSMA on 4/21/2017.
 */

class AGCart {

    @SerializedName("payment_method")
    var paymentMethod: String? = null

    @SerializedName("trade_no")
    var tradeNo: String? = null

    @SerializedName("fee")
    var fee: Float = 0.toFloat()

    @SerializedName("url")
    var url: String? = null

    @SerializedName("package")
    var cartPackage: CartPackage? = null

    inner class CartPackage {

        @SerializedName("id")
        var id: Int = 0

        @SerializedName("duration")
        var duration: Int = 0

        @SerializedName("transfer")
        var transfer: Long = 0

        @SerializedName("price")
        var price: Int = 0
    }
}
