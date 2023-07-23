package com.appgo.appgopro.views.shop

import android.content.Context
import android.os.Bundle
import android.support.v7.widget.LinearLayoutManager
import android.support.v7.widget.RecyclerView
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Button
import android.widget.TextView
import com.appgo.appgopro.R
import com.appgo.appgopro.models.AGCountry
import com.appgo.appgopro.models.AGPack
import com.appgo.appgopro.models.Preference
import com.appgo.appgopro.models.RestService
import com.appgo.appgopro.supers.SuperFragment
import com.appgo.appgopro.utils.AGUtils
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response
import java.util.*

class ShopPackageFragment : SuperFragment() {

    private var contentView: View? = null
    private var packageListView: RecyclerView? = null
    private var packageListAdapter: PackageListAdapter? = null

    var country: AGCountry? = null
    private var packageList: List<AGPack>? = ArrayList()

    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View? {
        contentView = super.onCreateView(inflater, container, savedInstanceState)
        if (contentView == null)
            return null

        val titleText = contentView!!.findViewById<View>(R.id.serverTitleText) as TextView
        if (country != null) {
            if (Preference.sharedInstance().loadDefaultLanguage().equals("CN")) {
                titleText.text = String.format("%s%s", country!!.aliasZh, resources.getString(R.string.shop_server_title))
            } else {
                titleText.text = String.format("%s %s", resources.getString(R.string.shop_server_title), country!!.aliasEn)
            }
        }

        val serverDescText = contentView!!.findViewById<View>(R.id.serverDescText) as TextView
        if (country != null && country!!.description != null) {
            val descs = country!!.description!!.split(" | ")
            if (Preference.sharedInstance().loadDefaultLanguage().equals("CN"))
                serverDescText.setText(descs[0])
            else if (descs.size > 1)
                serverDescText.setText(descs[1])
        }

        packageListView = contentView!!.findViewById<View>(R.id.shopPackageList) as RecyclerView
        packageListView!!.layoutManager = LinearLayoutManager(safeContext, LinearLayoutManager.VERTICAL, false)
        packageListAdapter = PackageListAdapter(parentActivity!!)
        packageListAdapter!!.setData(packageList)
        packageListView!!.adapter = packageListAdapter

        initViewWithData()

        return contentView
    }


    override fun contentLayout(): Int {
        return R.layout.fragment_shop_package
    }

    private fun initViewWithData() {
        if (country == null) return

        showProgressDialog()

        val packagesCall = RestService.sharedInstance().countryPackages(country!!.id)
        packagesCall.enqueue(object : Callback<List<AGPack>> {
            override fun onResponse(call: Call<List<AGPack>>, response: Response<List<AGPack>>) {
                dismissProgressDialog()

                if (RestService.successResult(response.code())) {
                    packageList = response.body()
                    packageListAdapter!!.setData(packageList)
                    packageListAdapter!!.notifyDataSetChanged()

                } else {
                    //showErrorDialog("failed to connect to server.");
                }
            }

            override fun onFailure(call: Call<List<AGPack>>, t: Throwable) {
                dismissProgressDialog()
            }
        })
    }

    private inner class PackageListAdapter(context: Context) : RecyclerView.Adapter<RecyclerView.ViewHolder>() {

        private val inflater: LayoutInflater
        private var items: List<AGPack>? = null
        private var showDisclosure = false

        init {
            inflater = LayoutInflater.from(context)
        }

        override fun getItemCount(): Int {
            return items!!.size
        }

        fun setData(items: List<AGPack>?) {
            this.items = items
        }

        fun setShowDisclosure(flag: Boolean) {
            showDisclosure = flag
        }

        override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): RecyclerView.ViewHolder {
            val holder: RecyclerView.ViewHolder

            val contentView = inflater.inflate(R.layout.item_package, parent, false)
            holder = PackageItemHolder(contentView)

            return holder
        }

        override fun onBindViewHolder(holder: RecyclerView.ViewHolder, position: Int) {
            holder.itemView.tag = position

            (holder as PackageItemHolder).setPackage(items!![position])
        }

        inner class PackageItemHolder(itemView: View) : RecyclerView.ViewHolder(itemView) {
            private val durationText: TextView
            private val transferText: TextView
            private val priceText: TextView
            private val purchaseBtn: Button

            init {

                durationText = itemView.findViewById<View>(R.id.durationText) as TextView
                transferText = itemView.findViewById<View>(R.id.transferText) as TextView
                priceText = itemView.findViewById<View>(R.id.priceText) as TextView
                purchaseBtn = itemView.findViewById<View>(R.id.purchaseBtn) as Button
                purchaseBtn.setOnClickListener {
                    val fragment = ShopPurchaseFragment()
                    val pos = adapterPosition
                    fragment.pack = packageList!![pos]
                    fragment.country = country
                    parentActivity!!.showNewFragment(fragment)
                }
            }

            fun setPackage(pack: AGPack) {

                val lang = Preference.sharedInstance().loadDefaultLanguage()
                if (lang == "CN") {
                    durationText.text = String.format("%d%s", pack.duration, resources.getString(R.string.day))
                } else {
                    durationText.text = String.format("%d %s", pack.duration, resources.getString(R.string.day))
                }
                transferText.text = AGUtils.sharedInstance().humanReadableByteCount(pack.transfer, false)
                priceText.text = String.format("%d", pack.price)
            }
        }
    }
}
