// Copyright 2018 The Outline Authors
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

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    static let kAppGroup = "3W5J6994PB.com.appgo.macos"
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let mainAppIdentifier = AppInfo.bundleID
        let running = NSWorkspace.shared().runningApplications
        var alreadyRunning = false
        
        // loop through running apps - check if the Main application is running
        for app in running {
            if app.bundleIdentifier == mainAppIdentifier {
                alreadyRunning = true
                break
            }
        }
        
        if !alreadyRunning {
            // Register for the notification killme
            DistributedNotificationCenter.default.addObserver(self, selector: #selector(self.terminate), name: .LAUNCH_KILL_ME, object: mainAppIdentifier)
            
            // Get the path of the current app and navigate through them to find the Main Application
            let path = Bundle.main.bundlePath as NSString
            var components = path.pathComponents
            components.removeLast(3)
            components.append("MacOS")
            components.append("AppGo")
            
            let newPath = NSString.path(withComponents: components)
            
            //let connectionStore = AppGoConnectionStore(appGroup: AppDelegate.kAppGroup)
            //if connectionStore.status != AppGoConnection.ConnectionStatus.connected {
            //    return NSLog("Not lauching, AppGo not connected at shutdown")
            //}
            
            // Launch the Main application
            NSWorkspace.shared().launchApplication(newPath)
        } else {
            // Main application is already running
            self.terminate()
        }
    }
    
    func terminate() {
        print("Terminate application")
        NSApp.terminate(nil)
    }
}
