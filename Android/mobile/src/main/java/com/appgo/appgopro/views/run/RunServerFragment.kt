package com.appgo.appgopro.views.run

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.os.Bundle
import android.support.v4.content.LocalBroadcastManager
import android.support.v7.widget.LinearLayoutManager
import android.support.v7.widget.RecyclerView
import android.util.Base64
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ImageButton
import android.widget.ImageView
import android.widget.TextView
import com.appgo.appgopro.R
import com.appgo.appgopro.acl.Acl
import com.appgo.appgopro.controls.AGDialogHelper
import com.appgo.appgopro.controls.OnInputDialogResult
import com.appgo.appgopro.models.AGProfile
import com.appgo.appgopro.models.Preference
import com.appgo.appgopro.models.RestService
import com.appgo.appgopro.supers.SuperFragment
import com.appgo.appgopro.utils.AGConstants
import com.appgo.appgopro.utils.AGLogger
import com.appgo.appgopro.utils.AGUtils
import com.appgo.appgopro.utils.Countries
import com.appgo.appgopro.views.QRScannerActivity
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response
import java.io.*
import java.nio.charset.StandardCharsets
import java.util.*

class RunServerFragment : SuperFragment() {
    private val TAG = "RunServerFragment"
    private var contentView: View? = null
    private var profileListView: RecyclerView? = null
    private var profileListAdapter: ServiceListAdapter? = null
    private var intentFilter: IntentFilter? = null
    private var profileList: ArrayList<AGProfile> = ArrayList<AGProfile>()
    private var qrProfileList: ArrayList<AGProfile> = ArrayList<AGProfile>()

    private val broadcastReceiver = object : BroadcastReceiver() {
        override fun onReceive(context: Context, intent: Intent) {
            if (parentActivity == null) return
            val action = intent.action
            when (action) {
                AGConstants.BROADCAST_SIGNAL_PURCHASE_CHANGED -> {
                    initViewWithData()
                }

                AGConstants.BROADCAST_SIGNAL_QRCODE_SCANNED -> {
                    parseQRCode(intent.getStringExtra("content"))
                }
            }
        }
    }

    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View? {
        contentView = super.onCreateView(inflater, container, savedInstanceState)
        if (contentView == null)
            return null

        if (intentFilter == null) {
            intentFilter = IntentFilter()
            intentFilter!!.addAction(AGConstants.BROADCAST_SIGNAL_PURCHASE_CHANGED)
            intentFilter!!.addAction(AGConstants.BROADCAST_SIGNAL_QRCODE_SCANNED)
            LocalBroadcastManager.getInstance(safeContext!!).registerReceiver(broadcastReceiver, intentFilter!!)
        }

        profileListView = contentView!!.findViewById<RecyclerView>(R.id.serviceList)
        profileListView!!.layoutManager = LinearLayoutManager(safeContext, LinearLayoutManager.VERTICAL, false)

        profileListAdapter = ServiceListAdapter(parentActivity!!)
        profileListAdapter!!.setOnItemClickListener(OnServiceListItemClickListener())
        profileListAdapter!!.setOnItemLongClickListener(OnServiceListItemLongClickListener())
        profileListAdapter!!.setData(profileList)

        profileListView!!.adapter = profileListAdapter

        val scanBtn = contentView!!.findViewById<ImageButton>(R.id.scanBtn)
        scanBtn.setOnClickListener { scanQRServer() }

        initViewWithData()

        return contentView
    }


    override fun contentLayout(): Int {
        return R.layout.fragment_run_server
    }

    private fun scanQRServer() {
        QRScannerActivity.showQRScannerActivity(parentActivity!!, AGConstants.REQCODE_QRCODE_REQUEST)
    }

    private fun parseQRCode(content: String?) {
        if (content == null) {
            showErrorDialog(getString(R.string.failed_to_parse_qrcode))
            return
        }

        val pattern: String

        if (content.contains("ss://")) {
            pattern = content.substring(5)
        } else if (content.contains("ssr://")) {
            pattern = content.substring(6)
        } else {
            showErrorDialog(getString(R.string.failed_to_parse_qrcode))
            return
        }

        var server: String
        var servername = ""

        val strs = pattern.split('#')
        if (strs.size > 1) {
            server = strs[0]
            servername = strs[1]
        } else {
            server = pattern
        }

        val data = Base64.decode(server, Base64.DEFAULT)
        server = String(data, StandardCharsets.UTF_8)

        val items = server.split(":")
        if (items.size == 3) {
            val service = AGProfile()
            service.method = items[0]
            service.remotPort = items[2].toInt()
            val items2 = items[1].split("@")
            if (items2.size == 2) {
                service.password = items2[0]
                service.ip = items2[1]
                service.transferEnable = 1
                service.download = 0
                service.upload = 0
                service.expireTime = "2059-12-31 12:00:00"
                service.delayTime = ""
                service.qrCode = true
                service.country.id = 10001 + profileList.size
                if (servername.equals("")) {
                    service.country.name = service.ip
                    service.country.aliasEn = service.ip
                    service.country.aliasZh = service.ip
                } else {
                    service.country.name = servername
                    service.country.aliasEn = servername
                    service.country.aliasZh = servername
                }
                var exist = false

                for (s in profileList) {
                    if (s.ip.equals(service.ip) && (s.remotPort == service.remotPort)) {
                        exist = true
                        break
                    }
                }
                if (!exist) {
                    showInputDialog("", getString(R.string.server_qrcode_name), service.country.name!!,
                            object: OnInputDialogResult {
                                override fun finish(result: String) {
                                    if (!result.equals("")) {
                                        service.country.name = result
                                        service.country.aliasEn = result
                                        service.country.aliasZh = result
                                        qrProfileList.add(service)
                                        Preference.sharedInstance().saveAvailableProfiles(qrProfileList)

                                        profileList.add(service)
                                        profileListAdapter!!.notifyDataSetChanged()
                                        updateServerDelayTime()
                                    }
                                }
                            }
                    )
                }
            }
        }
    }

