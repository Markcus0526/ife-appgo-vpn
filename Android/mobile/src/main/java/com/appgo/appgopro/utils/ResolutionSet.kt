package com.appgo.appgopro.utils

import android.content.Context
import android.content.res.Configuration
import android.graphics.Point
import android.util.DisplayMetrics
import android.util.TypedValue
import android.view.Display
import android.view.View
import android.view.ViewGroup
import android.view.WindowManager
import android.widget.TextView

import java.lang.reflect.InvocationTargetException
import java.lang.reflect.Method

/**
 * Created by KSMA on 4/19/2017.
 */

class ResolutionSet {

    fun setResolution(x: Int, y: Int, isPortrate: Boolean) {
        if (isPortrate)
            fXpro = x.toFloat() / nDesignWidth
        else
            fXpro = x.toFloat() / nDesignHeight
        if (isPortrate)
            fYpro = y.toFloat() / nDesignHeight
        else
            fYpro = y.toFloat() / nDesignWidth
        fPro = Math.min(fXpro, fYpro)
    }


    // Update layouts in the view recursively.
    fun iterateChild(view: View) {
        if (view is ViewGroup) {
            val nCount = view.childCount
            for (i in 0 until nCount) {
                iterateChild(view.getChildAt(i))
            }
        }
        UpdateLayout(view)
    }

    internal fun UpdateLayout(view: View) {
        val lp: ViewGroup.LayoutParams?
        lp = view.layoutParams as ViewGroup.LayoutParams
        if (lp == null)
            return
        if (lp.width > 0)
            lp.width = (lp.width * fXpro + 0.50001).toInt()
        if (lp.height > 0)
            lp.height = (lp.height * fYpro + 0.50001).toInt()

        //Padding.....
        val leftPadding = (fXpro * view.paddingLeft).toInt()
        val rightPadding = (fXpro * view.paddingRight).toInt()
        val bottomPadding = (fYpro * view.paddingBottom).toInt()
        val topPadding = (fYpro * view.paddingTop).toInt()

        view.setPadding(leftPadding, topPadding, rightPadding, bottomPadding)

        if (lp is ViewGroup.MarginLayoutParams) {
            val mlp = lp as ViewGroup.MarginLayoutParams?

            //if(mlp.leftMargin > 0)
            mlp!!.leftMargin = (mlp.leftMargin * fXpro + 0.50001).toInt()
            //if(mlp.rightMargin > 0)
            mlp.rightMargin = (mlp.rightMargin * fXpro + 0.50001).toInt()
            //if(mlp.topMargin > 0)
            mlp.topMargin = (mlp.topMargin * fYpro + 0.50001).toInt()
            //if(mlp.bottomMargin > 0)
            mlp.bottomMargin = (mlp.bottomMargin * fYpro + 0.50001).toInt()
        }

        if (view is TextView) {
//float txtSize = (float) (Math.sqrt((fXpro+fYpro)/2) * lblView.getTextSize());
            //float txtSize = (float) ((fXpro+fYpro)/2) * lblView.getTextSize();
            val txtSize = (fPro * view.textSize).toFloat()
            view.setTextSize(TypedValue.COMPLEX_UNIT_PX, txtSize)
        }
    }

