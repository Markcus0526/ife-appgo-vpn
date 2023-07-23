package com.appgo.appgopro.views

import android.graphics.Color
import android.os.Bundle
import android.support.v4.app.Fragment
import android.support.v4.app.FragmentManager
import android.support.v4.app.FragmentStatePagerAdapter
import android.support.v4.view.PagerAdapter
import android.support.v4.view.ViewPager
import android.view.View
import android.view.ViewGroup
import android.view.WindowManager
import android.widget.ImageView
import android.widget.LinearLayout
import com.appgo.appgopro.R
import com.appgo.appgopro.supers.SuperTabActivity
import com.appgo.appgopro.utils.UIManager

class TourActivity : SuperTabActivity() {

    var viewPager: ViewPager? = null
    var pagerAdapter: PagerAdapter? = null
    var circles: LinearLayout? = null
    var isOpaque = true

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        val window = getWindow()
        window.setFlags(WindowManager.LayoutParams.FLAG_TRANSLUCENT_STATUS, WindowManager.LayoutParams.FLAG_TRANSLUCENT_STATUS)

        setContentView(R.layout.activity_tutorial)

        viewPager = findViewById(R.id.pager)
        pagerAdapter = ScreenSlidePagerAdapter(supportFragmentManager)

        viewPager!!.adapter = pagerAdapter
        viewPager!!.setPageTransformer(true, CrossfadePageTransformer())

        viewPager!!.addOnPageChangeListener(object : ViewPager.OnPageChangeListener {
            override fun onPageSelected(position: Int) {
                setIndicator(position)
                if (position == NUM_PAGES - 1) {

                }
            }

            override fun onPageScrolled(position: Int, positionOffset: Float, positionOffsetPixels: Int) {
                if ((position == NUM_PAGES - 2) && positionOffset > 0) if (isOpaque) {
                    viewPager!!.setBackgroundColor(Color.TRANSPARENT)
                    isOpaque = false
                }
                else if (!isOpaque) {
                    viewPager!!.setBackgroundColor(resources.getColor(R.color.primary_material_light))
                    isOpaque = true
                }
            }

            override fun onPageScrollStateChanged(state: Int) {

            }
        })

        buildCircles()
    }

    fun endTutorial() {
        pushNewActivityAnimated(LoginActivity::class.java)
        popOverCurActivityAnimated()
    }

    override fun onDestroy() {
        super.onDestroy()
        if (viewPager != null)
            viewPager!!.clearOnPageChangeListeners()
    }


    private fun buildCircles() {
        circles = findViewById(R.id.circles)
        val scale = resources.displayMetrics.density
        val padding = (5 * scale + 0.5f).toInt()
        var i = 0
        while (i <= NUM_PAGES - 1) {
            val circle = ImageView(this)
            circle.setImageResource(R.drawable.ic_tour_circle)
            circle.layoutParams = ViewGroup.LayoutParams(ViewGroup.LayoutParams.WRAP_CONTENT, ViewGroup.LayoutParams.WRAP_CONTENT)
            circle.setAdjustViewBounds(true)
            circle.setPadding(padding, 0, padding, 0)
            circles!!.addView(circle)
            i += 1
        }
        setIndicator(0)
    }

    private fun setIndicator(index: Int) {
        if (index < NUM_PAGES - 1) {
            var i = 0
            while (i <= NUM_PAGES - 1) {
                val circle = circles!!.getChildAt(i) as ImageView
                circle.setVisibility(View.VISIBLE)

                if (i == index) circle.setColorFilter(UIManager.sharedInstance().getColor(R.color.colorMain))
                else circle.setColorFilter(UIManager.sharedInstance().getColor(R.color.colorGrayText))
                i += 1
            }
        } else if (index == NUM_PAGES - 1) {
            var i = 0
            while (i <= NUM_PAGES - 1) {
                val circle = circles!!.getChildAt(i) as ImageView
                circle.setVisibility(View.GONE)
                i += 1
            }
        }
    }


    private class ScreenSlidePagerAdapter(fm: FragmentManager): FragmentStatePagerAdapter(fm) {

        override fun getItem(position: Int): Fragment {
            var tp = TourFragment()

            when (position) {
                0 -> {
                    tp = TourFragment.sharedInstance().newInstance(R.layout.fragment_welcome1)!!
                }
                1 -> {
                    tp = TourFragment.sharedInstance().newInstance(R.layout.fragment_welcome2)!!
                }
                2 -> {
                    tp = TourFragment.sharedInstance().newInstance(R.layout.fragment_welcome3)!!
                }
            }

            return tp
        }

        override fun getCount(): Int {
            return NUM_PAGES
        }
    }

    class CrossfadePageTransformer: ViewPager.PageTransformer {
        override fun transformPage(page: View, position: Float) {
            val pageWidth = page.width
        }
    }

    companion object {
        const val NUM_PAGES = 3
    }
}
