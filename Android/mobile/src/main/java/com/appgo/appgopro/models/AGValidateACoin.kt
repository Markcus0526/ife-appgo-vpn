package com.appgo.appgopro.models

import com.google.gson.annotations.SerializedName

/**
 * Created by KSMA on 4/22/2017.
 */

class AGValidateACoin {

    @SerializedName("trade_no")
    var tradeNo: String? = null

    @SerializedName("payment_method")
    var paymentMethod: String? = null

}
