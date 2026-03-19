//
//  FullstoryInstance.swift
//  TealiumFullstory
//
//  Created by Tyler Rister on 10/4/22.
//

import Foundation
import FullStory

public protocol FullstoryCommand {
    func identifyUser(id: String, data: [String: Any]?)
    func setUserData(data: [String: Any])
    func logEvent(eventName: String, eventData: [String: Any])
    func shutdown()
    func restart()
    func consent(allowed: Bool)
    func anonymize()
    func resetIdleTimer()
    func log(level: String, message: String)
}

public class FullstoryInstance: FullstoryCommand {
    public init() {}

    public func identifyUser(id: String, data: [String: Any]?) {
        if let userData = data {
            FS.identify(id, userVars: userData)
        } else {
            FS.identify(id)
        }
    }

    public func logEvent(eventName: String, eventData: [String: Any]) {
        FS.event(eventName, properties: eventData)
    }

    public func setUserData(data: [String: Any]) {
        FS.setUserVars(data)
    }

    public func shutdown() {
        FS.shutdown()
    }

    public func restart() {
        FS.restart()
    }

    public func consent(allowed: Bool) {
        FS.consent(allowed)
    }

    public func anonymize() {
        FS.anonymize()
    }

    public func resetIdleTimer() {
        FS.resetIdleTimer()
    }

    public func log(level: String, message: String) {
        let logLevel: FSEventLogLevel
        switch level.lowercased() {
        case "assert",  "fslog_assert":  logLevel = FSEventLogLevelAssert
        case "error",   "fslog_error":   logLevel = FSEventLogLevelError
        case "warning", "fslog_warning": logLevel = FSEventLogLevelWarning
        case "info",    "fslog_info":    logLevel = FSEventLogLevelInfo
        case "debug",   "fslog_debug":   logLevel = FSEventLogLevelDebug
        default: return
        }
        FS.log(with: logLevel, message: message)
    }
}
