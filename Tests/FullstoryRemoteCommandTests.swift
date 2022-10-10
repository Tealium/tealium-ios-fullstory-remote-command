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
        if let response = HttpTestHelpers.createRemoteCommandResponse(type: .webview, commandId: "fullstory", payload: payload) {
                fullstoryCommand.completion(response)
                XCTAssertEqual(1, fullstoryInstance.identifyUserCount)
        }
    }
    
    func testSetUserData() {
        let payload: [String: Any] = ["command_name": "setuservariables", "user_variables": ["test1": "value1"]]
        if let response = HttpTestHelpers.createRemoteCommandResponse(type: .webview, commandId: "fullstory", payload: payload) {
            fullstoryCommand.completion(response)
            XCTAssertEqual(1, fullstoryInstance.setUserDataCount)
        }
    }
    
    func testLogEvent() {
        let payload: [String: Any] = ["command_name": "logevent", "event_name": "test_event", "event": ["test1": "value1"]]
        if let response = HttpTestHelpers.createRemoteCommandResponse(type: .webview, commandId: "fullstory", payload: payload) {
            fullstoryCommand.completion(response)
            XCTAssertEqual(1, fullstoryInstance.logEventCount)
        }
    }
}
