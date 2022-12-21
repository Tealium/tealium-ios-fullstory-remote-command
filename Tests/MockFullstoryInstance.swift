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
    var testDictionary: [String: Any] = [:]
    
    func identifyUser(id: String, data: [String : Any]?) {
        identifyUserCount += 1
        testDictionary = data ?? [:]
    }
    
    func setUserData(data: [String : Any]) {
        setUserDataCount += 1
        testDictionary = data
    }
    
    func logEvent(eventName: String, eventData: [String : Any]) {
        testDictionary = eventData
        logEventCount += 1
    }
}
