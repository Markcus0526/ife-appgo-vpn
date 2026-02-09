// Copyright 2018 The AppGo Authors
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import Foundation
import CocoaLumberjack
import CocoaLumberjackSwift

// Persistence layer for a single |AppGoConnection| object.
@objcMembers
class AppGoConnectionStore: NSObject {
  private static let kConnectionStoreKey = "connectionStore"
  private static let kConnectionStatusKey = "connectionStatus"

  private let defaults: UserDefaults?

  // Constructs the store with UserDefaults as the storage.
  required init(appGroup: String) {
    defaults = UserDefaults(suiteName: appGroup)
    super.init()
  }

  // Loads a previously saved connection from the store.
  func load() -> AppGoConnection? {
    if let encodedConnection = defaults?.data(forKey: AppGoConnectionStore.kConnectionStoreKey) {
      return AppGoConnection.decode(encodedConnection)
    }
    return nil
  }

  // Writes |connection| to the store.
  @discardableResult
  func save(_ connection: AppGoConnection) -> Bool {
    if let encodedConnection = connection.encode() {
      defaults?.set(encodedConnection, forKey: AppGoConnectionStore.kConnectionStoreKey)
    }
    return true
  }

  var status: AppGoConnection.ConnectionStatus {
    get {
      let status = defaults?.integer(forKey: AppGoConnectionStore.kConnectionStatusKey)
          ?? AppGoConnection.ConnectionStatus.disconnected.rawValue
      return AppGoConnection.ConnectionStatus(rawValue:status)
          ?? AppGoConnection.ConnectionStatus.disconnected
    }
    set(newStatus) {
      defaults?.set(newStatus.rawValue, forKey: AppGoConnectionStore.kConnectionStatusKey)
    }
  }
}
