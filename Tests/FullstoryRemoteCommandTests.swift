//
//  FullstoryRemoteCommandTests.swift
//  TealiumFullstory
//
//  Created by Tyler Rister on 10/5/22.
//

import Foundation
import FullStory
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

    func testIdentifyWithoutUserVariables() {
        let payload: [String: Any] = ["command_name": "identify", "uid": "1234"]
        fullstoryCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, fullstoryInstance.identifyUserCount)
        XCTAssertTrue(fullstoryInstance.testDictionary.isEmpty)
    }

    func testIdentifyMissingUid() {
        let payload: [String: Any] = ["command_name": "identify"]
        fullstoryCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(0, fullstoryInstance.identifyUserCount)
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

    func testLogEventWithoutProperties() {
        let payload: [String: Any] = ["command_name": "logevent", "event_name": "test_event"]
        fullstoryCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, fullstoryInstance.logEventCount)
        XCTAssertTrue(fullstoryInstance.testDictionary.isEmpty)
    }

    func testLogEventMissingName() {
        let payload: [String: Any] = ["command_name": "logevent"]
        fullstoryCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(0, fullstoryInstance.logEventCount)
    }

    func testShutdown() {
        let payload: [String: Any] = ["command_name": "shutdown"]
        fullstoryCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, fullstoryInstance.shutdownCount)
    }

    func testRestart() {
        let payload: [String: Any] = ["command_name": "restart"]
        fullstoryCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, fullstoryInstance.restartCount)
    }

    func testConsentGranted() {
        let payload: [String: Any] = ["command_name": "consent", "consent_granted": true]
        fullstoryCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, fullstoryInstance.consentCount)
        XCTAssertEqual(true, fullstoryInstance.lastConsentValue)
    }

    func testConsentRevoked() {
        let payload: [String: Any] = ["command_name": "consent", "consent_granted": false]
        fullstoryCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, fullstoryInstance.consentCount)
        XCTAssertEqual(false, fullstoryInstance.lastConsentValue)
    }

    func testConsentMissingPayload() {
        let payload: [String: Any] = ["command_name": "consent"]
        fullstoryCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(0, fullstoryInstance.consentCount)
    }

    func testAnonymize() {
        let payload: [String: Any] = ["command_name": "anonymize"]
        fullstoryCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, fullstoryInstance.anonymizeCount)
    }

    func testResetIdleTimer() {
        let payload: [String: Any] = ["command_name": "resetidletimer"]
        fullstoryCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, fullstoryInstance.resetIdleTimerCount)
    }

    func testLog() {
        let payload: [String: Any] = ["command_name": "log", "log_level": "error", "log_message": "test message"]
        fullstoryCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, fullstoryInstance.logCount)
        XCTAssertEqual(.error, fullstoryInstance.lastLogLevel)
        XCTAssertEqual("test message", fullstoryInstance.lastLogMessage)
    }

    func testLogMissingLevel() {
        let payload: [String: Any] = ["command_name": "log", "log_message": "test message"]
        fullstoryCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(0, fullstoryInstance.logCount)
    }

    func testLogMissingMessage() {
        let payload: [String: Any] = ["command_name": "log", "log_level": "error"]
        fullstoryCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(0, fullstoryInstance.logCount)
    }

    func testLogInvalidLevel() {
        let payload: [String: Any] = ["command_name": "log", "log_level": "verbose", "log_message": "test"]
        fullstoryCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(0, fullstoryInstance.logCount)
    }

    func testMultipleCommands() {
        let payload: [String: Any] = ["command_name": "shutdown,restart"]
        fullstoryCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, fullstoryInstance.shutdownCount)
        XCTAssertEqual(1, fullstoryInstance.restartCount)
    }

    func testMultipleCommandsWithSpaces() {
        let payload: [String: Any] = ["command_name": "shutdown, restart"]
        fullstoryCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, fullstoryInstance.shutdownCount)
        XCTAssertEqual(1, fullstoryInstance.restartCount)
    }
}