    private fun initViewWithData() {
        val availableServices = Preference.sharedInstance().loadAvailableProfiles()
        if (availableServices == null)
            qrProfileList = ArrayList<AGProfile>()
        else
            qrProfileList = ArrayList<AGProfile>(availableServices)

        showProgressDialog()
        val servicesCall = RestService.sharedInstance().userServices()
        servicesCall.enqueue(object: Callback<List<AGProfile>> {
            override fun onResponse(call: Call<List<AGProfile>>, response: Response<List<AGProfile>>) {
                dismissProgressDialog()
                if (RestService.successResult(response.code())) {
                    profileList = ArrayList(response.body())
                    for (p in qrProfileList) {
                        profileList.add(p)
                    }
                    for (p in profileList) {
                        if (p.country.name.equals("CN")) {
                            p.route = Acl.CHINA
                        } else {
                            p.route = Acl.INTERNATIONAL
                        }
                    }
                    profileListAdapter!!.setData(profileList)
                    profileListAdapter!!.notifyDataSetChanged()
                    updateServerDelayTime()
                } else {
                    AGLogger.log(TAG, getString(R.string.cant_connect_to_server));
                }
            }

            override fun onFailure(call: Call<List<AGProfile>>, t: Throwable) {
                dismissProgressDialog()
            }
        })
    }

    private fun updateServerDelayTime() {
        for (s in profileList) {
            object: Thread() {
                override fun run() {
                    ping(s.ip!!)
                }
            }.start()
        }
    }

    private inner class OnServiceListItemClickListener : View.OnClickListener {
        override fun onClick(view: View) {
            val pos = view.tag as Int
            Preference.sharedInstance().saveCurrentProfile(profileList[pos])

            val intent = Intent(AGConstants.BROADCAST_SIGNAL_SERVER_CHANGED)
            intent.putExtra("message", AGConstants.BROADCAST_SIGNAL_SERVER_CHANGED)
            LocalBroadcastManager.getInstance(safeContext!!).sendBroadcast(intent)

            onClickedBackButton()
        }
    }

    private inner class OnServiceListItemLongClickListener : View.OnLongClickListener {
        override fun onLongClick(view: View): Boolean {
            val pos = view.tag as Int
            if (profileList.get(pos).qrCode) {
                showQuestionDialog("",
                        getString(R.string.do_you_remove_this_server),
                        getString(R.string.yes), getString(R.string.no),
                        object: AGDialogHelper.DialogListener {
                            override fun onOK () {
                                for (s in qrProfileList) {
                                    if (s.ip.equals(profileList.get(pos).ip)) {
                                        qrProfileList.remove(s)
                                        Preference.sharedInstance().saveAvailableProfiles(qrProfileList)
                                        break
                                    }
                                }
                                profileList.remove(profileList.get(pos))
                                profileListAdapter!!.notifyDataSetChanged()
                            }
                            override fun onCancel () {}
                        }
                )
            }
            return true
        }
    }

    private inner class ServiceListAdapter(context: Context) : RecyclerView.Adapter<RecyclerView.ViewHolder>() {

        private val inflater: LayoutInflater
        private var items: List<AGProfile>? = null
        private var itemClickListener: View.OnClickListener? = null
        private var itemLongClickListener: View.OnLongClickListener? = null
        private var showDisclosure = false


        init {
            inflater = LayoutInflater.from(context)
        }

        override fun getItemCount(): Int {
            return items!!.size
        }

        fun setData(items: List<AGProfile>?) {
            this.items = items
        }

        fun setShowDisclosure(flag: Boolean) {
            showDisclosure = flag
        }

        override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): RecyclerView.ViewHolder {
            val holder: RecyclerView.ViewHolder

            val contentView = inflater.inflate(R.layout.item_country, parent, false)
            holder = ServiceItemHolder(contentView)

            return holder
        }


