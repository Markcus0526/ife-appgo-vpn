package com.appgo.appgopro.supers

import android.content.Context
import android.content.DialogInterface
import android.os.Bundle
import android.support.v4.app.DialogFragment
import android.view.KeyEvent
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import com.appgo.appgopro.utils.AGLogger
import com.appgo.appgopro.utils.Config
import com.appgo.appgopro.utils.ResolutionSet

/**
 * Created by KSMA on 4/19/2017.
 */

abstract class SuperDialogFragment : DialogFragment() {
    private val TAG = "SuperDialogFragment"
    protected var mainLayout: View? = null
    private var dismissListener: SuperDialogDismissListener? = null
    private var dialogAlreadyStarted = false

    val dialogFragmentStyle: Int
        get() = DialogFragment.STYLE_NO_TITLE

    val dialogFragmentTheme: Int
        get() = android.R.style.Theme_Holo_Dialog


    val safeContext: Context?
        get() {
            if (context != null)
                return context

            if (activity != null)
                return activity

            return if (SuperActivity.topInstance() != null) SuperActivity.topInstance() else null

        }

    val parentActivity: SuperActivity?
        get() {
            val parentActivity = activity
            return if (parentActivity != null && parentActivity is SuperActivity) parentActivity else null

        }


    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setStyle(dialogFragmentStyle, dialogFragmentTheme)
    }

    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View? {
        // create root view
        val rootView = setContentLayout(inflater, container, contentLayout())

        retainInstance = true

        if (Config.USE_RESOLUTIONSET) {
            // initialize resolution set
            mainLayout = rootView
            ResolutionSet.sharedInstance().iterateChild(mainLayout!!)
        }

        return rootView
    }


    override fun onActivityCreated(savedInstanceState: Bundle?) {
        super.onActivityCreated(savedInstanceState)

        val dialog = dialog
        dialog.setOnKeyListener(DialogInterface.OnKeyListener { dialog, keyCode, event ->
            if (event.action == KeyEvent.ACTION_DOWN && keyCode == KeyEvent.KEYCODE_BACK) {
                parentActivity!!.onClickedBackSystemButton()
                return@OnKeyListener true
            }

            false
        })
    }


    override fun onStart() {
        super.onStart()

        if (!dialogAlreadyStarted) {
            startAction()
            dialogAlreadyStarted = true
        }
    }

    /**
     * Method to start work such as
     */
    abstract fun startAction()


    override fun onDestroyView() {
        val dialog = dialog

        // Work around bug: http://code.google.com/p/android/issues/detail?id=17423
        if (dialog != null && retainInstance)
            dialog.setDismissMessage(null)

        super.onDestroyView()
    }

    override fun onDismiss(dialog: DialogInterface?) {
        dismissProgressDialog()

        super.onDismiss(dialog)

        AGLogger.log(TAG, "onDismiss")
        if (dismissListener != null) {
            dismissListener!!.onDismiss()
        }
    }


    fun setContentLayout(inflater: LayoutInflater, container: ViewGroup?, layout: Int): View {
        return inflater.inflate(layout, container, false)
    }

    /**
     * Defines the layout identifier of the fragment
     *
     * @return layout identifier
     * @note This method must to be overrode to show its content
     */
    abstract fun contentLayout(): Int

    fun showProgressDialog() {
        if (parentActivity != null)
            parentActivity!!.showProgressDialog()
    }

    fun showProgressDialog(text: String) {
        if (parentActivity != null)
            parentActivity!!.showProgressDialog(text)
    }

    fun showProgressDialog(title: String, text: String) {
        if (parentActivity != null)
            parentActivity!!.showProgressDialog(title, text)
    }


    fun dismissProgressDialog() {
        if (parentActivity != null)
            parentActivity!!.dismissProgressDialog()
    }

    fun showErrorDialog(text: String) {
        if (parentActivity != null)
            parentActivity!!.showErrorDialog(text)
    }

    override fun dismiss() {
        super.dismiss()
    }

    fun setDismissListener(listener: SuperDialogDismissListener) {
        dismissListener = listener
    }

    fun dismiss(listener: SuperDialogDismissListener) {
        dismissListener = listener
        super.dismiss()
    }

    interface SuperDialogDismissListener {
        fun onDismiss()
    }

}
