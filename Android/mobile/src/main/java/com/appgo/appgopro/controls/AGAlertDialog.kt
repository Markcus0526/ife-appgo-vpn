package com.appgo.appgopro.controls

import android.app.Dialog
import android.content.Context
import android.graphics.Color
import android.graphics.drawable.ColorDrawable
import android.os.Bundle
import android.view.View
import android.view.Window
import android.widget.Button
import android.widget.TextView
import com.appgo.appgopro.R
import com.appgo.appgopro.utils.ResolutionSet
import com.appgo.appgopro.utils.UIManager

/**
 * Created by KSMA on 4/19/2017.
 */

class AGAlertDialog(context: Context) : Dialog(context) {

    private var dialogMode = AGAlertDialog.Companion.DIALOG_MODE_NOTIFICATION

    private var titleTextView: TextView? = null
    private var contentTextView: TextView? = null
    private var defaultButton: Button? = null
    private var otherButton: Button? = null

    private var title: String? = null
    private var content: String? = null
    private var defaultTitle: String? = null
    private var otherTitle: String? = null
    private var defaultListener: View.OnClickListener? = null
    private var otherListener: View.OnClickListener? = null

    public override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        requestWindowFeature(Window.FEATURE_NO_TITLE)
        setContentView(R.layout.dialog_alert)

        window!!.setBackgroundDrawable(ColorDrawable(Color.TRANSPARENT))

        initControls()
    }

    public override fun onStart() {
        super.onStart()

        val screenSize = ResolutionSet.getScreenSize(context, false)
        val screenWidth = screenSize.x
        val width = screenWidth - context.resources.getDimensionPixelSize(R.dimen.dimen_16dp) * 2

        val layoutParams = window!!.attributes
        layoutParams.width = width

        window!!.attributes = layoutParams
    }


    fun setData(
            dialogMode: Int,
            title: String,
            content: String,
            defaultButton: String,
            otherButton: String?,
            defaultListener: View.OnClickListener?,
            otherListener: View.OnClickListener?
    ) {
        this.dialogMode = dialogMode

        this.title = title
        this.content = content
        this.defaultTitle = defaultButton
        this.otherTitle = otherButton
        this.defaultListener = defaultListener
        this.otherListener = otherListener
    }


    private fun initControls() {
        titleTextView = findViewById<View>(R.id.titleText) as TextView
        titleTextView!!.text = title

        contentTextView = findViewById<View>(R.id.contentText) as TextView
        contentTextView!!.text = content

        defaultButton = findViewById<View>(R.id.btn_default) as Button
        defaultButton!!.text = defaultTitle
        defaultButton!!.setOnClickListener { onClickedDefault() }

        otherButton = findViewById<View>(R.id.btn_other) as Button
        otherButton!!.text = otherTitle
        otherButton!!.setOnClickListener { onClickedCancel() }


        if (title == null || title!!.trim { it <= ' ' }.length == 0) {
            titleTextView!!.visibility = View.GONE
        }

        if (defaultTitle == null || defaultTitle!!.trim { it <= ' ' }.length == 0) {
            defaultButton!!.visibility = View.GONE
        }

        if (otherTitle == null || otherTitle!!.trim { it <= ' ' }.length == 0) {
            otherButton!!.visibility = View.GONE
        }


        if (dialogMode == AGAlertDialog.Companion.DIALOG_MODE_NORMAL) {
            titleTextView!!.setTextColor(UIManager.sharedInstance().getColor(R.color.MSG_NORMAL_TEXT))
            contentTextView!!.setTextColor(UIManager.sharedInstance().getColor(R.color.MSG_NORMAL_TEXT))
            defaultButton!!.setTextColor(UIManager.sharedInstance().getColor(R.color.MSG_DARK_BLUE))
            otherButton!!.setTextColor(UIManager.sharedInstance().getColor(R.color.MSG_TEXT_RED))
            otherButton!!.visibility = View.GONE
        } else if (dialogMode == AGAlertDialog.Companion.DIALOG_MODE_NOTIFICATION) {
            titleTextView!!.setTextColor(UIManager.sharedInstance().getColor(R.color.MSG_DARK_BLUE))
            contentTextView!!.setTextColor(UIManager.sharedInstance().getColor(R.color.MSG_NORMAL_TEXT))
            defaultButton!!.setTextColor(UIManager.sharedInstance().getColor(R.color.MSG_DARK_BLUE))
            otherButton!!.setTextColor(UIManager.sharedInstance().getColor(R.color.MSG_DARK_BLUE))
            otherButton!!.visibility = View.GONE
        } else if (dialogMode == AGAlertDialog.Companion.DIALOG_MODE_CONFIRM) {
            titleTextView!!.setTextColor(UIManager.sharedInstance().getColor(R.color.MSG_NORMAL_TEXT))
            contentTextView!!.setTextColor(UIManager.sharedInstance().getColor(R.color.MSG_NORMAL_TEXT))
            defaultButton!!.setTextColor(UIManager.sharedInstance().getColor(R.color.MSG_DARK_BLUE))
            otherButton!!.setTextColor(UIManager.sharedInstance().getColor(R.color.MSG_TEXT_RED))
        } else if (dialogMode == AGAlertDialog.Companion.DIALOG_MODE_ERROR) {
            titleTextView!!.setTextColor(UIManager.sharedInstance().getColor(R.color.MSG_NORMAL_TEXT))
            contentTextView!!.setTextColor(UIManager.sharedInstance().getColor(R.color.MSG_NORMAL_TEXT))
            defaultButton!!.setTextColor(UIManager.sharedInstance().getColor(R.color.MSG_DARK_BLUE))
            otherButton!!.setTextColor(UIManager.sharedInstance().getColor(R.color.MSG_TEXT_RED))
            otherButton!!.visibility = View.GONE
        }

        setOnDismissListener {
            if (otherListener != null) {
                otherListener!!.onClick(null)
            } else if (defaultListener != null) {
                defaultListener!!.onClick(null)
            }
        }
    }


    private fun onClickedDefault() {
        this@AGAlertDialog.dismiss()
        if (defaultListener != null)
            defaultListener!!.onClick(null)
    }

    private fun onClickedCancel() {
        this@AGAlertDialog.dismiss()
        if (otherListener != null)
            otherListener!!.onClick(null)
    }

    companion object {

        val DIALOG_MODE_NORMAL = 0
        val DIALOG_MODE_NOTIFICATION = 1
        val DIALOG_MODE_CONFIRM = 2
        val DIALOG_MODE_ERROR = 3
    }
}
