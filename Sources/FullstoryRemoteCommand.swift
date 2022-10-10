//
//  FullstoryRemoteCommand.swift
//  TealiumFullstory
//
//  Created by Tyler Rister on 10/4/22.
//

import Foundation
#if COCOAPODS
    import TealiumSwift
#else
    import TealiumCore
    import TealiumRemoteCommands
#endif

public class FullstoryRemoteCommand: RemoteCommand {
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
        let commands = command.split(separator: FullstoryConstants.seperator)
        let fullstoryCommands = commands.map { $0.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)}
        fullstoryCommands.forEach { command in
            switch(command) {
            case FullstoryConstants.Commands.identify:
                guard let uid = payload[FullstoryConstants.EventKeys.uid] as? String, let userData = payload[FullstoryConstants.EventKeys.userVariables] as? [String: Any] else {
                    break
                }
                fullstoryInstance.identifyUser(id: uid, data: userData)
            case FullstoryConstants.Commands.setUserVariables:
                guard let userData = payload[FullstoryConstants.EventKeys.userVariables] as? [String: Any] else {
                    break
                }
                fullstoryInstance.setUserData(data: userData)
            case FullstoryConstants.Commands.logEvent:
                guard let eventName = payload[FullstoryConstants.EventKeys.eventName] as? String, let eventData = payload[FullstoryConstants.EventKeys.eventProperties] as? [String: Any] else {
                    break
                }
                fullstoryInstance.logEvent(eventName: eventName, eventData: eventData)
            default:
                break
            }
        }
    }
}
