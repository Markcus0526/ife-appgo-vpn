package com.appgo.appgopro.views.mine

import android.content.Context
import android.content.Intent
import android.os.Bundle
import android.support.v4.content.LocalBroadcastManager
import android.support.v7.widget.LinearLayoutManager
import android.support.v7.widget.RecyclerView
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.TextView
import com.appgo.appgopro.R
import com.appgo.appgopro.models.AGNotification
import com.appgo.appgopro.models.Preference
import com.appgo.appgopro.models.RestService
import com.appgo.appgopro.supers.SuperFragment
import com.appgo.appgopro.utils.AGConstants
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response

/**
 * Created by KSMA on 4/22/2017.
 */

class MeNotificationFragment : SuperFragment() {

    private var contentView: View? = null
    private var notificaitonListView: RecyclerView? = null

    private var notification: AGNotification? = AGNotification()
    private var notificationListAdapter: NotificationListAdapter? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
    }

    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View? {
        contentView = super.onCreateView(inflater, container, savedInstanceState)
        if (contentView == null)
            return null

        notificaitonListView = contentView!!.findViewById<View>(R.id.notificationList) as RecyclerView
        notificaitonListView!!.layoutManager = LinearLayoutManager(safeContext, LinearLayoutManager.VERTICAL, false)
        notificationListAdapter = NotificationListAdapter(parentActivity!!)
        notificationListAdapter!!.setData(notification!!.notificationDatas)
        notificaitonListView!!.adapter = notificationListAdapter

        initViewWithData()

        return contentView
    }


    override fun contentLayout(): Int {
        return R.layout.fragment_me_notification
    }

    private fun initViewWithData() {
        val notificationsCall = RestService.sharedInstance().notifications("1", "15")
        notificationsCall.enqueue(object : Callback<AGNotification> {
            override fun onResponse(call: Call<AGNotification>, response: Response<AGNotification>) {
                if (RestService.successResult(response.code())) {
                    notification = response.body()
                    if (notification!!.notificationDatas.size > 0) {
                        val newTime = notification!!.notificationDatas.get(0).updatedAt
                        if (!newTime.equals("")) Preference.sharedInstance().saveLastNotificationTime(newTime!!)
                    }

                    notificationListAdapter!!.setData(notification!!.notificationDatas)
                    notificationListAdapter!!.notifyDataSetChanged()

                    Preference.sharedInstance().saveBadgeVisible(false)
                    val intent = Intent(AGConstants.BROADCAST_SIGNAL_NOTIFICATION_RECEIVED)
                    intent.putExtra("message", AGConstants.BROADCAST_SIGNAL_NOTIFICATION_RECEIVED)
                    intent.putExtra("content", false)
                    LocalBroadcastManager.getInstance(safeContext!!).sendBroadcast(intent)
                } else {
                    //showErrorDialog("failed to connect to server.");
                }
            }

            override fun onFailure(call: Call<AGNotification>, t: Throwable) {}
        })
    }

    private inner class NotificationListAdapter(context: Context) : RecyclerView.Adapter<RecyclerView.ViewHolder>() {

        private val inflater: LayoutInflater
        private var items: List<AGNotification.NotificationData>? = null
        private var itemClickListener: View.OnClickListener? = null
        private var showDisclosure = false


        init {
            inflater = LayoutInflater.from(context)
        }

        override fun getItemCount(): Int {
            return items!!.size
        }

        fun setData(items: List<AGNotification.NotificationData>) {
            this.items = items
        }

        fun setShowDisclosure(flag: Boolean) {
            showDisclosure = flag
        }

        override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): RecyclerView.ViewHolder {
            val holder: RecyclerView.ViewHolder

            val contentView = inflater.inflate(R.layout.item_notification, parent, false)
            holder = NotificationItemHolder(contentView)

            return holder
        }


        override fun onBindViewHolder(holder: RecyclerView.ViewHolder, position: Int) {
            holder.itemView.tag = position

            (holder as NotificationItemHolder).setData(items!![position])
        }


        fun setOnItemClickListener(listener: View.OnClickListener) {
            this.itemClickListener = listener
        }

        inner class NotificationItemHolder(itemView: View) : RecyclerView.ViewHolder(itemView) {
            private val titleText: TextView
            private val contentText: TextView
            private val updatedAtText: TextView


            init {
                titleText = itemView.findViewById<View>(R.id.titleText) as TextView
                contentText = itemView.findViewById<View>(R.id.contentText) as TextView
                updatedAtText = itemView.findViewById<View>(R.id.updatedAtText) as TextView
            }

            fun setData(notification: AGNotification.NotificationData?) {
                if (notification != null) {
                    titleText.text = notification.title
                    contentText.text = notification.content
                    updatedAtText.text = notification.updatedAt
                }
            }
        }
    }
}

