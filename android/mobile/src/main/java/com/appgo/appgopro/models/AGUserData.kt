package com.appgo.appgopro.models

import com.google.gson.annotations.SerializedName

/**
 * Created by KSMA on 4/19/2017.
 */

class AGUserData {

    @SerializedName("nickname")
    var nickname: String? = null

    @SerializedName("mobile")
    var mobile: String? = null

    @SerializedName("email")
    var email: String? = null

    @SerializedName("acoin")
    var acoin: Int = 0

    @SerializedName("level")
    var level: Int = 0

    @SerializedName("created_at")
    var createdAt: String? = null
}
