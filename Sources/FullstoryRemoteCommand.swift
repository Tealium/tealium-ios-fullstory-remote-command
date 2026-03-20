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
        let fullstoryCommands = commands.map { $0.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)}
        fullstoryCommands.forEach { command in
            switch(command) {
            case FullstoryConstants.Commands.identify:
                guard let uid = payload[FullstoryConstants.EventKeys.uid] as? String else {
                    break
                }
                let userData = payload[FullstoryConstants.EventKeys.userVariables] as? [String: Any]
                fullstoryInstance.identifyUser(id: uid, data: userData)
            case FullstoryConstants.Commands.setUserVariables:
                guard let userData = payload[FullstoryConstants.EventKeys.userVariables] as? [String: Any] else {
                    break
                }
                fullstoryInstance.setUserData(data: userData)
            case FullstoryConstants.Commands.logEvent:
                guard let eventName = payload[FullstoryConstants.EventKeys.eventName] as? String else {
                    break
                }
                let eventData: [String: Any] = payload[FullstoryConstants.EventKeys.eventProperties] as? [String: Any] ?? [:]
                fullstoryInstance.logEvent(eventName: eventName, eventData: eventData)
            case FullstoryConstants.Commands.shutdown:
                fullstoryInstance.shutdown()
            case FullstoryConstants.Commands.restart:
                fullstoryInstance.restart()
            case FullstoryConstants.Commands.consent:
                guard let allowed = payload[FullstoryConstants.EventKeys.consentGranted] as? Bool else {
                    break
                }
                fullstoryInstance.consent(allowed: allowed)
            case FullstoryConstants.Commands.anonymize:
                fullstoryInstance.anonymize()
            case FullstoryConstants.Commands.resetIdleTimer:
                fullstoryInstance.resetIdleTimer()
            case FullstoryConstants.Commands.log:
                guard let message = payload[FullstoryConstants.EventKeys.logMessage] as? String,
                      let level = payload[FullstoryConstants.EventKeys.logLevel] as? String,
                      FSEventLogLevel(level) != nil else {
                    break
                }
                fullstoryInstance.log(level: level, message: message)
            default:
                break
            }
        }
    }
}
