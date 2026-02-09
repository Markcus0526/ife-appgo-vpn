package com.appgo.appgopro.models

import com.google.gson.annotations.SerializedName

/**
 * Created by KSMA on 4/21/2017.
 */

class AGPack {

    @SerializedName("id")
    var id: Int = 0

    @SerializedName("duration")
    var duration: Int = 0

    @SerializedName("transfer")
    var transfer: Long = 0

    @SerializedName("price")
    var price: Int = 0

    @SerializedName("apple_product_id")
    var appleProductId: String? = null

}
