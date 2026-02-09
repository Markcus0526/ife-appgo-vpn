//
//  LoggerUtils.swift
//  Appsocks
//
//  Created by LEI on 6/21/16.
//  Copyright © 2016 TouchingApp. All rights reserved.
//

import Foundation
import CocoaLumberjack
import CocoaLumberjackSwift

extension Error {

    func log(message: String?) {
        let errorDesc = (self as NSError).localizedDescription
        if let message = message {
            DDLogError("\(message): \(errorDesc)")
        }else {
            DDLogError("\(errorDesc)")
        }
    }
}

extension String: Error {
    
}

class DebugPrint {
    
    static func dprint(_ message: String) {
        //#if DEBUG
        print(message)
        //#endif
    }
}
