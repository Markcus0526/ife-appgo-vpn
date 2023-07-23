package com.appgo.appgopro.models

import android.content.Context
import android.util.Base64
import com.appgo.appgopro.AppGoApplication.Companion.app
import com.appgo.appgopro.database.DataStore
import com.appgo.appgopro.database.ProfileManager
import com.appgo.appgopro.utils.AGConstants
import com.appgo.appgopro.utils.AGConstants.PREFERENCE_KEY
import com.appgo.appgopro.utils.AGConstants.PREF_ACCESS_TOKEN
import com.appgo.appgopro.utils.AGConstants.PREF_AUTH_PASSWORD
import com.appgo.appgopro.utils.AGConstants.PREF_AUTH_USERNAME
import com.appgo.appgopro.utils.AGConstants.PREF_AVAILABLE_USER_SERVICES
import com.appgo.appgopro.utils.AGConstants.PREF_CONNECTED_USER_SERVICE
import com.appgo.appgopro.utils.AGConstants.PREF_DEFAULT_LANGUAGE
import com.appgo.appgopro.utils.AGConstants.PREF_EXPIRE_IN
import com.appgo.appgopro.utils.AGConstants.PREF_REFRESH_TOKEN
import com.appgo.appgopro.utils.AGConstants.PREF_TOKEN_TYPE
import com.appgo.appgopro.utils.AGUtils
import com.google.gson.Gson
import com.google.gson.reflect.TypeToken
import java.util.*
import javax.crypto.Cipher
import javax.crypto.spec.IvParameterSpec
import javax.crypto.spec.SecretKeySpec

/**
 * Created by KSMA on 4/19/2017.
 */

fun String.encryptAES(): String {
    if (this.length == 0) return ""
    //return this

    val tokenBytes = AGConstants.CRYPT_KEY.toByteArray(Charsets.UTF_8)
    val secretKey = SecretKeySpec(tokenBytes, "AES")

    val ivByteArray = ByteArray(16)
    val iv = IvParameterSpec(ivByteArray)

    val cipher = Cipher.getInstance("AES/CBC/PKCS5Padding")
    cipher.init(Cipher.ENCRYPT_MODE, secretKey, iv)

    val cipherText = cipher.doFinal(toByteArray(Charsets.UTF_8))
    val ivAndCipherText = getCombinedArray(ivByteArray, cipherText)

    return Base64.encodeToString(ivAndCipherText, Base64.NO_WRAP)
}

fun String.decryptAES(): String {
    if (this.length == 0) return ""
    //return this

    val tokenBytes = AGConstants.CRYPT_KEY.toByteArray(Charsets.UTF_8)
    val secretKey = SecretKeySpec(tokenBytes, "AES")

    val ivAndCipherText = Base64.decode(this, Base64.NO_WRAP)
    val cipherText = Arrays.copyOfRange(ivAndCipherText, 16, ivAndCipherText.size)

    val ivByteArray = Arrays.copyOfRange(ivAndCipherText, 0, 16)
    val iv = IvParameterSpec(ivByteArray)

    val cipher = Cipher.getInstance("AES/CBC/PKCS5Padding")
    cipher.init(Cipher.DECRYPT_MODE, secretKey, iv)

    return cipher.doFinal(cipherText).toString(Charsets.UTF_8)
}

private fun getCombinedArray(one: ByteArray, two: ByteArray): ByteArray {
    val combined = ByteArray(one.size + two.size)
    for (i in combined.indices) {
        combined[i] = if (i < one.size) one[i] else two[i - one.size]
    }
    return combined
}

class Preference {

    val isLogined: Boolean
        get() {
            val sharedPreferences = app.applicationContext
                    .getSharedPreferences(PREFERENCE_KEY, Context.MODE_PRIVATE)
            val username = sharedPreferences.getString(PREF_AUTH_USERNAME, "")
            val password = sharedPreferences.getString(PREF_AUTH_PASSWORD, "")
            val usertoken = sharedPreferences.getString(PREF_ACCESS_TOKEN, "")

            return if (username!!.isEmpty() || password!!.isEmpty() || usertoken!!.isEmpty())
                false
            else
                true
        }

