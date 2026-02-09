package com.appgo.appgopro.models

import com.google.gson.annotations.SerializedName

/**
 * Created by KSMA on 4/23/2017.
 */

class AGRule {

    @SerializedName("name")
    var name: String? = null

    @SerializedName("content")
    var content: String? = null

    @SerializedName("updated_at")
    var updated_at: String? = null
}