//
//  MockFullstoryInstance.swift
//  TealiumFullstory
//
//  Created by Tyler Rister on 10/5/22.
//

import Foundation
@testable import TealiumFullstory

class MockFullstoryInstance: FullstoryCommand {
    var identifyUserCount = 0
    var setUserDataCount = 0
    var logEventCount = 0
    var fetchSessionUrlCount = 0
    
    func identifyUser(id: String, data: [String : Any]) {
        identifyUserCount += 1
    }
    
    func setUserData(data: [String : Any]) {
        setUserDataCount += 1
    }
    
    func logEvent(eventName: String, eventData: [String : Any]) {
        logEventCount += 1
    }
}