    fun saveLoginData(username: String, password: String, result: AGLogin?) {
        val sharedPreferences = app.applicationContext
                .getSharedPreferences(PREFERENCE_KEY, Context.MODE_PRIVATE)
        val editor = sharedPreferences.edit()

        editor.putString(PREF_AUTH_USERNAME, username.encryptAES())
        editor.putString(PREF_AUTH_PASSWORD, password.encryptAES())

        if (result != null) {
            editor.putString(PREF_ACCESS_TOKEN, result.accessToken)
            editor.putInt(PREF_EXPIRE_IN, result.expiresIn)
            editor.putString(PREF_REFRESH_TOKEN, result.refreshToken)
            editor.putString(PREF_TOKEN_TYPE, result.tokenType)
        } else {
            editor.putString(PREF_ACCESS_TOKEN, "")
            editor.putInt(PREF_EXPIRE_IN, 0)
            editor.putString(PREF_REFRESH_TOKEN, "")
            editor.putString(PREF_TOKEN_TYPE, "")
        }

        editor.apply()
    }

    fun clearLoginData() {
        saveLoginData("", "", null)
    }

    fun loadUserName(): String {
        val sharedPreferences = app.applicationContext
                .getSharedPreferences(PREFERENCE_KEY, Context.MODE_PRIVATE)
        return sharedPreferences.getString(PREF_AUTH_USERNAME, "").decryptAES()
    }

    fun loadPassword(): String {
        val sharedPreferences = app.applicationContext
                .getSharedPreferences(PREFERENCE_KEY, Context.MODE_PRIVATE)
        return sharedPreferences.getString(PREF_AUTH_PASSWORD, "").decryptAES()
    }

    fun loadUserToken(): String {
        val sharedPreferences = app.applicationContext
                .getSharedPreferences(PREFERENCE_KEY, Context.MODE_PRIVATE)
        return sharedPreferences.getString(PREF_ACCESS_TOKEN, "")
    }

    fun saveUserToken(userToken: String) {
        val sharedPreferences = app.applicationContext
                .getSharedPreferences(PREFERENCE_KEY, Context.MODE_PRIVATE)
        val editor = sharedPreferences.edit()

        editor.putString(PREF_ACCESS_TOKEN, userToken)
        editor.apply()
    }

    fun saveDefaultLanguage(language: String) {
        val sharedPreferences = app.applicationContext
                .getSharedPreferences(PREFERENCE_KEY, Context.MODE_PRIVATE)
        val editor = sharedPreferences.edit()

        editor.putString(PREF_DEFAULT_LANGUAGE, language)
        editor.apply()
    }

    fun loadDefaultLanguage(): String {
        val sharedPreferences = app.applicationContext
                .getSharedPreferences(PREFERENCE_KEY, Context.MODE_PRIVATE)
        return sharedPreferences.getString(PREF_DEFAULT_LANGUAGE, "")
    }

    fun saveCurrentProfile(profile: AGProfile?) {
        val sharedPreferences = app.applicationContext
                .getSharedPreferences(PREFERENCE_KEY, Context.MODE_PRIVATE)
        val editor = sharedPreferences.edit()

        val gson = Gson()
        val json = gson.toJson(profile)
        editor.putString(PREF_CONNECTED_USER_SERVICE, json.encryptAES())
        editor.apply()

        if (profile == null) {
            val profiles = ProfileManager.getAllProfiles()
            if (profiles != null) {
                profiles.forEach {
                    ProfileManager.delProfile(it.id)
                }
            }
            return
        }

        val lang = Preference.sharedInstance().loadDefaultLanguage()
        var profileName = ""
        if (lang.equals("CN"))
            profileName = profile!!.country!!.aliasZh!!
        else
            profileName = profile!!.country!!.aliasEn!!
        ProfileManager.createProfile(profile, profileName)
        DataStore.profileId = 1
    }