    companion object {

        //DPI Strings
        val RESOLUTION_LDPI = "ldpi"
        val RESOLUTION_MDPI = "mdpi"
        val RESOLUTION_HDPI = "hdpi"
        val RESOLUTION_XHDPI = "xhdpi"
        val RESOLUTION_XXHDPI = "xxhdpi"
        val RESOLUTION_XXXHDPI = "xxxhdpi"

        //DPI Values
        val SCREEN_DENSITY_LDPI = 0.75f
        val SCREEN_DENSITY_MDPI = 1.0f
        val SCREEN_DENSITY_HDPI = 1.5f
        val SCREEN_DENSITY_XHDPI = 2.0f
        val SCREEN_DENSITY_XXHDPI = 3.0f
        val SCREEN_DENSITY_XXXHDPI = 4.0f

        var fXpro = 1f
        var fYpro = 1f
        var fPro = 1f
        var nDesignWidth = 1200
        var nDesignHeight = 1774

        private var _instance: ResolutionSet? = null


        fun getScreenSize(context: Context, isContainNavBar: Boolean): Point {
            val isPortrait = context.resources.configuration.orientation == Configuration.ORIENTATION_PORTRAIT
            var width = 0
            var height = 0
            val metrics = DisplayMetrics()
            val windowManager = context.getSystemService(Context.WINDOW_SERVICE) as WindowManager
            val display = windowManager.defaultDisplay
            val mGetRawH: Method
            val mGetRawW: Method

            if (!isContainNavBar) {
                val nWidth = display.width
                val nHeight = display.height
                return if (!isPortrait) {
                    if (nWidth > nHeight)
                        Point(nWidth, nHeight)
                    else
                        Point(nHeight, nWidth)
                } else {
                    if (nWidth > nHeight)
                        Point(nHeight, nWidth)
                    else
                        Point(nWidth, nHeight)
                }
            }

            try {
                // For JellyBean 4.2 (API 17) and onward
                /*if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.JELLY_BEAN_MR1) {
                display.getRealMetrics(metrics);

                width = metrics.widthPixels;
                height = metrics.heightPixels;
            } else { */
                mGetRawH = Display::class.java.getMethod("getRawHeight")
                mGetRawW = Display::class.java.getMethod("getRawWidth")

                try {
                    width = mGetRawW.invoke(display) as Int
                    height = mGetRawH.invoke(display) as Int
                } catch (e: IllegalArgumentException) {
                    e.printStackTrace()
                } catch (e: IllegalAccessException) {
                    e.printStackTrace()
                } catch (e: InvocationTargetException) {
                    e.printStackTrace()
                }

                //}
            } catch (e3: NoSuchMethodException) {
                e3.printStackTrace()
            }

            if (width != 0 || height != 0) {
                return if (!isPortrait) {
                    if (width > height)
                        Point(width, height)
                    else
                        Point(height, width)
                } else {
                    if (width > height)
                        Point(height, width)
                    else
                        Point(width, height)
                }
            } else {
                val winManager = context.getSystemService(Context.WINDOW_SERVICE) as WindowManager
                windowManager.defaultDisplay.getMetrics(metrics)
                val nWidth = metrics.widthPixels
                val nHeight = metrics.heightPixels
                return if (!isPortrait) {
                    if (nWidth > nHeight)
                        Point(nWidth, nHeight)
                    else
                        Point(nHeight, nWidth)
                } else {
                    if (nWidth > nHeight)
                        Point(nHeight, nWidth)
                    else
                        Point(nWidth, nHeight)
                }
            }
        }

        fun getStatusBarHeight(context: Context): Int {
            var result = 0
            val resourceId = context.resources.getIdentifier("status_bar_height", "dimen", "android")
            if (resourceId > 0) {
                result = context.resources.getDimensionPixelSize(resourceId)
            }
            return result
        }

        fun getScreenDensityString(context: Context): String {
            val dpi = context.resources.displayMetrics.density
            if (SCREEN_DENSITY_LDPI == dpi) {
                return RESOLUTION_MDPI
            } else if (SCREEN_DENSITY_MDPI == dpi) {
                return RESOLUTION_MDPI
            } else if (SCREEN_DENSITY_HDPI == dpi) {
                return RESOLUTION_HDPI
            } else if (SCREEN_DENSITY_XHDPI == dpi) {
                return RESOLUTION_XHDPI
            } else if (SCREEN_DENSITY_XXHDPI == dpi) {
                return RESOLUTION_XXHDPI
            } else if (SCREEN_DENSITY_XXXHDPI == dpi) {
                return RESOLUTION_XXXHDPI
            }

            return RESOLUTION_HDPI
        }

        fun getDPSize(context: Context, nDimensionId: Int): Float {
            val dpi = context.resources.displayMetrics.density
            return context.resources.getDimension(nDimensionId) / dpi
        }

        fun getPixelFromDP(context: Context, dpSize: Int): Int {
            val dpi = context.resources.displayMetrics.density
            return (dpSize.toFloat() * dpi).toInt()
        }

        fun sharedInstance(): ResolutionSet {
            if (_instance == null)
                _instance = ResolutionSet()
            return _instance as ResolutionSet
        }
    }

}
