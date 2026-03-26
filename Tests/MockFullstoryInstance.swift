//
//  MockFullstoryInstance.swift
//  TealiumFullstory
//
//  Created by Tyler Rister on 10/5/22.
//

import Foundation
import FullStory
@testable import TealiumFullstory

class MockFullstoryInstance: FullstoryCommand {
    var identifyUserCount = 0
    var setUserDataCount = 0
    var logEventCount = 0
    var shutdownCount = 0
    var restartCount = 0
    var consentCount = 0
    var anonymizeCount = 0
    var resetIdleTimerCount = 0
    var logCount = 0
    var testDictionary: [String: Any] = [:]
    var lastConsentValue: Bool?
    var lastLogLevel: FSEventLogLevel?
    var lastLogMessage: String?

    func identifyUser(id: String, data: [String: Any]?) {
        identifyUserCount += 1
        testDictionary = data ?? [:]
    }

    func setUserData(data: [String: Any]) {
        setUserDataCount += 1
        testDictionary = data
    }

    func logEvent(eventName: String, eventData: [String: Any]) {
        testDictionary = eventData
        logEventCount += 1
    }

    func shutdown() {
        shutdownCount += 1
    }

    func restart() {
        restartCount += 1
    }

    func consent(allowed: Bool) {
        consentCount += 1
        lastConsentValue = allowed
    }

    func anonymize() {
        anonymizeCount += 1
    }

    func resetIdleTimer() {
        resetIdleTimerCount += 1
    }

    func log(level: FSEventLogLevel, message: String) {
        logCount += 1
        lastLogLevel = level
        lastLogMessage = message
    }
}
