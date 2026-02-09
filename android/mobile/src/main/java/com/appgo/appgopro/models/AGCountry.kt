package com.appgo.appgopro.models

import com.google.gson.annotations.SerializedName

/**
 * Created by KSMA on 4/19/2017.
 */

class AGCountry {

    @SerializedName("id")
    var id: Int = 0

    @SerializedName("name")
    var name: String? = null

    @SerializedName("alias_zh")
    var aliasZh: String? = null

    @SerializedName("alias_en")
    var aliasEn: String? = null

    @SerializedName("description")
    var description: String? = null
}
