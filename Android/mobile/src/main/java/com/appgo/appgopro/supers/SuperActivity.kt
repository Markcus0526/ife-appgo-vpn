package com.appgo.appgopro.supers

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.graphics.Rect
import android.os.Bundle
import android.support.v4.app.DialogFragment
import android.support.v4.app.Fragment
import android.support.v4.app.FragmentActivity
import android.support.v4.app.FragmentManager
import android.view.KeyEvent
import android.view.View
import android.view.inputmethod.InputMethodManager
import android.widget.EditText
import android.widget.Toast
import com.appgo.appgopro.R
import com.appgo.appgopro.controls.AGDialogHelper
import com.appgo.appgopro.controls.AGProgressDialog
import com.appgo.appgopro.controls.OnInputDialogResult
import com.appgo.appgopro.models.Preference
import com.appgo.appgopro.utils.*
import java.util.*

/**
 * Created by KSMA on 4/19/2017.
 */

abstract class SuperActivity : FragmentActivity() {
    private val TAG = "SuperActivity"

    /***********************************************************************************************
     * Constants
     */
    protected val ANIM_DIRECTION_FROM_NONE = -1
    protected val ANIM_DIRECTION_FROM_LEFT = 0
    protected val ANIM_DIRECTION_FROM_RIGHT = 1
    protected val ANIM_DIRECTION_FROM_BOTTOM = 2
    protected val ANIM_DIRECTION_FROM_TOP = 3

    private var curOrientation: Int = 0
    private var progressDialog: AGProgressDialog? = null

    private var iapResponseListener: onActivityResultListener? = null

    private var isInitializedResolution = false
    /**
     * End of 'Private fields'
     */

    // To Finish App, need to tap on back button twice in 3 seconds
    private val TAP_INTERVAL = 3 * 1000        // 3 seconds
    private var lastTapTimeStamp: Long = 0


    val isShowingProgressDialog: Boolean
        get() = progressDialog != null && progressDialog!!.isShowing

    val rootView: View
        get() = findViewById(android.R.id.content)

    /**
     * End of 'Fragments transaction methods'
     */


    /**
     * Get the identifier value of fragment container view
     *
     * @return Returns the identifier of the container view
     */
    protected open val containerViewId: Int
        get() = 0


    val topFragment: Fragment?
        get() {
            var resultFragment: Fragment? = null
            val fragmentManager = supportFragmentManager

            if (fragmentManager.backStackEntryCount > 0) {
                val fragmentCount = fragmentManager.backStackEntryCount

                for (i in fragmentCount - 1 downTo 0) {
                    val tagName = fragmentManager.getBackStackEntryAt(i).name

                    val fragmentItem = fragmentManager.findFragmentByTag(tagName) ?: continue

                    resultFragment = fragmentItem
                    break
                }
            }

            if (resultFragment == null && this@SuperActivity is SuperTabActivity) {
                val tabActivity: SuperTabActivity = this@SuperActivity
                if (tabActivity.currentTabIndex >= 0 && tabActivity.fragmentsListArray.size > tabActivity.currentTabIndex) {
                    val fragments = tabActivity.fragmentsListArray[tabActivity.currentTabIndex]
                    if (fragments.size > 0)
                        resultFragment = fragments[fragments.size - 1]
                }
            }

            return resultFragment
        }
    ////////////////////////////////////////////////////////////////////////////////////////////////


    override fun onResume() {
        super.onResume()

        AGLogger.log(TAG, "onResume : " + javaClass.name)

        hideKeyboard()

        topInstance = this@SuperActivity
    }


    override fun onPause() {
        super.onPause()

        hideKeyboard()
    }

