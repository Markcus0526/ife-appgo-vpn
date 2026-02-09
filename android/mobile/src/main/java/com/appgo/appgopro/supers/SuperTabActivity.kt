package com.appgo.appgopro.supers

import android.os.Bundle
import android.view.View
import com.appgo.appgopro.R
import java.util.*

/**
 * Created by KSMA on 4/19/2017.
 */

open class SuperTabActivity : SuperActivity() {
    private val FRAGMENT_LOG_MANAGEMENT = false        // Required by Diana. Has logical issue. Do not set as true

    protected var tabChangedListener: OnTabChangedListener? = null
    var currentTabIndex = 0
    var fragmentsListArray = ArrayList<ArrayList<SuperFragment>>()
    protected var fragmentsLogArray = ArrayList<STFragmentLog>()

    protected var tabBar: View? = null
    protected var tabBarShadow: View? = null


    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
    }

    override fun setContentView(layoutResID: Int) {
        super.setContentView(layoutResID)
    }

    @JvmOverloads
    fun pushNewFragment(newFragment: SuperFragment, needAnimation: Boolean = true) {
        hideKeyboard()
        if (needAnimation)
            showFragment(newFragment, ANIM_DIRECTION_FROM_RIGHT)
        else
            showFragment(newFragment, ANIM_DIRECTION_FROM_NONE)

        val fragmentsForCurrentTab = fragmentsListArray[currentTabIndex]
        fragmentsForCurrentTab.add(newFragment)

        if (FRAGMENT_LOG_MANAGEMENT) {
            fragmentsLogArray.add(STFragmentLog(currentTabIndex, fragmentsForCurrentTab.size - 1))
        }
    }

    fun popFragment() {
        hideKeyboard()

        val fragmentsForCurrentTab = fragmentsListArray[currentTabIndex]
        if (fragmentsForCurrentTab.size < 2)
            return

        val topFragment = fragmentsForCurrentTab[fragmentsForCurrentTab.size - 1]
        val newTopFragment = fragmentsForCurrentTab[fragmentsForCurrentTab.size - 2]

        val transaction = supportFragmentManager.beginTransaction()
        transaction.setCustomAnimations(R.anim.left_in, R.anim.right_out)

        if (topFragment.isAdded)
            transaction.remove(topFragment)

        if (newTopFragment.isAdded) {
            if (tabBar != null) {
                setTabbarVisibility(newTopFragment.isShowTabBar)
            }

            transaction.show(newTopFragment)
            try {
                transaction.commit()
            } catch (ex: Exception) {
                ex.printStackTrace()
            }

        } else {
            showFragment(newTopFragment, ANIM_DIRECTION_FROM_LEFT)
        }

        fragmentsForCurrentTab.removeAt(fragmentsForCurrentTab.size - 1)
    }


    override fun onClickedBackSystemButton() {

        val topFragment = topFragment
        if (topFragment != null && topFragment.tag != null) {
            // This means at least there is one fragment except fragments which are managed manually by tab.
            super.onClickedBackSystemButton()
            return
        }

        if (currentTabIndex < 0 || currentTabIndex >= fragmentsListArray.size) {
            super.onClickedBackSystemButton()
            return
        }

        if (FRAGMENT_LOG_MANAGEMENT) {
            if (fragmentsLogArray.size == 1) {
                super.onClickedBackSystemButton()
            } else {
                val lastLog = fragmentsLogArray[fragmentsLogArray.size - 1]
                val prevLog = fragmentsLogArray[fragmentsLogArray.size - 2]

                if (prevLog.tabIndex == lastLog.tabIndex) {
                    popFragment()
                } else {
                    selectTab(prevLog.tabIndex, false)
                }

                fragmentsLogArray.removeAt(fragmentsLogArray.size - 1)
            }
        } else {
            val fragmentsForCurrentTab = fragmentsListArray[currentTabIndex]
            if (fragmentsForCurrentTab.size < 2) {
                super.onClickedBackSystemButton()
            } else {
                popFragment()
            }
        }
    }


    /**
     * Called when a tab has been selected on activity
     */
    protected open fun selectTab(index: Int, addToFragmentLog: Boolean) {
        if (currentTabIndex == index)
            return

        dismissProgressDialog()
        currentTabIndex = index

        val fragmentsForCurrentTab = fragmentsListArray[currentTabIndex]
        if (fragmentsForCurrentTab.size == 0)
            return

        val topFragment = fragmentsForCurrentTab[fragmentsForCurrentTab.size - 1]
        showFragment(topFragment, ANIM_DIRECTION_FROM_NONE)

        if (addToFragmentLog && FRAGMENT_LOG_MANAGEMENT) {
            fragmentsLogArray.add(STFragmentLog(currentTabIndex, fragmentsForCurrentTab.size - 1))
        }

        if (tabChangedListener != null)
            tabChangedListener!!.onTabChanged(currentTabIndex)
    }


    protected fun showFragment(newFragment: SuperFragment, anim_dir: Int) {
        val transaction = supportFragmentManager.beginTransaction()

        if (anim_dir == ANIM_DIRECTION_FROM_RIGHT)
            transaction.setCustomAnimations(R.anim.right_in, R.anim.left_out)
        else if (anim_dir == ANIM_DIRECTION_FROM_LEFT)
            transaction.setCustomAnimations(R.anim.left_in, R.anim.right_out)
        else if (anim_dir == ANIM_DIRECTION_FROM_TOP)
            transaction.setCustomAnimations(R.anim.top_in, R.anim.bottom_out)
        else if (anim_dir == ANIM_DIRECTION_FROM_BOTTOM)
            transaction.setCustomAnimations(R.anim.bottom_in, R.anim.top_out)

        for (i in fragmentsListArray.indices) {
            val fragments = fragmentsListArray[i]
            for (j in fragments.indices) {
                val fragmentItem = fragments[j]
                if (fragmentItem !== newFragment && fragmentItem.isAdded) {
                    transaction.hide(fragmentItem)
                }
            }
        }

        if (!newFragment.isAdded) {
            val topFragment = topFragment
            if (topFragment != null && topFragment is SuperFragment && topFragment.isApplyToChilds) {
                newFragment.showTabBar(topFragment.isShowTabBar)
            }

            transaction.add(containerViewId, newFragment)
        }

        transaction.show(newFragment)
        if (tabBar != null) {
            setTabbarVisibility(newFragment.isShowTabBar)
        }

        try {
            transaction.commit()
        } catch (ex: Exception) {
            ex.printStackTrace()
        }

    }


    private fun setTabbarVisibility(visibility: Boolean) {
        val task = object : TimerTask() {
            override fun run() {
                runOnUiThread {
                    if (visibility) {
                        tabBar!!.visibility = View.VISIBLE
                        if (tabBarShadow != null)
                            tabBarShadow!!.visibility = View.VISIBLE
                    } else {
                        tabBar!!.visibility = View.GONE
                        if (tabBarShadow != null)
                            tabBarShadow!!.visibility = View.GONE
                    }
                }
            }
        }
        val timer = Timer()
        timer.schedule(task, 150)
    }


    protected open fun initializeTabContents(fragmentsListArray: ArrayList<ArrayList<SuperFragment>>, initialTabIndex: Int) {
        this.fragmentsListArray = fragmentsListArray

        currentTabIndex = initialTabIndex

        val fragmentsForCurrentTab = fragmentsListArray[currentTabIndex]
        if (fragmentsForCurrentTab.size == 0)
            return

        val topFragment = fragmentsForCurrentTab[fragmentsForCurrentTab.size - 1]
        showFragment(topFragment, ANIM_DIRECTION_FROM_NONE)

        if (FRAGMENT_LOG_MANAGEMENT) {
            fragmentsLogArray.add(STFragmentLog(currentTabIndex, 0))
        }
    }


    inner class STFragmentLog(tabIndex: Int, fragmentIndex: Int) {
        var tabIndex = 0
        var fragmentIndex = 0

        init {
            this.tabIndex = tabIndex
            this.fragmentIndex = fragmentIndex
        }
    }

    interface OnTabChangedListener {
        fun onTabChanged(index: Int)
    }

    companion object {
        val EXTRA_INITIAL_FRAGMENT_INDEX = "extra_initial_fragment_index"
    }

}
/**
 * new fragment to fragment container
 *
 * @param newFragment New fragment to be pushed
 */

