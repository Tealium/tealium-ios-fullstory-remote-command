//
//  FullstoryInstance.swift
//  TealiumFullstory
//
//  Created by Tyler Rister on 10/4/22.
//

import Foundation
import FullStory
#if COCOAPODS
    import TealiumSwift
#else
    import TealiumRemoteCommands
#endif

public protocol FullstoryCommand {
    func identifyUser(id: String, data: [String: Any]?)
    func setUserData(data: [String: Any])
    
    func logEvent(eventName: String, eventData: [String: Any])
}

public class FullstoryInstance: FullstoryCommand {
    public init() {}
    public func identifyUser(id: String, data: [String : Any]?) {
        if let userData = data {
            FS.identify(id, userVars: userData)
        } else {
            FS.identify(id)
        }
    }
    
    public func logEvent(eventName: String, eventData: [String : Any]) {
        FS.event(eventName, properties: eventData)
    }
    
    public func setUserData(data: [String : Any]) {
        FS.setUserVars(data)
    }
}
