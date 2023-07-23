package com.appgo.appgopro.plugin

import com.appgo.appgopro.AppGoApplication.Companion.app
import com.appgo.appgopro.R

object NoPlugin : Plugin() {
    override val id: String get() = ""
    override val label: CharSequence get() = app.getText(R.string.plugin_disabled)
}
