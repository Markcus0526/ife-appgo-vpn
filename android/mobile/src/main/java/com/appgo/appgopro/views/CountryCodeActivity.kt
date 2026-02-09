package com.appgo.appgopro.views

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.os.Bundle
import android.support.v7.widget.LinearLayoutManager
import android.support.v7.widget.RecyclerView
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ImageView
import android.widget.TextView
import com.appgo.appgopro.R
import com.appgo.appgopro.models.Preference
import com.appgo.appgopro.supers.SuperActivity
import com.appgo.appgopro.utils.AGUtils
import com.appgo.appgopro.utils.Countries
import java.util.*

class CountryCodeActivity : SuperActivity() {

    private var countryListView: RecyclerView? = null
    private var countryListAdapter: CountryListAdapter? = null

    private var countryList: List<Countries.CountryInfo> = ArrayList()
    private var selCode = ""

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_select_country)

        countryList = Countries.sharedInstance().countryInfos
        selCode = intent.getStringExtra("code")
        if (selCode.isEmpty())
            selCode = "CN"

        countryListView = findViewById(R.id.countryList)
        countryListView!!.layoutManager = LinearLayoutManager(this, LinearLayoutManager.VERTICAL, false)

        countryListAdapter = CountryListAdapter(this)
        countryListAdapter!!.setOnItemClickListener(OnCountryListItemClickListener())
        countryListAdapter!!.setData(countryList)

        countryListView!!.adapter = countryListAdapter
    }

    private inner class OnCountryListItemClickListener : View.OnClickListener {
        override fun onClick(view: View) {
            val pos = view.tag as Int
            val country = countryList[pos]

            val intent = Intent()
            intent.putExtra("code", country.code)
            setResult(Activity.RESULT_OK, intent)
            popOverCurActivityAnimated()
        }
    }

    private inner class CountryListAdapter(context: Context) : RecyclerView.Adapter<RecyclerView.ViewHolder>() {

        private val inflater: LayoutInflater
        private var items: List<Countries.CountryInfo>? = null
        private var itemClickListener: View.OnClickListener? = null
        private var showDisclosure = false

        init {
            inflater = LayoutInflater.from(context)
        }

        override fun getItemCount(): Int {
            return items!!.size
        }

        fun setData(items: List<Countries.CountryInfo>) {
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

            init {
                if (itemClickListener != null)
                    itemView.setOnClickListener(itemClickListener)

                flagImg = itemView.findViewById(R.id.flagImg)
                countryNameText = itemView.findViewById(R.id.countryNameText)
                countryPhoneCodeText = itemView.findViewById(R.id.countryPhoneCodeText)
                selectedImg = itemView.findViewById(R.id.selectedImg)
            }

            fun setCountry(country: Countries.CountryInfo) {
                val drawable = AGUtils.sharedInstance().getFlagDrawable(Countries.sharedInstance().getFlagByCode(country.code))
                flagImg.setImageDrawable(drawable)

                val lang = Preference.sharedInstance().loadDefaultLanguage()
                if (lang == "CN")
                    countryNameText.text = country.chineseName
                else
                    countryNameText.text = country.englishName

                countryPhoneCodeText.text = country.phoneCode

                if (selCode == country.code)
                    selectedImg.visibility = View.VISIBLE
                else
                    selectedImg.visibility = View.GONE
            }
        }
    }
}
