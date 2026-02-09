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

import CocoaLumberjack
import CocoaLumberjackSwift
import Sentry

// Custom CocoaLumberjack logger that logs messages to Sentry.
@objc
class AppGoSentryLogger: DDAbstractLogger {

  static let sharedInstance = AppGoSentryLogger()

#if os(macOS)
  private static let kAppGroup = "QT8Z3Q9V3A.com.appgo.macos"
#else
  private static let kAppGroup = "group.com.appgo.appgoios"
#endif
  private static let kDateFormat = "yyyy/MM/dd HH:mm:ss:SSS"
  private static let kDatePattern = "[0-9]{4}/[0-9]{2}/[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2}:[0-9]{3}"

  private var breadcrumbQueue = [Breadcrumb]()
  private var logsDirectory: String!

  // Initializes CocoaLumberjack, adding itself as a logger.
  func initializeLogging() {
    guard let containerUrl = FileManager.default.containerURL(
        forSecurityApplicationGroupIdentifier: AppGoSentryLogger.kAppGroup) else {
      DDLogError("Failed to retrive app container directory")
      return
    }
    self.logsDirectory = containerUrl.appendingPathComponent("Logs").path

    DDLog.add(AppGoSentryLogger.sharedInstance)
    DDLog.add(DDASLLogger.sharedInstance)
    defaultDebugLevel = DDLogLevel.info
  }

  // Adds |logMessage| to Sentry as a breadcrumb.
  override func log(message logMessage: DDLogMessage) {
    let breadcrumb = Breadcrumb(level: ddLogLevelToSentrySeverity(logMessage.level), category:"App")
    breadcrumb.message = logMessage.message
    breadcrumb.timestamp = logMessage.timestamp
    if let sentryClient = Client.shared {
      if !self.breadcrumbQueue.isEmpty {
        self.drainBreadcrumbQueue(sentryClient)
      }
      sentryClient.breadcrumbs.add(breadcrumb)
    } else {
      // Sentry has not been initialized yet. Add breadcrumb to queue.
      self.breadcrumbQueue.append(breadcrumb)
    }
  }

  private func ddLogLevelToSentrySeverity(_ level: DDLogLevel) -> SentrySeverity {
    switch level {
    case .error:
      return .error
    case .warning:
      return .warning
    case .info:
      return .info
    default:
      return .debug
    }
  }

  private func drainBreadcrumbQueue(_ sentryClient: Client) {
    for breadcrumb in self.breadcrumbQueue {
      sentryClient.breadcrumbs.add(breadcrumb)
    }
    self.breadcrumbQueue.removeAll()
  }

  // Reads VpnExtension logs and adds them to Sentry as breadcrumbs.
  func addVpnExtensionLogsToSentry() {
    guard let sentryClient = Client.shared else {
      DDLogWarn("Sentry client not initialized.")
      return
    }
    var logs: [String]
    do {
      logs = try FileManager.default.contentsOfDirectory(atPath: self.logsDirectory)
    } catch {
      DDLogError("Failed to list logs directory. Not sending VPN logs")
      return
    }

    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = AppGoSentryLogger.kDateFormat
    // Breadcrumbs come from the application and VpnExtension processes. There is a limit to how
    // many we send, definied in OutlinePlugin.kMaxBreadcrumbs.
    // Set the number of breadcrumbs for the VPN process to the maximum of an even split of the
    // total breadcrumbs and the remaining breadcrumbs.
    let maxNumVpnExtensionBreadcrumbs = max(
        VPNManager.kMaxBreadcrumbs / 2,
        VPNManager.kMaxBreadcrumbs - sentryClient.breadcrumbs.count());
    var numBreadcrumbsAdded: UInt = 0
    // Log files are named by date, get the most recent.
    for logFile in logs.sorted().reversed() {
      let logFilePath = (self.logsDirectory as NSString).appendingPathComponent(logFile)
      DDLogDebug("Reading log file: \(String(describing: logFilePath))")
      do {
        let logContents = try String(contentsOf: NSURL.fileURL(withPath: logFilePath))
        // Order log lines descending by time.
        let logLines = logContents.components(separatedBy: "\n").reversed()
        for line in logLines {
          if numBreadcrumbsAdded >= maxNumVpnExtensionBreadcrumbs {
            return
          }
          if let (timestamp, message) = parseTimestamp(in: line) {
            let breadcrumb = Breadcrumb(level: .info, category: "VpnExtension")
            breadcrumb.timestamp = dateFormatter.date(from: timestamp)
            breadcrumb.message = message
            sentryClient.breadcrumbs.add(breadcrumb)
            numBreadcrumbsAdded += 1
          }
        }
      } catch let error {
        DDLogError("Failed to read logs: \(error)")
      }
    }
  }

  private func parseTimestamp(in log:String) -> (String, String)? {
    do {
      let regex = try NSRegularExpression(pattern: AppGoSentryLogger.kDatePattern)
      let logNsString = log as NSString // Cast to access NSString length and substring methods.
      let results = regex.matches(in: log, range: NSRange(location: 0, length: logNsString.length))
      if !results.isEmpty {
        let timestamp = logNsString.substring(with: results[0].range)
        let message = logNsString.substring(from: timestamp.count)
            .trimmingCharacters(in: .whitespacesAndNewlines)
        return (timestamp, message)
      }
    } catch let error {
      DDLogError("Failed to parse timestamp: \(error)")
    }
    return nil
  }
}
