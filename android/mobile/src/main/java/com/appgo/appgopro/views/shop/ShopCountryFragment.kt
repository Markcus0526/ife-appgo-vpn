package com.appgo.appgopro.views.shop

import android.content.Context
import android.os.Bundle
import android.support.v7.widget.LinearLayoutManager
import android.support.v7.widget.RecyclerView
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ImageView
import android.widget.TextView
import com.appgo.appgopro.R
import com.appgo.appgopro.models.AGCountry
import com.appgo.appgopro.models.Preference
import com.appgo.appgopro.models.RestService
import com.appgo.appgopro.supers.SuperFragment
import com.appgo.appgopro.utils.AGUtils
import com.appgo.appgopro.utils.Countries
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response
import java.util.*

class ShopCountryFragment : SuperFragment() {

    private var contentView: View? = null
    private var countryListView: RecyclerView? = null
    private var countryListAdapter: CountryListAdapter? = null

    private var countryList: List<AGCountry>? = ArrayList()


    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View? {
        contentView = super.onCreateView(inflater, container, savedInstanceState)
        if (contentView == null)
            return null

        countryListView = contentView!!.findViewById<View>(R.id.shopCountryList) as RecyclerView
        countryListView!!.layoutManager = LinearLayoutManager(safeContext, LinearLayoutManager.VERTICAL, false)

        countryListAdapter = CountryListAdapter(parentActivity!!)
        countryListAdapter!!.setOnItemClickListener(OnCountryListItemClickListener())
        countryListAdapter!!.setData(countryList)

        countryListView!!.adapter = countryListAdapter

        initViewWithData()

        return contentView
    }


    override fun contentLayout(): Int {
        return R.layout.fragment_shop_country
    }

    private fun initViewWithData() {
        val countriesCall = RestService.sharedInstance().countries()
        countriesCall.enqueue(object : Callback<List<AGCountry>> {
            override fun onResponse(call: Call<List<AGCountry>>, response: Response<List<AGCountry>>) {
                if (RestService.successResult(response.code())) {
                    countryList = response.body()
                    countryListAdapter!!.setData(countryList)
                    countryListAdapter!!.notifyDataSetChanged()

                } else {
                    //showErrorDialog("failed to connect to server.");
                }
            }

            override fun onFailure(call: Call<List<AGCountry>>, t: Throwable) {}
        })
    }

    private inner class OnCountryListItemClickListener : View.OnClickListener {
        override fun onClick(view: View) {
            val fragment = ShopPackageFragment()
            val pos = view.tag as Int
            if (pos > -1) {
                fragment.country = countryList!!.get(pos)
                parentActivity!!.showNewFragment(fragment)
            }
        }
    }

    private inner class CountryListAdapter(context: Context) : RecyclerView.Adapter<RecyclerView.ViewHolder>() {

        private val inflater: LayoutInflater
        private var items: List<AGCountry>? = null
        private var itemClickListener: View.OnClickListener? = null
        private var showDisclosure = false


        init {
            inflater = LayoutInflater.from(context)
        }

        override fun getItemCount(): Int {
            return items!!.size
        }

        fun setData(items: List<AGCountry>?) {
            this.items = items
        }

        fun setShowDisclosure(flag: Boolean) {
            showDisclosure = flag
        }

        override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): RecyclerView.ViewHolder {
            val holder: RecyclerView.ViewHolder

            val contentView = inflater.inflate(R.layout.item_country, parent, false)
            holder = CountryItemHolder(contentView)

            return holder
        }


        override fun onBindViewHolder(holder: RecyclerView.ViewHolder, position: Int) {
            holder.itemView.tag = position

            (holder as CountryItemHolder).setCountry(items!![position])
        }


        fun setOnItemClickListener(listener: View.OnClickListener) {
            this.itemClickListener = listener
        }


        inner class CountryItemHolder(itemView: View) : RecyclerView.ViewHolder(itemView) {
            private val flagImg: ImageView
            private val countryNameText: TextView
            private val countryPhoneCodeText: TextView
            private val selectedImg: ImageView
            private val seperatorText: TextView

            init {

                if (itemClickListener != null)
                    itemView.setOnClickListener(itemClickListener)

                flagImg = itemView.findViewById<View>(R.id.flagImg) as ImageView
                countryNameText = itemView.findViewById<View>(R.id.countryNameText) as TextView
                countryPhoneCodeText = itemView.findViewById<View>(R.id.countryPhoneCodeText) as TextView
                selectedImg = itemView.findViewById<View>(R.id.selectedImg) as ImageView
                countryPhoneCodeText.visibility = View.GONE
                selectedImg.visibility = View.GONE
                seperatorText = itemView.findViewById<View>(R.id.seperatorText) as TextView
                seperatorText.setBackgroundColor(resources.getColor(R.color.colorSeperator))
            }

            fun setCountry(country: AGCountry) {
                val drawable = AGUtils.sharedInstance().getFlagDrawable(Countries.sharedInstance().getFlagByCode(country.name!!))
                if (drawable != null)
                    flagImg.setImageDrawable(drawable)

                val lang = Preference.sharedInstance().loadDefaultLanguage()
                if (lang == "CN")
                    countryNameText.text = country.aliasZh
                else
                    countryNameText.text = country.aliasEn
            }
        }
    }
}
