package com.appgo.appgopro.supers

import android.content.Context
import android.os.Bundle
import android.support.v4.app.Fragment
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import com.appgo.appgopro.AppGoApplication.Companion.app
import com.appgo.appgopro.R
import com.appgo.appgopro.controls.AGDialogHelper
import com.appgo.appgopro.controls.OnInputDialogResult
import com.appgo.appgopro.utils.AGUtils
import com.appgo.appgopro.utils.Config
import com.appgo.appgopro.utils.ResolutionSet
import java.lang.reflect.Field

/**
 * Created by KSMA on 4/19/2017.
 */

abstract class SuperFragment : Fragment() {
    private val TAG = "SuperFragment"
    var isShowTabBar = true
        private set
    var isApplyToChilds = false


    val parentActivity: SuperActivity?
        get() {
            val parentActivity = activity
            return if (parentActivity != null && parentActivity is SuperActivity) parentActivity else null
        }


    val safeContext: Context?
        get() {
            if (context != null)
                return context

            if (activity != null)
                return activity

            if (SuperActivity.topInstance() != null)
                return SuperActivity.topInstance()

            return if (app != null) app.applicationContext else null

        }


    /**
     * Detect if this fragment is visible to user or not.
     * when the fragment seems visible, no matter parent fragment is hidden or not
     * So it should be decided on the basis of hierachy tree.
     * if one of the parent fragment is hidden this fragment should be considered as hidden
     */
    val isVisibleOnHierachy: Boolean
        get() {
            if (!this@SuperFragment.isVisible)
                return false

            var parentFragment = parentFragment
            while (parentFragment != null) {
                if (!parentFragment.isVisible)
                    return false

                parentFragment = parentFragment.parentFragment
            }

            return true
        }

    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View? {
        // create root view
        val rootView = setContentLayout(inflater, container, contentLayout())

        if (Config.USE_RESOLUTIONSET) {
            // initialize resolution set
            ResolutionSet.sharedInstance().iterateChild(rootView)
        }

        // Define back button action
        val backBtn = rootView.findViewById<View>(R.id.backBtn)
        if (backBtn != null) {
            backBtn.setOnClickListener({ onClickedBackButton() })
        }

        AGUtils.sharedInstance().hideKeyboardInView(rootView)

        return rootView
    }


    override fun onHiddenChanged(hidden: Boolean) {
        super.onHiddenChanged(hidden)

        if (!hidden)
            hideKeyboard()
    }


    override fun onResume() {
        super.onResume()
        hideKeyboard()
    }


    override fun onStart() {
        super.onStart()
        hideKeyboard()
    }

    fun hideKeyboard() {
        val parentActivity = parentActivity
        parentActivity?.hideKeyboard()
    }

    override fun onDetach() {
        super.onDetach()

        if (sChildFragmentManagerField != null) {
            try {
                sChildFragmentManagerField.set(this, null)
            } catch (e: IllegalAccessException) {
                e.printStackTrace()
            }

        }
    }

    fun setContentLayout(inflater: LayoutInflater, container: ViewGroup?, layout: Int): View {
        return inflater.inflate(layout, container, false)
    }


    fun onClickedBackButton() {
        onClickedBackSystemButton()
    }


    fun onClickedBackSystemButton() {
        if (parentActivity != null)
            parentActivity!!.onClickedBackSystemButton()
    }

    // layout resource : R.layout.fragment_profile ...
    abstract fun contentLayout(): Int

    fun showProgressDialog() {
        if (parentActivity != null)
            parentActivity!!.showProgressDialog()
    }

    fun showProgressDialog(text: String) {
        if (parentActivity != null)
            parentActivity!!.showProgressDialog(text)
    }

    fun dismissProgressDialog() {
        if (parentActivity != null)
            parentActivity!!.dismissProgressDialog()
    }

    fun dismissProgressDialogWithDelay(delayMillis: Int) {
        if (parentActivity != null)
            parentActivity!!.dismissProgressDialogWithDelay(delayMillis)
    }

    @JvmOverloads
    fun showErrorDialog(text: String, dismissListener: AGDialogHelper.DialogListener? = null) {
        if (parentActivity != null)
            parentActivity!!.showErrorDialog(text, dismissListener)
    }

    @JvmOverloads
    fun showAlertDialog(title: String, text: String, dismissListener: AGDialogHelper.DialogListener? = null) {
        if (parentActivity != null)
            parentActivity!!.showAlertDialog(title, text, dismissListener)
    }

    fun showInputDialog(title: String, desc: String, content: String, dismissListener: OnInputDialogResult) {
        if (parentActivity != null)
            parentActivity!!.showInputDialog(title, desc, content, dismissListener)
    }

    fun showTabBar(isShow: Boolean) {
        isShowTabBar = isShow
    }

    fun showQuestionDialog(title: String, text: String, positive: String, negative: String, dismissListener: AGDialogHelper.DialogListener?) {
        if (parentActivity != null)
            parentActivity!!.showQuestionDialog(title, text, positive, negative, dismissListener)
    }

    companion object {

        private val sChildFragmentManagerField: Field?


        init {
            var f: Field? = null
            try {
                f = Fragment::class.java.getDeclaredField("mChildFragmentManager")
                f!!.isAccessible = true
            } catch (e: NoSuchFieldException) {
                e.printStackTrace()
            }

            sChildFragmentManagerField = f
        }
    }
}
