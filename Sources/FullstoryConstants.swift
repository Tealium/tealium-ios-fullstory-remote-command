//
//  FullstoryConstants.swift
//  TealiumFullstory
//
//  Created by Tyler Rister on 10/4/22.
//

import Foundation

enum FullstoryConstants {
    static let commandId = "fullstory"
    static let description = "Fullstory Remote Command"
    static let commandName = "command_name"
    static let version = "1.2.0"
    static let separator: Character = ","

    struct Commands {
        static let logEvent = "logevent"
        static let identify = "identify"
        static let setUserVariables = "setuservariables"
        static let shutdown = "shutdown"
        static let restart = "restart"
        static let consent = "consent"
        static let anonymize = "anonymize"
        static let resetIdleTimer = "resetidletimer"
        static let log = "log"
    }

    struct LogLevels {
        static let valid: Set<String> = [
            "assert", "fslog_assert",
            "error",  "fslog_error",
            "warning","fslog_warning",
            "info",   "fslog_info",
            "debug",  "fslog_debug"
        ]
    }

    struct EventKeys {
        static let eventName = "event_name"
        static let eventProperties = "event"
        static let uid = "uid"
        static let userVariables = "user_variables"
        static let consentGranted = "consent_granted"
        static let logLevel = "log_level"
        static let logMessage = "log_message"
    }
}
