package com.appgo.appgopro.models

import com.google.gson.annotations.SerializedName

/**
 * Created by KSMA on 4/23/2017.
 */

class AGRegister {

    @SerializedName("nickname")
    var nickname: String? = null

    @SerializedName("mobile")
    var mobile: String? = null

    @SerializedName("email")
    var email: String? = null
}
