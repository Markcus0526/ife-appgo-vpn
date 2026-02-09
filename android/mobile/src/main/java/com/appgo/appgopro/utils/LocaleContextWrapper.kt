package com.appgo.appgopro.utils

import android.annotation.TargetApi
import android.content.Context
import android.content.ContextWrapper
import android.content.res.Configuration
import android.os.Build
import java.util.*

class LocaleContextWrapper(base: Context) : ContextWrapper(base) {
    companion object {

        fun wrap(context: Context, language: String): ContextWrapper {
            var realContext: Context? = null
            val config = context.resources.configuration
            var sysLocale: Locale? = null
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                sysLocale = getSystemLocale(config)
            } else {
                sysLocale = getSystemLocaleLegacy(config)
            }

            if (!(language == "") && !(sysLocale.language == language)) {
                var locale = Locale(language)
                if (language.toUpperCase() == "CN") {
                    locale = Locale.SIMPLIFIED_CHINESE
                }
                //            Locale.setDefault(locale);
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N)
                    setSystemLocale(config, locale)
                else
                    setSystemLocaleLegacy(config, locale)
            }

            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.JELLY_BEAN_MR1) {
                realContext = context.createConfigurationContext(config)
            } else {
                realContext?.resources?.updateConfiguration(config, context.resources.displayMetrics)
            }

            return LocaleContextWrapper(realContext!!)
        }

        fun getSystemLocaleLegacy(config: Configuration): Locale {
            return config.locale
        }

        @TargetApi(Build.VERSION_CODES.N)
        fun getSystemLocale(config: Configuration): Locale {
            return config.locales.get(0)
        }

        fun setSystemLocaleLegacy(config: Configuration, locale: Locale) {
            config.locale = locale
        }

        @TargetApi(Build.VERSION_CODES.N)
        fun setSystemLocale(config: Configuration, locale: Locale) {
            config.setLocale(locale)
        }
    }
}
