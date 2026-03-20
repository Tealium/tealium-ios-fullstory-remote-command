//
//  FSEventLogLevel+String.swift
//  TealiumFullstory
//

import FullStory

extension FSEventLogLevel {
    init?(_ string: String) {
        switch string.lowercased() {
        case "assert",  "fslog_assert":  self = .assert
        case "error",   "fslog_error":   self = .error
        case "warning", "fslog_warning": self = .warning
        case "info",    "fslog_info":    self = .info
        case "debug",   "fslog_debug":   self = .debug
        default: return nil
        }
    }
}
