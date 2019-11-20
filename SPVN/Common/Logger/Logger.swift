//
//  Logger.swift
//  Music Apps
//
//  Created by DuyDV on 12/11/18.
//  Copyright © 2018 DuyDV. All rights reserved.
//

import Foundation
import CocoaLumberjack

fileprivate let fileLogger: DDFileLogger = DDFileLogger()

public func LoggerSetup() {
    #if DEBUG
    DDLog.add(DDTTYLogger.sharedInstance) // TTY = Xcode console
    //    fileLogger.rollingFrequency = TimeInterval(60*60*24)  // 24 hours
    //    fileLogger.logFileManager.maximumNumberOfLogFiles = 7
    //    DDLog.add(fileLogger)
    #elseif PROD
    //don't need log
    #elseif STAGE
    DDLog.add(DDTTYLogger.sharedInstance) // TTY = Xcode console
    #endif
    
}

public func LoggerAllLogFiles() -> [String] {
    return fileLogger.logFileManager.sortedLogFilePaths
}

public func LogDebug(_ message: @autoclosure () -> String, functionName: StaticString = #function, fileName: StaticString = #file, lineNumber: UInt = #line, userInfo: [String: Any] = [:]) {
    DDLogDebug(message(), file: fileName, function: functionName, line: lineNumber)
}
public func LogVerbose(_ message: @autoclosure () -> String, functionName: StaticString = #function, fileName: StaticString = #file, lineNumber: UInt = #line, userInfo: [String: Any] = [:]) {
    DDLogVerbose(message(), file: fileName, function: functionName, line: lineNumber)
}
public func LogInfo(_ message: @autoclosure () -> String, functionName: StaticString = #function, fileName: StaticString = #file, lineNumber: UInt = #line, userInfo: [String: Any] = [:]) {
    DDLogInfo(message(), file: fileName, function: functionName, line: lineNumber)
}
public func LogWarn(_ message: @autoclosure () -> String, functionName: StaticString = #function, fileName: StaticString = #file, lineNumber: UInt = #line, userInfo: [String: Any] = [:]) {
    DDLogWarn(message(), file: fileName, function: functionName, line: lineNumber)
}
public func LogError(_ message: @autoclosure () -> String, functionName: StaticString = #function, fileName: StaticString = #file, lineNumber: UInt = #line, userInfo: [String: Any] = [:]) {
    DDLogError(message(), file: fileName, function: functionName, line: lineNumber)
}