    fun loadCurrentProfile(): AGProfile? {
        val sharedPreferences = app.applicationContext
                .getSharedPreferences(PREFERENCE_KEY, Context.MODE_PRIVATE)

        val gson = Gson()
        val json = sharedPreferences.getString(PREF_CONNECTED_USER_SERVICE, "").decryptAES()

        try {
            //return gson.fromJson(json, AGProfile::class.java)
            //val profile = gson.fromJson(json, AGProfile::class.java)
            //AGLogger.log(TAG, "loadCurrentProfile : " + profile!!.name())
            //AGLogger.log(TAG, "loadCurrentProfile : " + profile!!.route)

            return gson.fromJson(json, AGProfile::class.java)
        } catch (e: Exception) {
            return null
        }
    }

    fun saveAvailableProfiles(services: List<AGProfile>) {
        val sharedPreferences = app.applicationContext
                .getSharedPreferences(PREFERENCE_KEY, Context.MODE_PRIVATE)
        val editor = sharedPreferences.edit()

        val gson = Gson()
        val json = gson.toJson(services)
        editor.putString(PREF_AVAILABLE_USER_SERVICES, json.encryptAES())
        editor.apply()
    }

    fun loadAvailableProfiles(): List<AGProfile>? {
        val sharedPreferences = app.applicationContext
                .getSharedPreferences(AGConstants.PREFERENCE_KEY, Context.MODE_PRIVATE)
        val gson = Gson()
        val json = sharedPreferences.getString(AGConstants.PREF_AVAILABLE_USER_SERVICES, "").decryptAES()

        val listType = object: TypeToken<List<AGProfile>>() {}.type
        try {
            return gson.fromJson(json, listType)
        } catch (e: Exception) {
            return null
        }
    }

    fun saveNationalRuleSetTime(time: String) {
        val sharedPreferences = app.applicationContext
                .getSharedPreferences(AGConstants.PREFERENCE_KEY, Context.MODE_PRIVATE)
        val editor = sharedPreferences.edit()
        editor.putString(AGConstants.PREF_NATIONAL_UPDATE_TIME, time)
        editor.apply()
    }

    fun loadNationalRuleSetTime(): String {
        val sharedPreferences = app.applicationContext
                .getSharedPreferences(AGConstants.PREFERENCE_KEY, Context.MODE_PRIVATE)
        return sharedPreferences.getString(AGConstants.PREF_NATIONAL_UPDATE_TIME, "")
    }

    fun saveInternationalRuleSetTime(time: String) {
        val sharedPreferences = app.applicationContext
                .getSharedPreferences(AGConstants.PREFERENCE_KEY, Context.MODE_PRIVATE)
        val editor = sharedPreferences.edit()
        editor.putString(AGConstants.PREF_INTERNATIONAL_UPDATE_TIME, time)
        editor.apply()
    }

    fun loadInternationalRuleSetTime(): String {
        val sharedPreferences = app.applicationContext
                .getSharedPreferences(AGConstants.PREFERENCE_KEY, Context.MODE_PRIVATE)
        return sharedPreferences.getString(AGConstants.PREF_INTERNATIONAL_UPDATE_TIME, "")
    }

    fun saveLastConnectedRoute(route: String) {
        val sharedPreferences = app.applicationContext
                .getSharedPreferences(AGConstants.PREFERENCE_KEY, Context.MODE_PRIVATE)
        val editor = sharedPreferences.edit()
        editor.putString(AGConstants.PREF_CONNECTED_ROUTE, route)
        editor.apply()
    }

    fun loadLastConnectedRoute(): String {
        val sharedPreferences = app.applicationContext
                .getSharedPreferences(AGConstants.PREFERENCE_KEY, Context.MODE_PRIVATE)
        return sharedPreferences.getString(AGConstants.PREF_CONNECTED_ROUTE, "")
    }

    fun saveLastUdpEnable(enable: Boolean) {
        val sharedPreferences = app.applicationContext
                .getSharedPreferences(AGConstants.PREFERENCE_KEY, Context.MODE_PRIVATE)
        val editor = sharedPreferences.edit()
        editor.putBoolean(AGConstants.PREF_UPD_IPV6_ENABLE, enable)
        editor.apply()
    }

