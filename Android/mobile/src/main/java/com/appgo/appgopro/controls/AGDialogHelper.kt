package com.appgo.appgopro.controls

import android.content.Context
import android.support.v4.app.DialogFragment
import android.view.View
import com.appgo.appgopro.R
import com.appgo.appgopro.supers.SuperActivity

/**
 * Created by KSMA on 4/19/2017.
 */

object AGDialogHelper {

    private var alertDialog: AGAlertDialog? = null
    private var inputDialog: AGInputDialog?= null

    private val BTN_OK = "OK"
    private val BTN_CANCEL = "CANCEL"

    fun showConfirmDialog(title: String,
                          message: String,
                          activity: SuperActivity,
                          listener: AGDialogHelper.DialogListener) {
        AGDialogHelper.showConfirmDialog(title, message, AGDialogHelper.BTN_OK, AGDialogHelper.BTN_CANCEL, activity, listener)
    }

    /**
     * Show Dialog had "OK" and "Cancel" buttons
     *
     * @param title
     * @param message
     * @param positive
     * @param negative
     * @param activity
     * @param listener
     */
    fun showConfirmDialog(title: String,
                          message: String,
                          positive: String,
                          negative: String,
                          activity: SuperActivity,
                          listener: AGDialogHelper.DialogListener?) {
        val dialog = AGDialogHelper.createDialogOnActivity(activity)

        var defaultlistener: View.OnClickListener? = null
        var otherlistener: View.OnClickListener? = null
        if (listener != null) {
            defaultlistener = View.OnClickListener { listener.onOK() }
            otherlistener = View.OnClickListener { listener.onCancel() }
        }

        dialog.setData(AGAlertDialog.Companion.DIALOG_MODE_CONFIRM,
                title,
                message,
                positive,
                negative,
                defaultlistener,
                otherlistener)
        dialog.show()
    }


    /**
     * Show alert dialog which has "OK" button
     *
     * @param title
     * @param message
     * @param activity
     * @param listener
     */
    fun showAlertDialog(title: String,
                        message: String,
                        activity: SuperActivity,
                        listener: AGDialogHelper.DialogListener?) {
        val dialog = AGDialogHelper.createDialogOnActivity(activity)

        var defaultlistener: View.OnClickListener? = null
        var otherlistener: View.OnClickListener? = null
        if (listener != null) {
            defaultlistener = View.OnClickListener { listener.onOK() }
            otherlistener = View.OnClickListener { listener.onCancel() }
        }

        dialog.setData(AGAlertDialog.Companion.DIALOG_MODE_NORMAL,
                title,
                message,
                AGDialogHelper.BTN_OK,
                null,
                defaultlistener,
                otherlistener)
        dialog.show()
    }


    /**
     * Show error alert
     *
     * @param errorMsg
     * @param dismissListener
     * @param activity
     */
    @JvmOverloads
    fun showErrorAlert(errorMsg: String,
                       activity: SuperActivity,
                       dismissListener: AGDialogHelper.DialogListener? = null) {
        val dialog = AGDialogHelper.createDialogOnActivity(activity)

        var okListener: View.OnClickListener? = null
        var cancelListener: View.OnClickListener? = null
        if (dismissListener != null) {
            okListener = View.OnClickListener { dismissListener.onOK() }
            cancelListener = View.OnClickListener { dismissListener.onCancel() }
        }

        dialog.setData(AGAlertDialog.Companion.DIALOG_MODE_ERROR, activity.getString(R.string.error), errorMsg, AGDialogHelper.BTN_OK, null, okListener, cancelListener)
        dialog.show()
    }


    /**
     * Show Notification alert
     *
     * @param title
     * @param content
     * @param activity
     */
    fun showNotificationAlert(title: String, content: String, activity: SuperActivity) {
        val dialog = AGDialogHelper.createDialogOnActivity(activity)
        dialog.setData(AGAlertDialog.Companion.DIALOG_MODE_NOTIFICATION, title, content, AGDialogHelper.BTN_OK, null, null, null)
        dialog.show()
    }

    fun showInputDialog(title: String, desc: String, content: String, activity: SuperActivity, listener: OnInputDialogResult) {
        val dialog: AGInputDialog = AGDialogHelper.createInputDialogOnActivity(activity)
        dialog.setData(title, desc, content, listener)
        dialog.show()
    }

    interface DialogListener {
        fun onOK()
        fun onCancel()
    }

    private fun createDialogOnActivity(activity: SuperActivity): AGAlertDialog {
        if (AGDialogHelper.alertDialog != null && AGDialogHelper.alertDialog!!.isShowing)
            AGDialogHelper.alertDialog!!.dismiss()

        val parentContext: Context

        val topFragment = activity.topFragment
        if (topFragment != null && topFragment is DialogFragment) {
            parentContext = topFragment.dialog.context
        } else {
            parentContext = activity
        }

        AGDialogHelper.alertDialog = AGAlertDialog(parentContext)

        return AGDialogHelper.alertDialog as AGAlertDialog
    }

    private fun createInputDialogOnActivity(activity: SuperActivity): AGInputDialog {
        if (AGDialogHelper.inputDialog != null && AGDialogHelper.inputDialog!!.isShowing)
            AGDialogHelper.inputDialog!!.dismiss()
        val parentContext: Context?
        val topFragment = activity.topFragment
        if (topFragment != null && topFragment is DialogFragment)
            parentContext = topFragment.dialog.context
        else
            parentContext = activity
        AGDialogHelper.inputDialog = AGInputDialog(parentContext!!)
        return AGDialogHelper.inputDialog as AGInputDialog
    }
}
/**
 * Show error alert
 *
 * @param errorMsg
 * @param activity
 */
