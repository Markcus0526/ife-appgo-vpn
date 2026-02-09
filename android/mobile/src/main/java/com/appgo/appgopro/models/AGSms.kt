package com.appgo.appgopro.models

import com.google.gson.annotations.SerializedName

/**
 * Created by KSMA on 4/23/2017.
 */

class AGSms {

    @SerializedName("for")
    var type: String? = null

    @SerializedName("mobile")
    var mobile: String? = null

}
