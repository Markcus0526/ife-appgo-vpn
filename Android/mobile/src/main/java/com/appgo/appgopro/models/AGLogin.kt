package com.appgo.appgopro.models

import com.google.gson.annotations.SerializedName

/**
 * Created by KSMA on 4/19/2017.
 */

class AGLogin {

    @SerializedName("access_token")
    var accessToken: String? = null

    @SerializedName("token_type")
    var tokenType: String? = null

    @SerializedName("expires_in")
    var expiresIn: Int = 0

    @SerializedName("refresh_token")
    var refreshToken: String? = null

}