    public override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
    }

    override fun onDestroy() {
        super.onDestroy()
    }

    override fun onLowMemory() {
        super.onLowMemory()
    }

    override fun attachBaseContext(newBase: Context) {
        val lang = Preference.sharedInstance().loadDefaultLanguage()
        super.attachBaseContext(LocaleContextWrapper.wrap(newBase, lang.toLowerCase()))
    }

    override fun setContentView(layoutResID: Int) {
        super.setContentView(layoutResID)

        // Initialize resolution set
        if (Config.USE_RESOLUTIONSET) {
            val mainLayout = window.decorView.findViewById<View>(android.R.id.content)

            if (Config.USE_GLOBAL_LISTENER) {
                mainLayout.viewTreeObserver.addOnGlobalLayoutListener {
                    if (!isInitializedResolution) {
                        val curOrientation = resources.configuration.orientation

                        val mainLayout = window.decorView.findViewById<View>(android.R.id.content)

                        val r = Rect()
                        mainLayout.getLocalVisibleRect(r)
                        ResolutionSet.sharedInstance().setResolution(r.width(), r.height(), true)
                        ResolutionSet.sharedInstance().iterateChild(mainLayout)
                        isInitializedResolution = true

                        changedLayoutOrientation(curOrientation)
                    }
                }
            } else {
                ResolutionSet.sharedInstance().iterateChild(mainLayout)
                changedLayoutOrientation(curOrientation)
            }
        }

        initControls()

        // Initialize animation
        val nDir = intent.getIntExtra(AnimConst.EXTRA_ANIMDIR, -1)
        if (nDir == AnimConst.ANIMDIR_FROM_LEFT)
            overridePendingTransition(R.anim.left_in, R.anim.right_out)
        else if (nDir == AnimConst.ANIMDIR_FROM_RIGHT)
            overridePendingTransition(R.anim.right_in, R.anim.left_out)
        else
            overridePendingTransition(0, 0)
    }


    protected fun clearExtras() {
        val extras = intent.extras

        val keySet = extras!!.keySet()
        for (keyItem in keySet) {
            if (intent.hasExtra(keyItem))
                intent.removeExtra(keyItem)
        }
    }

    override fun startActivity(intent: Intent) {
        super.startActivity(intent)
    }

    override fun startActivityForResult(intent: Intent, requestCode: Int) {
        super.startActivityForResult(intent, requestCode)
    }

    /**
     * Link control objects and views, and initializes controls
     */
    fun initControls() {
        val backButton: View? = findViewById(R.id.backBtn)
        if (backButton != null) {
            backButton.setOnClickListener(View.OnClickListener { onClickedBackSystemButton() })
        }
    }

    fun pushNewActivityAnimated(dstClass: Class<*>, bundle: Bundle) {
        pushNewActivityAnimated(dstClass, AnimConst.ANIMDIR_FROM_RIGHT, 0, bundle, -1)
    }

    fun pushNewActivityAnimated(dstClass: Class<*>, bundle: Bundle, req_code: Int) {
        pushNewActivityAnimated(dstClass, AnimConst.ANIMDIR_FROM_RIGHT, 0, bundle, req_code)
    }

    fun pushNewActivityAnimated(dstClass: Class<*>, animation: Int, bundle: Bundle) {
        pushNewActivityAnimated(dstClass, animation, 0, bundle, -1)
    }

    fun pushNewActivityAnimated(dstClass: Class<*>,
                                animation: Int,
                                activity_flags: Int,
                                req_code: Int) {
        pushNewActivityAnimated(dstClass, animation, activity_flags, null, req_code)
    }

    /**
     * Method to show new activity with animation.
     * Now animation only supports two types - cover from right and from left.
     *
     * @param dstClass       Destination activity class.
     * @param animation      Push activity animation. See AnimConst class.
     * @param activity_flags Used for the startActivityForResult(...) method
     * @param extras         Used to pass extra parameters to activity
     * @see AnimConst
     *
     * @see Intent
     *
     * @see Bundle
     */
    @JvmOverloads
    fun pushNewActivityAnimated(dstClass: Class<*>,
                                animation: Int = AnimConst.ANIMDIR_FROM_RIGHT,
                                activity_flags: Int = 0,
                                extras: Bundle? = null,
                                req_code: Int = -1) {
        runOnUiThread {
            val intent = Intent(this@SuperActivity, dstClass)
            intent.putExtra(AnimConst.EXTRA_ANIMDIR, animation)

            if (activity_flags != 0)
                intent.addFlags(activity_flags)

            if (extras != null)
                intent.putExtras(extras)

            this@SuperActivity.startActivityForResult(intent, req_code)
        }
    }

    /**
     * Method to dismiss current activity without animation
     */
    fun popOverCurActivityNonAnimated() {
        runOnUiThread {
            this@SuperActivity.finish()
            overridePendingTransition(0, 0)
        }
    }

    /**
     * Method to dismiss current activity with animation
     * Animation is the opposite of the animation which is used to show activity
     */
    fun popOverCurActivityAnimated() {
        runOnUiThread {
            this@SuperActivity.finish()

            val nDir = intent.getIntExtra(AnimConst.EXTRA_ANIMDIR, -1)
            if (nDir == AnimConst.ANIMDIR_FROM_LEFT)
                overridePendingTransition(R.anim.right_in, R.anim.left_out)
            else if (nDir == AnimConst.ANIMDIR_FROM_RIGHT)
                overridePendingTransition(R.anim.left_in, R.anim.right_out)
            else
                overridePendingTransition(0, 0)
        }
    }

    @JvmOverloads
    fun showProgressDialog(backTrans: Boolean = true) {
        showProgressDialog("", getString(R.string.please_wait), backTrans)
    }

    fun showProgressDialog(text: String) {
        showProgressDialog("", text, true)
    }

    fun showProgressDialog(text: String, backTrans: Boolean) {
        showProgressDialog("", text, backTrans)
    }

    @JvmOverloads
    fun showProgressDialog(title: String, text: String, backTrans: Boolean = true) {

        if (progressDialog != null && progressDialog!!.isShowing)
            return

        val parentContext: Context
        val topFragment = topFragment
        if (topFragment != null && topFragment is DialogFragment && topFragment.dialog != null) {
            parentContext = topFragment.dialog.context
        } else {
            parentContext = this@SuperActivity
        }

        progressDialog = AGProgressDialog(parentContext)
        progressDialog!!.setData(title, text, backTrans)
        progressDialog!!.show()
    }

    /**
     * Close Progress Dialog
     */
    fun dismissProgressDialog() {
        try {
            if (progressDialog != null) {
                progressDialog!!.dismiss()
                progressDialog = null
            }
        } catch (e: Exception) {
            e.printStackTrace()
            progressDialog!!.setCancelable(true)
        }

    }

    fun dismissProgressDialogWithDelay(delayMillis: Int) {
        val timerTask = object : TimerTask() {
            override fun run() {
                dismissProgressDialog()
            }
        }

        val timer = Timer()
        timer.schedule(timerTask, delayMillis.toLong())
    }


    fun showErrorDialog(text: String) {
        try {
            showErrorDialog(text, null)
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }


    fun showErrorDialog(text: String, dismissListener: AGDialogHelper.DialogListener?) {
        try {
            dismissProgressDialog()
            AGDialogHelper.showErrorAlert(text, this@SuperActivity, dismissListener)
        } catch (e: Exception) {
            e.printStackTrace()
        }

    }

    fun showAlertDialog(title: String, message: String, listener: AGDialogHelper.DialogListener?) {
        try {
            dismissProgressDialog()
            AGDialogHelper.showAlertDialog(title, message, this@SuperActivity, listener)
        } catch (e: Exception) {
            e.printStackTrace()
        }

    }

    fun showQuestionDialog(title: String, message: String,
                           positive: String, negative: String,
                           listener: AGDialogHelper.DialogListener?) {
        try {
            dismissProgressDialog()
            AGDialogHelper.showConfirmDialog(title, message, positive, negative, this@SuperActivity, listener)
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }

    fun showInputDialog(title: String, desc: String, content: String, listener: OnInputDialogResult) {
        try {
            dismissProgressDialog()
            AGDialogHelper.showInputDialog(title, desc, content, this@SuperActivity, listener)
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        var processed = false
        if (iapResponseListener != null) {
            processed = iapResponseListener!!.onSharedActivityResult(requestCode, resultCode, data)
        }

        if (processed)
            return

        val topFragment = topFragment
        if (topFragment != null) {
            topFragment.onActivityResult(requestCode, resultCode, data)
            return
        }

        super.onActivityResult(requestCode, resultCode, data)
    }

    fun setSharedListener(listener: onActivityResultListener) {
        iapResponseListener = listener
    }

    fun changedLayoutOrientation(orientation: Int) {
        curOrientation = orientation
    }

    fun hideKeyboard() {
        val v = currentFocus
        if (v != null && v is EditText) {
            v.clearFocus()
        }

        val imm = getSystemService(Context.INPUT_METHOD_SERVICE) as InputMethodManager
        imm.hideSoftInputFromWindow(rootView.applicationWindowToken, 0)
    }


    /****************************************************************************************************************
     * Fragments transaction methods
     */
    fun showDialogFragment(fragment: SuperDialogFragment) {
        try {
            val tag = generateUniqueTag()

            val fragmentManager = supportFragmentManager
            val ft = fragmentManager.beginTransaction()
            ft.addToBackStack(tag)
            fragment.show(ft, tag)
        } catch (e: IllegalStateException) {
            e.printStackTrace()
        }

    }


    // Push new fragment if activity is SuperTabActivity, present new fragment otherwise
    fun showNewFragment(fragment: SuperFragment) {
        if (this@SuperActivity is SuperTabActivity) {
            this@SuperActivity.pushNewFragment(fragment)
        } else {
            presentNewFragmentFromRight(fragment)
        }
    }


    fun presentNewFragmentFromRight(newFragment: SuperFragment) {
        presentNewFragment(newFragment, ANIM_DIRECTION_FROM_RIGHT)
    }


    fun presentNewFragmentFromBottom(newFragment: SuperFragment) {
        presentNewFragment(newFragment, ANIM_DIRECTION_FROM_BOTTOM)
    }


    fun presentNewFragment(newFragment: SuperFragment, anim_dir: Int) {
        hideKeyboard()

        if (containerViewId == 0)
            return

        val fragmentManager = supportFragmentManager
        val transaction = fragmentManager.beginTransaction()

        if (anim_dir == ANIM_DIRECTION_FROM_RIGHT)
            transaction.setCustomAnimations(R.anim.right_in, R.anim.left_out, R.anim.left_in, R.anim.right_out)
        else if (anim_dir == ANIM_DIRECTION_FROM_LEFT)
            transaction.setCustomAnimations(R.anim.left_in, R.anim.right_out, R.anim.right_in, R.anim.left_out)
        else if (anim_dir == ANIM_DIRECTION_FROM_TOP)
            transaction.setCustomAnimations(R.anim.top_in, R.anim.bottom_out, R.anim.bottom_in, R.anim.top_out)
        else if (anim_dir == ANIM_DIRECTION_FROM_BOTTOM)
            transaction.setCustomAnimations(R.anim.bottom_in, R.anim.top_out, R.anim.top_in, R.anim.bottom_out)


        val prevFragment = topFragment
        if (prevFragment != null)
            transaction.hide(prevFragment)

        val tag = generateUniqueTag()
        transaction.add(containerViewId, newFragment, tag)
        transaction.addToBackStack(tag)

        try {
            transaction.commit()
        } catch (ex: Exception) {
            ex.printStackTrace()
        }

    }


    private fun generateUniqueTag(): String {
        val fragmentManager = supportFragmentManager

        var tag = ""
        var index = fragmentManager.backStackEntryCount
        while (true) {
            tag = "" + index
            if (fragmentManager.findFragmentByTag(tag) == null) {
                break
            }

            index++
        }

        return tag
    }

    /**
     * Class for the activity transition animation constants
     */
    object AnimConst {
        val ANIMDIR_NONE = -1
        val ANIMDIR_FROM_LEFT = 0
        val ANIMDIR_FROM_RIGHT = 1

        val EXTRA_ANIMDIR = "anim_direction"
    }


    open fun onClickedBackSystemButton() {

        val topFragment = topFragment
        if (topFragment != null && topFragment.tag != null) {
            if (topFragment is DialogFragment && !topFragment.isCancelable) {
                return
            }

            if (topFragment is DialogFragment) {
                topFragment.dismiss()
            } else {
                val fragmentManager = supportFragmentManager
                fragmentManager.popBackStack(topFragment.tag, FragmentManager.POP_BACK_STACK_INCLUSIVE)
            }
        } else {
            if (Config.NEED_CONFIRM_EXIT && !Config.PREVENT_CLOSE_APP) {
                if (isTaskRoot) {
                    if (Calendar.getInstance().timeInMillis - lastTapTimeStamp > TAP_INTERVAL) {
                        Toast.makeText(this@SuperActivity, R.string.tap_again_to_exit, Toast.LENGTH_LONG).show()
                        lastTapTimeStamp = Calendar.getInstance().timeInMillis
                        return
                    }
                }
            }

            if (isTaskRoot) {
                if (!Config.PREVENT_CLOSE_APP) {
                    popOverCurActivityNonAnimated()
                    System.exit(0)
                }
            } else {
                setResult(Activity.RESULT_CANCELED, Intent())
                popOverCurActivityAnimated()
            }
        }
    }


    override fun onKeyDown(keyCode: Int, event: KeyEvent): Boolean {
        if (event.action == KeyEvent.ACTION_DOWN && keyCode == KeyEvent.KEYCODE_BACK) {
            onClickedBackSystemButton()
            return true
        }

        return super.onKeyDown(keyCode, event)
    }

    companion object {
        /*
	 * End of 'Constants'
	 **********************************************************************************************/

        /***********************************************************************************************
         * Private fields
         */
        private var topInstance: SuperActivity? = null


        fun topInstance(): SuperActivity? {
            return topInstance
        }
    }

}///////////////////////// Activity transition methods begin /////////////////////////
///////////////////////// End of "Activity transition methods" /////////////////////////

