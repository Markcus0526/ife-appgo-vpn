package com.appgo.appgopro.utils

import android.annotation.TargetApi
import com.appgo.appgopro.AppGoApplication.Companion.app
import com.appgo.appgopro.database.DataStore
import com.appgo.appgopro.database.Profile
import com.appgo.appgopro.database.ProfileManager
import com.appgo.appgopro.services.BaseService
import java.io.File
import java.io.IOException
import java.io.ObjectInputStream
import java.io.ObjectOutputStream

@TargetApi(24)
object DirectBoot {
    private val file = File(app.deviceContext.noBackupFilesDir, "directBootProfile")

    fun getDeviceProfile(): Profile? = try {
        ObjectInputStream(file.inputStream()).use { it.readObject() as Profile }
    } catch (_: IOException) { null }

    fun clean() {
        file.delete()
        File(app.deviceContext.noBackupFilesDir, BaseService.CONFIG_FILE).delete()
    }

    fun update() {
        val profile = ProfileManager.getProfile(DataStore.profileId)    // app.currentProfile will call this
        if (profile == null) clean() else ObjectOutputStream(file.outputStream()).use { it.writeObject(profile) }
    }
}
