package com.appgo.appgopro.utils

import android.app.ProgressDialog
import android.content.Context
import android.graphics.drawable.Drawable
import android.os.Build
import android.view.Gravity
import android.view.View
import android.widget.Toast
import com.appgo.appgopro.AppGoApplication.Companion.app
import java.io.IOException

/**
 * Created by KSMA on 4/19/2017.
 */

class UIManager private constructor(context: Context) {

    private val TAG = "UIManager"
    protected var contextInstance: Context? = null

    init {
        contextInstance = context
    }

    fun dismissProgressDialog(dlg: Any?) {
        if (dlg == null || dlg !is ProgressDialog)
            return

        val progressDialog = dlg as ProgressDialog?
        if (progressDialog!!.isShowing)
            progressDialog.dismiss()
    }


    fun showToastMessage(context: Context?, message: String) {
        if (gToast == null || gToast!!.view.windowVisibility != View.VISIBLE) {
            gToast = Toast.makeText(context ?: contextInstance, message, Toast.LENGTH_LONG)
            gToast!!.setGravity(Gravity.CENTER, 0, 0)
            gToast!!.show()
        }
    }


    fun loadAssetDrawableFromResourceName(assetPath: String?): Drawable? {
        if (assetPath == null || assetPath.length == 0) {
            if (assetPath == null)
                AGLogger.log(TAG, "assetPath is null")
            else
                AGLogger.log(TAG, "assetPath is empty")

            return null
        }


        var drawable: Drawable? = null

        try {
            val assetPathWebP: String
            if (assetPath.length <= 5) {
                AGLogger.log(TAG, "assetPath is shorter than 5 chars : " + assetPath)
                assetPathWebP = assetPath + ".webp"
            } else {
                if (assetPath.toLowerCase().endsWith(".webp")) {
                    AGLogger.log(TAG, "assetPath ends with .webp : " + assetPath)
                    assetPathWebP = assetPath
                } else if (assetPath.toLowerCase().endsWith(".jpg") || assetPath.toLowerCase().endsWith(".png")) {
                    AGLogger.log(TAG, "assetPath ends with .jpg or .png : " + assetPath)
                    assetPathWebP = assetPath.substring(0, assetPath.length - 4) + ".webp"
                } else {
                    assetPathWebP = assetPath + ".webp"
                }
            }

            val inputStream = AGUtils.sharedInstance().applicationContext.assets.open(assetPathWebP)
            drawable = Drawable.createFromStream(inputStream, null)
        } catch (webpEx: IOException) {
            AGLogger.log(TAG, (if (webpEx.message == null) "No asset file" else webpEx.message)!!)

            try {
                val assetPathPNG: String
                if (assetPath.length <= 4) {
                    AGLogger.log(TAG, "assetPath is shorter than 4 chars : " + assetPath)
                    assetPathPNG = assetPath + ".png"
                } else {
                    if (assetPath.toLowerCase().endsWith(".png")) {
                        AGLogger.log(TAG, "assetPath ends with .png : " + assetPath)
                        assetPathPNG = assetPath
                    } else if (assetPath.toLowerCase().endsWith(".jpg")) {
                        AGLogger.log(TAG, "assetPath ends with .jpg : " + assetPath)
                        assetPathPNG = assetPath.substring(0, assetPath.length - 4) + ".png"
                    } else if (assetPath.toLowerCase().endsWith(".webp")) {
                        AGLogger.log(TAG, "assetPath ends with .webp : " + assetPath)
                        assetPathPNG = assetPath.substring(0, assetPath.length - 5) + ".png"
                    } else {
                        assetPathPNG = assetPath + ".png"
                    }
                }

                val inputStream = AGUtils.sharedInstance().applicationContext.assets.open(assetPathPNG)
                drawable = Drawable.createFromStream(inputStream, null)
            } catch (pngEx: IOException) {
                // No asset for PNG. Try JPG asset
                AGLogger.log(TAG, (if (pngEx.message == null) "No asset file" else pngEx.message)!!)

                try {
                    val assetPathJPG: String
                    if (assetPath.length <= 4) {
                        AGLogger.log(TAG, "assetPath is shorter than 4 chars : " + assetPath)
                        assetPathJPG = assetPath + ".jpg"
                    } else {
                        if (assetPath.toLowerCase().endsWith(".jpg")) {
                            AGLogger.log(TAG, "assetPath ends with .jpg : " + assetPath)
                            assetPathJPG = assetPath
                        } else if (assetPath.toLowerCase().endsWith(".png")) {
                            AGLogger.log(TAG, "assetPath ends with .png : " + assetPath)
                            assetPathJPG = assetPath.substring(0, assetPath.length - 4) + ".jpg"
                        } else if (assetPath.toLowerCase().endsWith(".webp")) {
                            AGLogger.log(TAG, "assetPath ends with .webp : " + assetPath)
                            assetPathJPG = assetPath.substring(0, assetPath.length - 5) + ".jpg"
                        } else {
                            assetPathJPG = assetPath + ".jpg"
                        }
                    }

                    AGLogger.log(TAG, "assetPath for JPG : " + assetPathJPG)

                    val inputStream = AGUtils.sharedInstance().applicationContext.assets.open(assetPathJPG)
                    drawable = Drawable.createFromStream(inputStream, null)
                } catch (jpgEx: IOException) {
                    AGLogger.log(TAG, (if (jpgEx.message == null) "No asset file" else jpgEx.message)!!)
                }

            }

        }

        return drawable
    }


    fun getDrawableResourceNameWithScreenDensitySuffix(missionId: Long, resourceName: String?): String? {
        if (resourceName == null)
            return null

        return if (missionId != 15L) {
            resourceName + "_" + ResolutionSet.getScreenDensityString(contextInstance!!)
        } else {
            resourceName + "_" + ResolutionSet.RESOLUTION_XXXHDPI
        }
    }


    fun setBackgroundDrawable(view: View, drawable: Drawable) {
        val sdk = Build.VERSION.SDK_INT
        if (sdk < Build.VERSION_CODES.JELLY_BEAN) {
            view.setBackgroundDrawable(drawable)
        } else {
            view.background = drawable
        }
    }

    fun getImageDrawable(resId: Int): Drawable {
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            contextInstance!!.resources.getDrawable(resId, contextInstance!!.theme)
        } else {
            contextInstance!!.resources.getDrawable(resId)
        }
    }

    fun getColor(resId: Int): Int {
        return if (Build.VERSION.SDK_INT < 23) {
            contextInstance!!.resources.getColor(resId)
        } else {
            contextInstance!!.getColor(resId)
        }
    }

    fun getDrawable(resId: Int): Drawable {
        return if (Build.VERSION.SDK_INT < 21) {
            contextInstance!!.resources.getDrawable(resId)
        } else {
            contextInstance!!.resources.getDrawable(resId, null)
        }
    }

    companion object {

        private var sharedInstance: UIManager? = null
        var gToast: Toast? = null


        fun initialize(context: Context): UIManager {
            if (sharedInstance == null)
                sharedInstance = UIManager(context)
            return sharedInstance as UIManager
        }


        fun sharedInstance(): UIManager {
            if (sharedInstance == null)
                sharedInstance = UIManager(app.applicationContext)
            return sharedInstance as UIManager
        }
    }

}
