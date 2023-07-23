package com.appgo.appgopro.models

/**
 * Created by KSMA on 5/5/2017.
 */

class RuleSet(line: String) {

    var ruleType: String? = null
    var ruleName: String? = null
    var ruleAction: String? = null

    var serializeRule: String? = null

    init {
        val values = line.trim { it <= ' ' }.split(",".toRegex()).dropLastWhile { it.isEmpty() }.toTypedArray()
        if (values.size == 3) {
            ruleType = getRuleType(values[0])
            ruleName = values[1]
            ruleAction = getRuleAction(values[2])
        }
    }

    private fun getRuleType(value: String): String {
        var ret = ""

        when (value) {
            "URL-MATCH" -> {
                ret = "[outbound_block_list]"
            }
            "URL" -> {
                ret = "[black_list]"
            }
            "DOMAIN" -> {
                ret = "[bypass_list]"
            }
            "DOMAIN-MATCH" -> {
                ret = "[white_list]"
            }
            "DOMAIN-SUFFIX" -> {
                ret = "[proxy_list]"
            }
            "GEOIP" -> {
                ret = "[reject_all]"
            }
            "IP-CIDR" -> {
                ret = "[bypass_all]"
            }
        }//				case "DOMAIN-SUFFIX": {
        //					ruleType = "[accept_all]";
        //					break;
        //				}
        //				case "DOMAIN-SUFFIX": {
        //					ruleType = "[proxy_all]";
        //					break;
        //				}

        return ret
    }

    private fun getRuleAction(value: String): String {
        var ret = ""

        when (value) {
            "URL-MATCH" -> {
                ret = "[outbound_block_list]"
            }
            "URL" -> {
                ret = "[black_list]"
            }
            "DOMAIN" -> {
                ret = "[bypass_list]"
            }
            "DOMAIN-MATCH" -> {
                ret = "[white_list]"
            }
            "DOMAIN-SUFFIX" -> {
                ret = "[proxy_list]"
            }
            "GEOIP" -> {
                ret = "[reject_all]"
            }
            "IP-CIDR" -> {
                ret = "[bypass_all]"
            }
        }

        return ret
    }
}
