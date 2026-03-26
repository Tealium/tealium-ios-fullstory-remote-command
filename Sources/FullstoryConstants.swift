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

    enum Commands: String {
        case logEvent = "logevent"
        case identify = "identify"
        case setUserVariables = "setuservariables"
        case shutdown = "shutdown"
        case restart = "restart"
        case consent = "consent"
        case anonymize = "anonymize"
        case resetIdleTimer = "resetidletimer"
        case log = "log"
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
