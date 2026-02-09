package com.appgo.appgopro.views.mine

import android.content.Intent
import android.os.Bundle
import android.os.Handler
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Button
import android.widget.ImageView

import com.appgo.appgopro.R
import com.appgo.appgopro.models.Preference
import com.appgo.appgopro.supers.SuperFragment
import com.appgo.appgopro.views.SplashActivity

class MeLanguageFragment : SuperFragment() {

    private var contentView: View? = null
    private var englishImg: ImageView? = null
    private var chineseImg: ImageView? = null

    private var selLanguage: String? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
    }

    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View? {
        contentView = super.onCreateView(inflater, container, savedInstanceState)
        if (contentView == null)
            return null

        englishImg = contentView!!.findViewById(R.id.englishSelImg)
        chineseImg = contentView!!.findViewById(R.id.chineseSelImg)

        selLanguage = Preference.sharedInstance().loadDefaultLanguage()
        changeSelectedItem(selLanguage)

        val saveBtn: Button = contentView!!.findViewById(R.id.saveBtn)
        saveBtn.setOnClickListener { changeUILanguage() }

        val englishBtn: Button = contentView!!.findViewById(R.id.englishBtn)
        englishBtn.setOnClickListener { changeSelectedItem("US") }

        val chineseBtn: Button = contentView!!.findViewById(R.id.chineseBtn)
        chineseBtn.setOnClickListener { changeSelectedItem("CN") }

        return contentView
    }


    override fun contentLayout(): Int {
        return R.layout.fragment_me_language
    }

    private fun changeUILanguage() {
        Preference.sharedInstance().saveDefaultLanguage(selLanguage!!)

        Handler().post {
            val i = Intent(parentActivity, SplashActivity::class.java)
            i.putExtra("status", "language_changed")
            startActivity(i)
            parentActivity!!.finish()
        }
    }

    private fun changeSelectedItem(lang: String?) {

        if (lang == "US") {
            englishImg!!.visibility = View.VISIBLE
            chineseImg!!.visibility = View.GONE
        } else {
            englishImg!!.visibility = View.GONE
            chineseImg!!.visibility = View.VISIBLE
        }

        selLanguage = lang
    }
}
