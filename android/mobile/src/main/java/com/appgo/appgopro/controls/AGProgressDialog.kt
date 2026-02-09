package com.appgo.appgopro.controls

import android.app.Dialog
import android.content.Context
import android.graphics.Color
import android.graphics.drawable.ColorDrawable
import android.os.Bundle
import android.view.View
import android.view.Window
import android.widget.TextView
import com.appgo.appgopro.R
import com.appgo.appgopro.utils.ResolutionSet

/**
 * Created by KSMA on 4/19/2017.
 */

class AGProgressDialog(context: Context) : Dialog(context) {
    private var title: String? = ""
    private var content = ""
    private var backTrans = false

    private var titleTextView: TextView? = null
    private var contentTextView: TextView? = null
    private var backgroundView: View? = null

    public override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        requestWindowFeature(Window.FEATURE_NO_TITLE)
        setContentView(R.layout.dialog_progress)

        window!!.setBackgroundDrawable(ColorDrawable(Color.TRANSPARENT))

        initControls()
    }


    public override fun onStart() {
        super.onStart()

        val screenSize = ResolutionSet.getScreenSize(context, false)
        val screenWidth = screenSize.x
        val screenHeight = screenSize.y

        val layoutParams = window!!.attributes
        layoutParams.width = screenWidth
        layoutParams.height = screenHeight

        window!!.attributes = layoutParams
    }


    fun setData(title: String, content: String, backgroundTransparent: Boolean) {
        this.title = title
        this.content = content
        this.backTrans = backgroundTransparent
    }


    private fun initControls() {
        setCancelable(false)

        if (content.trim { it <= ' ' }.length == 0) {
            content = context.getString(R.string.please_wait)
        }

        titleTextView = findViewById<TextView>(R.id.titleText)
        if (title == null || title!!.trim { it <= ' ' }.length == 0)
            titleTextView!!.visibility = View.GONE
        else
            titleTextView!!.text = title

        contentTextView = findViewById<TextView>(R.id.contentText)
        contentTextView!!.text = content

        backgroundView = findViewById(R.id.content_layout)
        if (backTrans) {
            backgroundView!!.setBackgroundColor(Color.TRANSPARENT)
        } else {
            backgroundView!!.setBackgroundColor(Color.argb(0x90, 0, 0, 0))
        }
    }

}