    fun loadLastUdpEnable(): Boolean {
        val sharedPreferences = app.applicationContext
                .getSharedPreferences(AGConstants.PREFERENCE_KEY, Context.MODE_PRIVATE)
        return sharedPreferences.getBoolean(AGConstants.PREF_UPD_IPV6_ENABLE, false)
    }

    fun saveLastNotificationTime(time: String) {
        val sharedPreferences = app.applicationContext
                .getSharedPreferences(AGConstants.PREFERENCE_KEY, Context.MODE_PRIVATE)
        val editor = sharedPreferences.edit()
        editor.putString(AGConstants.PREF_NOTIFICATION_TIME, time)
        editor.apply()
    }

    fun loadLastNotificationTime(): String {
        val sharedPreferences = app.applicationContext
                .getSharedPreferences(AGConstants.PREFERENCE_KEY, Context.MODE_PRIVATE)
        return sharedPreferences.getString(AGConstants.PREF_NOTIFICATION_TIME, "")
    }

    fun saveBadgeVisible(visible: Boolean) {
        val sharedPreferences = app.applicationContext
                .getSharedPreferences(AGConstants.PREFERENCE_KEY, Context.MODE_PRIVATE)
        val editor = sharedPreferences.edit()
        editor.putBoolean(AGConstants.PREF_BADGE_VISIBLE, visible)
        editor.apply()
    }

    fun loadBadgeVisible(): Boolean {
        val sharedPreferences = app.applicationContext
                .getSharedPreferences(AGConstants.PREFERENCE_KEY, Context.MODE_PRIVATE)
        return sharedPreferences.getBoolean(AGConstants.PREF_BADGE_VISIBLE, false)
    }

    fun saveWelcomeDisable(visible: Boolean) {
        val sharedPreferences = app.applicationContext
                .getSharedPreferences(AGConstants.PREFERENCE_KEY, Context.MODE_PRIVATE)
        val editor = sharedPreferences.edit()
        editor.putBoolean(AGConstants.PREF_WELCOME_DISABLE, visible)
        editor.apply()
    }

    fun loadWelcomeDisable(): Boolean {
        val sharedPreferences = app.applicationContext
                .getSharedPreferences(AGConstants.PREFERENCE_KEY, Context.MODE_PRIVATE)
        return sharedPreferences.getBoolean(AGConstants.PREF_WELCOME_DISABLE, false)
    }

    fun saveBaseUrl(url: String) {
        val sharedPreferences = app.applicationContext
                .getSharedPreferences(AGConstants.PREFERENCE_KEY, Context.MODE_PRIVATE)
        val editor = sharedPreferences.edit()
        editor.putString(AGConstants.PREF_BASE_URL, url)
        editor.apply()
    }

    fun loadBaseUrl(): String {
        val sharedPreferences = app.applicationContext
                .getSharedPreferences(AGConstants.PREFERENCE_KEY, Context.MODE_PRIVATE)
        return sharedPreferences.getString(AGConstants.PREF_BASE_URL, "")
    }

    fun saveVersion(version: Float) {
        val sharedPreferences = app.applicationContext
                .getSharedPreferences(AGConstants.PREFERENCE_KEY, Context.MODE_PRIVATE)
        val editor = sharedPreferences.edit()
        editor.putFloat(AGConstants.PREF_VERSION, version)
        editor.apply()
    }

    fun loadVersion(): Float {
        val sharedPreferences = app.applicationContext
                .getSharedPreferences(AGConstants.PREFERENCE_KEY, Context.MODE_PRIVATE)
        val defVal = 0.0
        return sharedPreferences.getFloat(AGConstants.PREF_VERSION, defVal.toFloat())
    }

    fun clearAllData() {
        val sharedPreferences = app.applicationContext.getSharedPreferences(AGConstants.PREFERENCE_KEY, Context.MODE_PRIVATE)
        val editor = sharedPreferences.edit()
        editor.clear()
        editor.apply()
    }

    companion object {

        protected var instance: Preference? = null
        private val TAG = "Preference"

        fun sharedInstance(): Preference {
            if (instance == null)
                instance = Preference()

            return instance as Preference
        }
    }
}
