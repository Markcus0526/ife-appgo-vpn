package com.appgo.appgopro.utils

import com.appgo.appgopro.models.Preference
import java.util.*

/**
 * Created by KSMA on 4/21/2017.
 */

class Countries {

    var countryInfos = Arrays.asList(
            CountryInfo("CN", "中国", "China", "+86", 0.05f, "ic_flag_cn"),
            CountryInfo("HK", "香港", "Hong Kong", "+852", 0.227f, "ic_flag_hk"),
            CountryInfo("MO", "澳门", "Macau", "+853", 0.076f, "ic_flag_mo"),
            CountryInfo("TW", "台湾", "Taiwan", "+886", 0.16f, "ic_flag_tw"),
            CountryInfo("US", "美国", "United States", "+1", 0.037f, "ic_flag_us"),
            CountryInfo("CA", "加拿大", "Canada", "+1", 0.037f, "ic_flag_ca"),
            CountryInfo("MX", "墨西哥", "Mexico", "+52", 0.294f, "ic_flag_mx"),
            CountryInfo("NL", "荷兰", "Netherlands", "+31", 0.554f, "ic_flag_nl"),
            CountryInfo("BE", "比利时", "Belgium", "+32", 0.673f, "ic_flag_be"),
            CountryInfo("FR", "法国", "France", "+33", 0.311f, "ic_flag_fr"),
            CountryInfo("ES", "西班牙", "Spain", "+34", 0.336f, "ic_flag_es"),
            CountryInfo("IT", "意大利", "Italy", "+39", 0.336f, "ic_flag_it"),
            CountryInfo("CH", "瑞士", "Switzerland", "+41", 0.353f, "ic_flag_ch"),
            CountryInfo("AT", "奥地利", "Austria", "+43", 0.42f, "ic_flag_at"),
            CountryInfo("GB", "英国", "United Kingdom", "+44", 0.218f, "ic_flag_gb"),
            CountryInfo("DK", "丹麦", "Denmark", "+45", 0.139f, "ic_flag_dk"),
            CountryInfo("SE", "瑞典", "Sweden", "+46", 0.302f, "ic_flag_se"),
            CountryInfo("NO", "挪威", "Norway", "+47", 0.328f, "ic_flag_no"),
            CountryInfo("PL", "波兰", "Poland", "+48", 0.193f, "ic_flag_pl"),
            CountryInfo("DE", "德国", "Germany", "+49", 0.42f, "ic_flag_de"),
            CountryInfo("PT", "葡萄牙", "Portugal", "+351", 0.337f, "ic_flag_pt"),
            CountryInfo("FI", "芬兰", "Finland", "+358", 0.555f, "ic_flag_fi"),
            CountryInfo("RU", "俄罗斯", "Russia", "+7", 0.16f, "ic_flag_ru"),
            CountryInfo("UA", "乌克兰", "Ukraine", "+380", 0.588f, "ic_flag_ua"),
            CountryInfo("AR", "阿根廷", "Argentina", "+54", 0.409f, "ic_flag_ar"),
            CountryInfo("BR", "巴西", "Brazil", "+55", 0.404f, "ic_flag_br"),
            CountryInfo("CL", "智利", "Chile", "+56", 0.367f, "ic_flag_cl"),
            CountryInfo("MY", "马来西亚", "Malaysia", "+60", 0.193f, "ic_flag_my"),
            CountryInfo("AU", "澳大利亚", "Australia", "+61", 0.353f, "ic_flag_au"),
            CountryInfo("ID", "印度尼西亚", "Indonesia", "+62", 0.143f, "ic_flag_id"),
            CountryInfo("PH", "菲律宾", "Philippines", "+63", 0.249f, "ic_flag_ph"),
            CountryInfo("NZ", "新西兰", "New Zealand", "+64", 0.582f, "ic_flag_nz"),
            CountryInfo("SG", "新加坡", "Singapore", "+65", 0.244f, "ic_flag_sg"),
            CountryInfo("TH", "泰国", "Thailand", "+66", 0.143f, "ic_flag_th"),
            CountryInfo("JP", "日本", "Japan", "+81", 0.378f, "ic_flag_jp"),
            CountryInfo("KR", "韩国", "South Korea", "+82", 0.101f, "ic_flag_kr"),
            CountryInfo("VN", "越南", "Vietnam", "+84", 0.414f, "ic_flag_vn"),
            CountryInfo("TR", "土耳其", "Turkey", "+90", 0.126f, "ic_flag_tr"),
            CountryInfo("IN", "印度", "India", "+91", 0.05f, "ic_flag_in"),
            CountryInfo("PK", "巴基斯坦", "Pakistan", "+92", 0.168f, "ic_flag_pk"),
            CountryInfo("IR", "伊朗", "Iran", "+98", 0.266f, "ic_flag_ir"),
            CountryInfo("SA", "沙特阿拉伯", "Saudi Arabia", "+966", 0.189f, "ic_flag_sa"),
            CountryInfo("AE", "阿拉伯 联合酋长国", "United Arab Emirates", "+971", 0.193f, "ic_flag_ae"),
            CountryInfo("IL", "以色列", "Israel", "+972", 0.472f, "ic_flag_il"),
            CountryInfo("MN", "蒙古", "Mongolia", "+976", 0.156f, "ic_flag_mn"),
            CountryInfo("ZA", "南非", "South Africa", "+27", 0.146f, "ic_flag_za")
    )

