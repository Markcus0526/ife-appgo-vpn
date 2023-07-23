package com.appgo.appgopro.utils

import android.content.Context
import android.content.pm.PackageManager
import android.graphics.drawable.Drawable
import android.os.Build
import android.provider.SyncStateContract
import android.util.Base64
import android.view.View
import android.view.ViewGroup
import android.view.inputmethod.InputMethodManager
import android.widget.EditText
import com.appgo.appgopro.AppGoApplication.Companion.app
import com.appgo.appgopro.R
import java.io.IOException
import java.io.UnsupportedEncodingException
import java.net.*
import java.security.InvalidAlgorithmParameterException
import java.security.InvalidKeyException
import java.security.MessageDigest
import java.security.NoSuchAlgorithmException
import java.security.spec.InvalidKeySpecException
import java.security.spec.InvalidParameterSpecException
import java.util.*
import javax.crypto.*
import javax.crypto.spec.IvParameterSpec
import javax.crypto.spec.SecretKeySpec


/**
 * Created by KSMA on 4/19/2017.
 */

class AGUtils private constructor(protected var context: Context) {

    val applicationContext: Context
        get() = this.context.applicationContext

    fun hideKeyboardInView(view: View?) {
        if (view == null)
            return

        if (view is EditText) {
            view.clearFocus()
            val imm = this.context.getSystemService(Context.INPUT_METHOD_SERVICE) as InputMethodManager
            imm.hideSoftInputFromWindow(view.windowToken, 0)
        } else if (view is ViewGroup) {
            val childCount = view.childCount
            for (i in 0 until childCount) {
                val childView = view.getChildAt(i)
                hideKeyboardInView(childView)
            }
        }
    }

    fun getFlagDrawable(imagePath: String): Drawable {
        var drawable = UIManager.sharedInstance().loadAssetDrawableFromResourceName("flags/" + imagePath)
        if (drawable == null) {
            drawable = UIManager.sharedInstance().getImageDrawable(R.drawable.ic_flag_user)
        }

        return drawable
    }

    fun humanReadableByteCount(bytes: Long, needFloat: Boolean): String {
        val unit = 1024
        if (bytes < unit) return bytes.toString() + " B"
        var exp = (Math.log(bytes.toDouble()) / Math.log(unit.toDouble())).toInt()
        if (exp > 3) exp = 3
        val pre = "KMGTPE"[exp - 1] + ""

        return if (!needFloat) {
            String.format("%d %sB", (bytes / Math.pow(unit.toDouble(), exp.toDouble())).toInt(), pre)
        } else {
            String.format("%.2f %sB", bytes / Math.pow(unit.toDouble(), exp.toDouble()), pre)
        }
    }

    fun isHostReachable(serverAddress: String, serverTCPport: Int, timeoutMS: Int): Boolean {
        var connected = false
        var socket: Socket? = Socket()
        try {
            val socketAddress = InetSocketAddress(serverAddress, serverTCPport)
            socket?.connect(socketAddress, timeoutMS)
            if (socket?.isConnected!!) {
                connected = true
                socket.close()
            }
        } catch (e: IOException) {
            e.printStackTrace()
        } finally {
            socket = null
        }

        return connected
    }

    fun isUrlReachable(url: String, timeout: Int): Boolean {
        try {
            val myUrl = URL(url)
            val connection = myUrl.openConnection() as HttpURLConnection
            connection.setConnectTimeout(timeout)
            connection.setConnectTimeout(timeout)
            connection.setReadTimeout(timeout)
            connection.setInstanceFollowRedirects(true)
            connection.setUseCaches(false)
            connection.connect()
            AGLogger.log(AGUtils.TAG, "isUrlReachable reture code" + connection.responseCode)
            if (connection.responseCode >= 200 && connection.responseCode < 400)
                return true
            else
                return false
        } catch (e: Exception) {
            // Handle your exceptions
            return false
        }
    }


    companion object {
        val TAG = AGUtils::class.java.name

        private var instance: AGUtils? = null

        fun initialize(context: Context): AGUtils {
            if (instance == null)
                instance = AGUtils(context)
            return instance as AGUtils
        }

        fun sharedInstance(): AGUtils {
            if (instance == null)
                instance = AGUtils(app.applicationContext)
            return instance as AGUtils
        }

        val isLollipopOrAbove: Boolean
            get() = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP)
                true
            else
                false

        fun getSignature(context: Context): String {
            try {
                val info = context
                        .packageManager
                        .getPackageInfo(context.packageName, PackageManager.GET_SIGNATURES)

                val mdg = MessageDigest.getInstance("SHA-1")
                mdg.update(info.signatures[0].toByteArray())
                return String(Base64.encode(mdg.digest(), 0))
            } catch (e: Exception) {
            }

            return ""
        }

        private fun resolve(host: String): String? {
            try {
                return InetAddress.getByName(host).hostAddress
            } catch (e: Exception) {
                return null
            }

        }

        fun isNumeric(address: String): Boolean {
            try {
                //if (InetAddress.isNumeric(address))
                return true
                //else
                //	return false;
            } catch (e: Exception) {
                return false
            }

        }
    }
}
