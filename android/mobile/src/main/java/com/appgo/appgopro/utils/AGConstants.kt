package com.appgo.appgopro.utils

/**
 * Created by KSMA on 4/19/2017.
 */

object AGConstants {

    /***********************************************************************************************
    * Preference Keys
    */
    const val PREFERENCE_KEY = "APPGO_PREFERENCE"
    const val PREF_AUTH_USERNAME = "userName"
    const val PREF_AUTH_PASSWORD = "password"
    const val PREF_ACCESS_TOKEN = "access_token"
    const val PREF_EXPIRE_IN = "expire_in"
    const val PREF_REFRESH_TOKEN = "refresh_token"
    const val PREF_TOKEN_TYPE = "token_type"
    const val PREF_LOGIN_DATE = "login_date"
    const val PREF_DEFAULT_LANGUAGE = "default_language"
    const val PREF_CONNECTED_USER_SERVICE = "connected_user_service"
    const val PREF_AVAILABLE_USER_SERVICES = "available_user_services"
    const val SMS_COUNT: Int = 120 * 1000
    const val TRANSFER_TIME: Int = 60 * 10 * 1000
    const val PREF_NATIONAL_UPDATE_TIME = "national_update_time"
    const val PREF_INTERNATIONAL_UPDATE_TIME = "international_update_time"
    const val PREF_CONNECTED_ROUTE = "connected_route"
    const val PREF_UPD_IPV6_ENABLE = "udp_ipv6_enable"
    const val PREF_NOTIFICATION_TIME = "notification_time"
    const val PREF_BADGE_VISIBLE = "badge_visible"
    const val PREF_WELCOME_DISABLE = "welcome_disable"
    const val PREF_BASE_URL = "base_url"
    const val PREF_VERSION = "version"
    /** *********************************************************************************************
     * Broadcast Messages
     */
    const val BROADCAST_SIGNAL_SERVER_CHANGED = "server_changed"
    const val BROADCAST_SIGNAL_PURCHASE_CHANGED = "purchase_changed"
    const val BROADCAST_SIGNAL_ACOIN_CHANGED = "acoin_changed"
    const val BROADCAST_SIGNAL_TRANSFER_CHANGED = "transfer_changed"
    const val BROADCAST_SIGNAL_VPN_STATE_CHANGED = "vpn_state_changed"
    const val BROADCAST_SIGNAL_QRCODE_SCANNED = "qrcode_scanned"
    const val BROADCAST_SIGNAL_NOTIFICATION_RECEIVED = "notification_received"
    /** *********************************************************************************************
     * Request constants
     */
    const val REQCODE_START_VPN_SERVICE_REQUEST = 1
    const val REQCODE_QRCODE_REQUEST = 2
    /** *********************************************************************************************
     * Permission management constants
     */
    const val PERMISSION_REQUEST_LOCATION = 123
    const val PERMISSION_REQUEST_STORAGE = 125
    const val PERM_STORAGE_NEED_GRANT = 0
    const val PERM_STORAGE_DID_NOT_GRANT = 1
    /** *********************************************************************************************
     * VPN mode
     */
    const val VPN_INTERNATIONAL = 0 //"international";
    const val VPN_NATIONAL = 1 //"national";
    const val VPN_GLOBAL = 2 //"global";
    const val VPN_RULESET_FILE = "ruleset.acl"

    const val SERVICE_ACTION_SERVICE = "com.appgo.appgopro.SERVICE"
    const val SERVICE_ACTION_CLOSE = "com.appgo.appgopro.CLOSE"

    const val CRYPT_KEY = "fqJfdzGDvfwbedsKSUGty3VZ9taXxMVw" //AES only supports key sizes of 16, 24 or 32 bytes
}
