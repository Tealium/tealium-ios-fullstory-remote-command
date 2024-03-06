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
    static let version = "1.1.0"
    static let seperator: Character = ","
    
    struct Commands {
        static let logEvent = "logevent"
        static let identify = "identify"
        static let setUserVariables = "setuservariables"
    }
    
    struct EventKeys {
        static let eventName = "event_name"
        static let eventProperties = "event"
        static let uid = "uid"
        static let userVariables = "user_variables"
    }
}
