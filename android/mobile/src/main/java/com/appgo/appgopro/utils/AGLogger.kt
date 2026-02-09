package com.appgo.appgopro.utils

import android.os.Environment
import java.io.BufferedWriter
import java.io.File
import java.io.FileWriter
import java.io.IOException
import java.util.*

/**
 * Created by KSMA on 4/19/2017.
 */

class AGLogger {

    companion object {
        val TAG = "AppGo"
        val LOG_FILE = "appgo.log"

        fun log(tag: String, format: String, vararg args: Any) {
            try {
                android.util.Log.w(TAG + " : " + tag, String.format(format, *args))
                logToFile(tag, "OK", String.format(format, args));
            } catch (e: Exception) {
                e.printStackTrace()
            }
        }

        fun error(tag: String, format: String, vararg args: Any) {
            try {
                android.util.Log.e(TAG + " : " + tag, String.format(format, *args))
                logToFile(tag, "ERROR", String.format(format, args));
            } catch (e: Exception) {
            }
        }

        private fun logToFile(tag: String, type: String, format: String) {
            try {
                // Gets the log file from the root of the primary storage. If it does
                // not exist, the file is created.
                val logFile = File(Environment.getExternalStorageDirectory(), LOG_FILE)
                if (!logFile.exists()) {
                    logFile.createNewFile()
                } else {
                    if (logFile.length() > 50 * 1024 * 1024) {
                        // File is bigger than 50MB
                        logFile.delete()
                        logFile.createNewFile()
                    }
                }


                // Write the message to the log with a timestamp
                val writer = BufferedWriter(FileWriter(logFile, true))
                writer.write(String.format("%s [%s(%s)] : %s\r\n", Date().toString(), tag, type, format))
                writer.close()
            } catch (e: IOException) {
                e.printStackTrace()
            }
        }
    }
}
