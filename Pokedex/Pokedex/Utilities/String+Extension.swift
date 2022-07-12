//
//  String+Extension.swift
//  Pokedex
//
//  Created by axavierc on 21/06/2022.
//
import Foundation
import UIKit

extension String {
    
    /// gets the localization of the given string
    public var localized: String {
        
        return NSLocalizedString(self, comment: "")
    }
    
    /// sets first letter to uppercase, "hello world" will be transformed to "Hello world"
    public var firstCapitalized: String {
        return prefix(1).capitalized + dropFirst()
    }

    public var addzeros: String {
        let aux = 3 - count
        var str: String = ""
        if aux <= 0{
            return self
        }else {
            for _ in 0...(aux-1){
                str += "0"
            }
            return str + self
        }
    }
    
    //Log functions
    public func infoLog(functionName: String = #function, fileName: String = #file, lineNumber: Int = #line) {
        var className = (fileName as NSString).lastPathComponent
        className = (className.replacingOccurrences(of: ".swift", with: ""))
        
        print("ℹ️ [\(className).\(functionName)] : \(self)")
    }
    
    public func sucessLog(functionName: String = #function, fileName: String = #file, lineNumber: Int = #line) {
        var className = (fileName as NSString).lastPathComponent
        className = (className.replacingOccurrences(of: ".swift", with: ""))
        
        print("✅ [\(className).\(functionName)] : \(self)")
    }
    
    public func errorLog(functionName: String = #function, fileName: String = #file, lineNumber: Int = #line) {
        var className = (fileName as NSString).lastPathComponent
        className = (className.replacingOccurrences(of: ".swift", with: ""))
        
        print("⛔️ [\(className).\(functionName) ErrorLine:\(lineNumber)] : \(self)")
    }

}
