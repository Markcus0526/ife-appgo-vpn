
//
//  ProxyService.swift
//  AppGoPro
//
//  Created by LEI on 12/28/15.
//  Copyright © 2015 TouchingApp. All rights reserved.
//

import CocoaLumberjack
import CocoaLumberjackSwift
import NetworkExtension
import Sentry

open class VPNManager {
    
    private enum Action {
        static let start = "start"
        static let stop = "stop"
        static let onStatusChange = "onStatusChange"
    }

    public static let kMaxBreadcrumbs: UInt = 100
    
    private var connectivity: AppGoConnectivity?
    
    #if os(macOS)
    // cordova-osx does not support URL interception. Until it does, we have version-controlled
    // AppDelegate.m (intercept) and AppGo-Info.plist (register protocol) to handle ss:// URLs.
    //RCJ private var urlHandler: CDVMacOsUrlHandler?
    private static let kPlatform = "macOS"
    #else
    private static let kPlatform = "iOS"
    #endif
    
    public static let shared = VPNManager()
    
    public var vpnStatus = NEVPNStatus.disconnected {
        didSet {
            NotificationCenter.default.post(name: .VPN_STATUS_CHANGE, object: nil, userInfo: ["status": vpnStatus])
        }
    }
    
    init() {
        AppGoSentryLogger.sharedInstance.initializeLogging()
        connectivity = AppGoConnectivity()
        AppGoVpn.shared.onVpnStatusChange(onVpnStatusChange)
        
        #if os(macOS)
        NotificationCenter.default.addObserver(
            self, selector: #selector(self.stopVpnOnAppQuit), name: .APP_QUIT, object: nil)
        #endif
    }
    
    deinit {
        #if os(macOS)
        NotificationCenter.default.removeObserver(self)
        #endif
    }
    
    /**
     Starts the VPN. This method is idempotent for a given connection.
     - Parameters:
     - command: CDVInvokedUrlCommand, where command.arguments
     - connectionId: string, ID of the connection
     - config: [String: Any], represents a server configuration
     */
    func start(_ completion: ((AppGoVpn.ErrorCode?) -> Void)? = nil) {
        let service = AppPref.getCurrentService()
        if service == nil {
            self.vpnStatus = .disconnected
            completion?(AppGoVpn.ErrorCode.illegalServerConfiguration)
            return
        }
        
        let config: NSDictionary = ["host": service!.server_ip, "port": service!.server_port, "password": service!.password, "method": service!.server_method]

        DDLogInfo("\(Action.start) \(String(describing: service!.country_id))")
        let connection = AppGoConnection(id: String(service!.country_id), config: config as! [String : Any])
        AppGoVpn.shared.start(connection) { errorCode in
            if errorCode == AppGoVpn.ErrorCode.noError {
                self.vpnStatus = .connected
            } else {
                self.vpnStatus = .disconnected
            }
            completion?(errorCode)
        }
    }
    
    /**
     Stops the VPN. Sends an error if the given connection is not running.
     - Parameters:
     - command: CDVInvokedUrlCommand, where command.arguments
     - connectionId: string, ID of the connection
     */
    func stop(_ completion: ((AppGoVpn.ErrorCode?) -> Void)? = nil) {
        let service = AppPref.getCurrentService()
        if service == nil {
            self.vpnStatus = .disconnected
            completion?(AppGoVpn.ErrorCode.illegalServerConfiguration)
            return
        }
        
        DDLogInfo("\(Action.stop) \(String(service!.country_id))")
        AppGoVpn.shared.stop(String(service!.country_id))
        self.vpnStatus = .disconnected
        completion?(AppGoVpn.ErrorCode.noError)
    }
    
    func isRunning() -> NEVPNStatus {
        self.vpnStatus = .disconnected
        
        let service = AppPref.getCurrentService()
        if service == nil {
            return self.vpnStatus
        }
        
        if AppGoVpn.shared.isActive(String(service!.country_id)) {
            self.vpnStatus = .connected
        }
        return self.vpnStatus
    }
    
    func isReachable() {
        /*guard let connectionId = command.argument(at: 0) as? String else {
            return sendError("Missing connection ID", callbackId: command.callbackId)
        }
        DDLogInfo("isReachable \(connectionId)")
        guard connectivity != nil else {
            return sendError("Cannot assess server reachability" , callbackId: command.callbackId)
        }
        guard let host = command.argument(at: 1) as? String else {
            return sendError("Missing host address" , callbackId: command.callbackId)
        }
        guard let port = command.argument(at: 2) as? UInt16 else {
            return sendError("Missing host port", callbackId: command.callbackId)
        }
        let connection = AppGoConnection(id: connectionId, config: ["host": host, "port": port])
        AppGoVpn.shared.isReachable(connection) { errorCode in
            self.sendSuccess(errorCode == AppGoVpn.ErrorCode.noError, callbackId: command.callbackId)
        }*/
    }
    
    func onStatusChange() {
        /*RCJ guard let connectionId = command.argument(at: 0) as? String else {
            return sendError("Missing connection ID", callbackId: command.callbackId)
        }
        DDLogInfo("\(Action.onStatusChange) \(connectionId)")
        setCallbackId(command.callbackId!, action: Action.onStatusChange, connectionId: connectionId)*/
    }

    #if os(macOS)
    func quitApplication(_ command: CDVInvokedUrlCommand) {
        NSApplication.shared.terminate(self)
    }
    #endif
    
    // MARK: Helpers
    
    @objc private func stopVpnOnAppQuit() {
        if let activeConnectionId = AppGoVpn.shared.activeConnectionId {
            AppGoVpn.shared.stop(activeConnectionId)
        }
    }
    
    // Receives NEVPNStatusDidChange notifications. Calls onConnectionStatusChange for the active
    // connection.
    func onVpnStatusChange(status: NEVPNStatus, connectionId: String) {
        switch status {
        case .connected:
            vpnStatus = NEVPNStatus.connected
        case .disconnected:
            vpnStatus = NEVPNStatus.disconnected
        case .connecting:
            vpnStatus = NEVPNStatus.connecting
        case .disconnecting:
            vpnStatus = NEVPNStatus.disconnecting
        case .reasserting:
            vpnStatus = NEVPNStatus.reasserting
        default:
            return;  // Do not report transient or invalid states.
        }
        DDLogInfo("onVpnStatusChange: \(String(vpnStatus.rawValue))")
    }
}