        override fun onBindViewHolder(holder: RecyclerView.ViewHolder, position: Int) {
            holder.itemView.tag = position

            (holder as ServiceItemHolder).setService(items!![position])
        }


        fun setOnItemClickListener(listener: View.OnClickListener) {
            this.itemClickListener = listener
        }

        fun setOnItemLongClickListener(listener: View.OnLongClickListener) {
            this.itemLongClickListener = listener
        }

        inner class ServiceItemHolder(itemView: View) : RecyclerView.ViewHolder(itemView) {
            private val flagImg: ImageView
            private val countryNameText: TextView
            private val delayText: TextView
            private val selectedImg: ImageView
            private val seperatorText: TextView

            init {
                if (itemClickListener != null)
                    itemView.setOnClickListener(itemClickListener)

                if (itemLongClickListener != null)
                    itemView.setOnLongClickListener(itemLongClickListener)

                flagImg = itemView.findViewById<View>(R.id.flagImg) as ImageView
                countryNameText = itemView.findViewById<View>(R.id.countryNameText) as TextView
                delayText = itemView.findViewById<View>(R.id.countryPhoneCodeText) as TextView
                selectedImg = itemView.findViewById<View>(R.id.selectedImg) as ImageView
                selectedImg.visibility = View.GONE
                seperatorText = itemView.findViewById<View>(R.id.seperatorText) as TextView
                seperatorText.setBackgroundColor(resources.getColor(R.color.colorSeperator))
            }

            fun setService(service: AGProfile) {
                val drawable = AGUtils.sharedInstance().getFlagDrawable(Countries.sharedInstance().getFlagByCode(service.country.name!!))
                if (drawable != null)
                    flagImg.setImageDrawable(drawable)

                val lang = Preference.sharedInstance().loadDefaultLanguage()
                if (lang == "CN")
                    countryNameText.text = service.country.aliasZh
                else
                    countryNameText.text = service.country.aliasEn

                delayText.text = service.delayTime
            }
        }
    }

    fun ping(serverIP: String) {
        val pOut: PipedOutputStream?
        val pIn: PipedInputStream?
        val linReader: LineNumberReader?
        var process: Process?
        val startTime: Long
        var overtime = false

        pOut = PipedOutputStream()
        try {
            pIn = PipedInputStream(pOut)
            linReader = LineNumberReader(InputStreamReader(pIn))
        } catch (e: IOException) {
            AGLogger.log(TAG, "Ping(onPreExecute) - " + e.toString())
            return
        }

        try {
            startTime = System.currentTimeMillis()
            process = ProcessBuilder().command("/system/bin/ping", "-c " + 1, serverIP).redirectErrorStream(true).start()
            try {
                val inputStream = process.getInputStream()
                val outputStream = process.getOutputStream()
                val buffer = ByteArray(1024)
                // if overtime by 2s, just stop ping
                if (System.currentTimeMillis() - startTime > 2000) {
                    overtime = true
                    publishProgress(serverIP, overtime, linReader)
                    return
                }
                // inputStream -> buffer -> pOut -> linReader -> 1 line of ping information to parse
                var count: Int = inputStream.read(buffer)
                while (count != -1) {
                    pOut.write(buffer, 0, count)
                    if (publishProgress(serverIP, overtime, linReader))
                        break
                    count = inputStream.read(buffer)
                }
                outputStream.close()
                inputStream.close()
                pOut.close()
                pIn.close()
            } finally {
                if (process != null) process.destroy()
            }
        } catch (e: IOException) {
            AGLogger.log(TAG, "Ping(doInBackground) - " + e.toString())
        }
    }

    fun publishProgress(serverIP: String, overtime: Boolean, reader: LineNumberReader): Boolean {
        try {
            if (overtime) {
                for (profile in profileList) {
                    if (profile.ip.equals(serverIP)) {
                        activity!!.runOnUiThread {
                            profile.delayTime = getString(R.string.server_overtime)
                            profileListAdapter!!.notifyDataSetChanged()
                        }
                        break
                    }
                }
                return true
            } else { // Is a line ready to read from the "ping" command?
                while (reader.ready()) {
                    val line = reader.readLine()
                    val params = line.split(" ")
                    if (!params.isEmpty()) {
                        for (s in params) {
                            if (s.contains("time=")) {
                                for (profile in profileList) {
                                    if (profile.ip.equals(serverIP)) {
                                        if (activity != null) {
                                            activity!!.runOnUiThread {
                                                profile.delayTime = "%dms".format(java.lang.Float.parseFloat(s.substring(5)).toInt())
                                                profileListAdapter!!.notifyDataSetChanged()
                                            }
                                        }
                                        return true
                                    }
                                }
                            }
                        }
                    }
                }
            }
        } catch (e: IOException) {
            AGLogger.log(TAG, "Ping(onProgressUpdate) - " + e.toString())
        }

        return false
    }
}
