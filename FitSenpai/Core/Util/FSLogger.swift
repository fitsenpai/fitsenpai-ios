//
//  FSLogger.swift
//  FitSenpai
//
//  Created by Kevin Andrew Maloles on 11/20/24.
//

import Foundation

public enum FSLoggerMode: Int {
    case verbose = 0
    case debug = 1
    case error = 2
    
    func token() -> String {
        if self == .verbose {
            return "🔵 "
        } else if self == .debug {
            return "💠 "
        } else if self == .error {
            return "🔴 "
        }
        return ""
    }
}

public class FSLogger {
    static var currentMode = FSLoggerMode.verbose
    static var clean = false
    open class func output(mode: FSLoggerMode, message:  () -> Any, file: String, function: String, line: Int) {
        var msg = "\(mode.token())\(message())"
        if !clean {
            msg = ("[\(extractFilename(path: file)).\(function):\(line)] \(msg)")
        }
        if mode.rawValue >= FSLogger.currentMode.rawValue  {
            print(msg)
        }
    }
    
    private class func extractFilename(path: String) -> String {
        guard let filenameWithExt = path.components(separatedBy: "/").last else { return path }
        guard let filename = filenameWithExt.components(separatedBy: ".").first else { return filenameWithExt }
        return filename
    }
    
    open class func verbose(_ message:  @autoclosure () -> Any, file: String = #file, function: String = #function, line: Int = #line) {
        output(mode: .verbose, message: message, file: file, function: function, line: line)
    }
    
    open class func debug(_ message:  @autoclosure () -> Any, file: String = #file, function: String = #function, line: Int = #line) {
        output(mode: .debug, message: message, file: file, function: function, line: line)
    }
    
    open class func error(_ message:  @autoclosure () -> Any, file: String = #file, function: String = #function, line: Int = #line) {
        output(mode: .error, message: message, file: file, function: function, line: line)
    }
}
