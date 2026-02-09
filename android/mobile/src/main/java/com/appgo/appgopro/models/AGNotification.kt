package com.appgo.appgopro.models

import com.google.gson.annotations.SerializedName
import java.util.*

/**
 * Created by KSMA on 4/22/2017.
 */

class AGNotification {

    @SerializedName("per_page")
    var perPage: Int = 0

    @SerializedName("current_page")
    var currentPage: Int = 0

    @SerializedName("next_page_url")
    var nextPageUrl: String? = null

    @SerializedName("prev_page_url")
    var prevPageUrl: String? = null

    @SerializedName("from")
    var fromService: Int = 0

    @SerializedName("to")
    var toService: Int = 0

    @SerializedName("data")
    var notificationDatas: List<NotificationData> = ArrayList()

    inner class NotificationData {

        @SerializedName("id")
        var id: Int = 0

        @SerializedName("title")
        var title: String? = null

        @SerializedName("content")
        var content: String? = null

        @SerializedName("updated_at")
        var updatedAt: String? = null
    }
}
