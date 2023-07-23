package com.appgo.appgopro.controls

import android.app.Dialog
import android.content.Context
import android.graphics.Color
import android.graphics.drawable.ColorDrawable
import android.os.Bundle
import android.view.Window
import android.widget.Button
import android.widget.EditText
import android.widget.TextView
import com.appgo.appgopro.R
import com.appgo.appgopro.utils.ResolutionSet
import com.appgo.appgopro.utils.UIManager

/**
 * Created by Dayong Li on 4/19/2017.
 */

class AGInputDialog(context: Context) : Dialog(context) {

    private var defaultButton: Button? = null
    private var otherButton: Button? = null
    private var titleTextView: TextView? = null
    private var descTextView: TextView? = null
    private var contentTextEdit: EditText? = null
    private var title: String? = null
    private var desc: String? = null
    private var content: String? = null
    private var dialogResult: OnInputDialogResult? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        requestWindowFeature(Window.FEATURE_NO_TITLE)
        setContentView(R.layout.dialog_input)
        window.setBackgroundDrawable(ColorDrawable(Color.TRANSPARENT))
        initControls()
    }

    override fun onStart() {
        super.onStart()
        val screenSize = ResolutionSet.getScreenSize(context, isContainNavBar = false)
        val screenWidth = screenSize.x
        val width = screenWidth - context.resources.getDimensionPixelSize(R.dimen.dimen_16dp) * 2
        val layoutParams = window.attributes
        layoutParams.width = width
        window.setAttributes(layoutParams)
    }

    fun setData(title: String, desc: String, content: String, dialogResult: OnInputDialogResult) {
        this.title = title
        this.desc = desc
        this.content = content
        this.dialogResult = dialogResult
    }

    private fun initControls() {
        titleTextView = findViewById<TextView>(R.id.titleText)
        titleTextView!!.setText(title)
        descTextView = findViewById<TextView>(R.id.descText)
        descTextView!!.setText(desc)
        contentTextEdit = findViewById<EditText>(R.id.contentEdit)
        contentTextEdit!!.setText(content)
        defaultButton = findViewById<Button>(R.id.btn_default)
        defaultButton!!.setOnClickListener({ onClickedDefault() })
        otherButton = findViewById<Button>(R.id.btn_other)
        otherButton!!.setOnClickListener({ onClickedCancel() })
        defaultButton!!.setTextColor(UIManager.sharedInstance().getColor(R.color.MSG_DARK_BLUE))
        otherButton!!.setTextColor(UIManager.sharedInstance().getColor(R.color.MSG_TEXT_RED))
    }

    private fun onClickedDefault() {
        val result = contentTextEdit!!.getText().toString()
        if (dialogResult != null)
            dialogResult!!.finish(result)
        this@AGInputDialog.dismiss()
    }

    private fun onClickedCancel() {
        if (dialogResult != null)
            dialogResult!!.finish("")
        this@AGInputDialog.dismiss()
    }
}

interface OnInputDialogResult {
    fun finish(result: String)
}