    inner class CountryInfo(var code: String, var chineseName: String, var englishName: String, var phoneCode: String, var price: Float, var flag: String)


    fun getCryptPhoneNumber(mobile: String): String {
        if (mobile.length < 10)
            return mobile

        var cryptNumber = ""

        for (i in countryInfos.indices) {
            var countryCode = mobile.substring(0, 4)
            if (countryCode == countryInfos[i].phoneCode) {
                cryptNumber = mobile.substring(4, 7) + fillCryptCode(mobile.length - 10) + mobile.substring(mobile.length - 3)
                break
            }

            countryCode = mobile.substring(0, 3)
            if (countryCode == countryInfos[i].phoneCode) {
                cryptNumber = mobile.substring(3, 6) + fillCryptCode(mobile.length - 9) + mobile.substring(mobile.length - 3)
                break
            }

            countryCode = mobile.substring(0, 2)
            if (countryCode == this.countryInfos[i].phoneCode) {
                cryptNumber = mobile.substring(2, 5) + fillCryptCode(mobile.length - 8) + mobile.substring(mobile.length - 3)
                break
            }
        }

        return cryptNumber
    }

    fun getNativePhoneNumber(mobile: String): String {
        if (!mobile.contains("+"))
            return mobile

        var nativeNumber = ""

        for (i in countryInfos.indices) {
            var countryCode = mobile.substring(0, 4)
            if (countryCode == countryInfos[i].phoneCode) {
                nativeNumber = mobile.substring(4)
                break
            }

            countryCode = mobile.substring(0, 3)
            if (countryCode == countryInfos[i].phoneCode) {
                nativeNumber = mobile.substring(3)
                break
            }

            countryCode = mobile.substring(0, 2)
            if (countryCode == this.countryInfos[i].phoneCode) {
                nativeNumber = mobile.substring(2)
                break
            }
        }

        return nativeNumber
    }

    fun getFlagByCode(code: String): String {
        var result = "ic_flag_user"

        for (i in countryInfos.indices) {
            if (code.toUpperCase() == countryInfos[i].code) {
                result = countryInfos[i].flag
                break
            }
        }

        return result
    }

    fun getPhoneByCode(code: String): String {
        var result = "+86"

        for (i in countryInfos.indices) {
            if (code == countryInfos[i].code) {
                result = countryInfos[i].phoneCode
                break
            }
        }

        return result
    }

    fun getCodeByPhone(phone: String): String {
        var result = "CN"

        for (i in countryInfos.indices) {
            if (phone == countryInfos[i].phoneCode) {
                result = countryInfos[i].code
                break
            }
        }

        return result
    }

    fun getNameByLanguage(code: String): String {
        var result = ""

        for (i in countryInfos.indices) {
            if (code == countryInfos[i].code) {
                val lang = Preference.sharedInstance().loadDefaultLanguage()
                if (lang == "CN")
                    result = countryInfos[i].chineseName
                else
                    result = countryInfos[i].englishName

                break
            }
        }

        if (result.equals(""))
            result = code

        return result
    }

    private fun fillCryptCode(length: Int): String {
        var result = ""
        for (i in 0 until length) {
            result += "*"
        }
        return result
    }

    companion object {

        protected var instance: Countries? = null
        private val TAG = "Countries"

        fun sharedInstance(): Countries {
            if (instance == null)
                instance = Countries()

            return instance as Countries
        }
    }
}
