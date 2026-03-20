//
//  FullstoryRemoteCommand.swift
//  TealiumFullstory
//
//  Created by Tyler Rister on 10/4/22.
//

import Foundation
import FullStory
#if COCOAPODS
    import TealiumSwift
#else
    import TealiumCore
    import TealiumRemoteCommands
#endif

public class FullstoryRemoteCommand: RemoteCommand {
    
    override public var version: String? {
        return FullstoryConstants.version
    }
    
    var fullstoryInstance: FullstoryCommand
    
    public init(fullstoryInstance: FullstoryCommand = FullstoryInstance(), type: RemoteCommandType = .webview) {
        self.fullstoryInstance = fullstoryInstance
        weak var weakSelf: FullstoryRemoteCommand?
        super.init(commandId: FullstoryConstants.commandId, description: FullstoryConstants.description, type: type, completion: { response in
            guard let payload = response.payload else {
                return
            }
            weakSelf?.processRemoteCommand(with: payload)
        })
        weakSelf = self
    }
    
    func processRemoteCommand(with payload: [String: Any]) {
        guard let command = payload[FullstoryConstants.commandName] as? String else {
            return
        }
        let commands = command.split(separator: FullstoryConstants.separator)
        commands
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .compactMap { FullstoryConstants.Commands(rawValue: $0.lowercased()) }
            .forEach { command in
                switch command {
                case .identify:
                    guard let uid = payload[FullstoryConstants.EventKeys.uid] as? String else { return }
                    let userData = payload[FullstoryConstants.EventKeys.userVariables] as? [String: Any]
                    fullstoryInstance.identifyUser(id: uid, data: userData)
                case .setUserVariables:
                    guard let userData = payload[FullstoryConstants.EventKeys.userVariables] as? [String: Any] else { return }
                    fullstoryInstance.setUserData(data: userData)
                case .logEvent:
                    guard let eventName = payload[FullstoryConstants.EventKeys.eventName] as? String else { return }
                    let eventData = payload[FullstoryConstants.EventKeys.eventProperties] as? [String: Any] ?? [:]
                    fullstoryInstance.logEvent(eventName: eventName, eventData: eventData)
                case .shutdown:
                    fullstoryInstance.shutdown()
                case .restart:
                    fullstoryInstance.restart()
                case .consent:
                    guard let allowed = payload[FullstoryConstants.EventKeys.consentGranted] as? Bool else { return }
                    fullstoryInstance.consent(allowed: allowed)
                case .anonymize:
                    fullstoryInstance.anonymize()
                case .resetIdleTimer:
                    fullstoryInstance.resetIdleTimer()
                case .log:
                    guard let message = payload[FullstoryConstants.EventKeys.logMessage] as? String,
                          let levelString = payload[FullstoryConstants.EventKeys.logLevel] as? String,
                          let level = FSEventLogLevel(levelString) else { return }
                    fullstoryInstance.log(level: level, message: message)
                }
            }
    }
}
