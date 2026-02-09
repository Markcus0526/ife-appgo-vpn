package com.appgo.appgopro.utils

import android.content.Intent

/**
 * Created by KSMA on 4/19/2017.
 */

interface onActivityResultListener {

    fun onSharedActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean
}
