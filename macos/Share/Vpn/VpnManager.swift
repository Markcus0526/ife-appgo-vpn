
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

open class VpnManager {
    
    private enum Action {
        static let start = "start"
        static let stop = "stop"
        static let onStatusChange = "onStatusChange"
    }

    public static let kMaxBreadcrumbs: UInt = 100
    
    private var connectivity: AppGoConnectivity?
    
    #if os(macOS)
    private static let kPlatform = "macOS"
    #else
    private static let kPlatform = "iOS"
    #endif
    
    public static let shared = VpnManager()
    
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
        NotificationCenter.default.addObserver(self, selector: #selector(self.stopApplication), name: .APP_QUIT, object: nil)
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
    
    func isReachable(_ completion: ((AppGoVpn.ErrorCode?) -> Void)? = nil) {
        let service = AppPref.getCurrentService()
        if service == nil {
            self.vpnStatus = .disconnected
            completion?(AppGoVpn.ErrorCode.illegalServerConfiguration)
            return
        }
        let config: NSDictionary = ["host": service!.server_ip, "port": service!.server_port, "password": service!.password, "method": service!.server_method]
        
        let connection = AppGoConnection(id: String(service!.country_id), config: config as! [String : Any])
        AppGoVpn.shared.isReachable(connection) { errorCode in
            completion?(errorCode)
        }
        AppGoVpn.shared.stop(String(service!.country_id))
        self.vpnStatus = .disconnected
        completion?(AppGoVpn.ErrorCode.noError)
    }
    
    func onStatusChange() {
        /*RCJ guard let connectionId = command.argument(at: 0) as? String else {
            return sendError("Missing connection ID", callbackId: command.callbackId)
        }
        DDLogInfo("\(Action.onStatusChange) \(connectionId)")
        setCallbackId(command.callbackId!, action: Action.onStatusChange, connectionId: connectionId)*/
    }

    // MARK: Helpers
    #if os(macOS)
    @objc private func stopApplication() {
        if let activeConnectionId = AppGoVpn.shared.activeConnectionId {
            AppGoVpn.shared.stop(activeConnectionId)
        }
        NSApplication.shared().terminate(self)
    }
    #endif
    
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

