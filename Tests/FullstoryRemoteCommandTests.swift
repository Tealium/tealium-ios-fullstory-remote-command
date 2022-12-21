//
//  FullstoryRemoteCommandTests.swift
//  TealiumFullstory
//
//  Created by Tyler Rister on 10/5/22.
//

import Foundation
@testable import TealiumFullstory
import TealiumRemoteCommands
import XCTest

class FullstoryRemoteCommandTests: XCTestCase {
    let fullstoryInstance = MockFullstoryInstance()
    var fullstoryCommand: FullstoryRemoteCommand!
    
    override func setUp() {
        fullstoryCommand = FullstoryRemoteCommand(fullstoryInstance: fullstoryInstance)
    }
    
    override func tearDown() {
        
    }
    
    func testIdentify() {
        let payload: [String: Any] = ["command_name": "identify", "uid": "1234", "user_variables": ["test1": "value1"]]
        fullstoryCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, fullstoryInstance.identifyUserCount)
        XCTAssertEqual("value1", fullstoryInstance.testDictionary["test1"] as! String)
    }
    
    func testSetUserData() {
        let payload: [String: Any] = ["command_name": "setuservariables", "user_variables": ["test1": "value1", "first_name": "John", "last_name": "Doe"]]
        fullstoryCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, fullstoryInstance.setUserDataCount)
        XCTAssertEqual("value1", fullstoryInstance.testDictionary["test1"] as! String)
        XCTAssertEqual("John", fullstoryInstance.testDictionary["first_name"] as! String)
        XCTAssertEqual("Doe", fullstoryInstance.testDictionary["last_name"] as! String)
    }
    
    func testLogEvent() {
        let payload: [String: Any] = ["command_name": "logevent", "event_name": "test_event", "event": ["event_test1": "value1", "event_test2": "value2"]]
        fullstoryCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, fullstoryInstance.logEventCount)
        XCTAssertEqual("value1", fullstoryInstance.testDictionary["event_test1"] as! String)
        XCTAssertEqual("value2", fullstoryInstance.testDictionary["event_test2"] as! String)
    }
}
