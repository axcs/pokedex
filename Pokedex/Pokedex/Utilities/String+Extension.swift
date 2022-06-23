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
        
        print("🆘 [\(className).\(functionName) ErrorLine:\(lineNumber)] : \(self)")
    }
    
    public func createDate(format: String) -> Date {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = format
        let dateString = dateFormatter.date(from: self)
        
        return dateString!
    }
    
    public func substringWithRegularExpression (regularExpression: String) -> String {
        
        var subString: String? = ""
        
        do {
            
            let regex = try NSRegularExpression(pattern: regularExpression, options: [])
            let nsString = self as NSString
            
            let results = regex.matches(in: self, options: [], range: NSRange(location: 0, length: nsString.length))
            subString = results.map { nsString.substring(with: $0.range) }.first
            
            if subString == nil {
                
                subString = self
                
            }
            
        } catch let error as NSError {
            
            subString = self
            print(error)
            
        }
        
        return subString!
    }
    
    public func base64Encoded() -> String? {
        if let data = self.data(using: .utf8) {
            return data.base64EncodedString()
        }
        return nil
    }
    
    public func base64Decoded() -> String? {
        if let data = Data(base64Encoded: self) {
            return String(data: data, encoding: .utf8)
        }
        return nil
    }
    
    public var length: Int {
        return self.count
    }
    
    public func toBool() -> Bool? {
        switch self {
        case "True", "true", "yes", "1":
            return true
        case "False", "false", "no", "0":
            return false
        default:
            return nil
        }
    }
    
    subscript (index: Int) -> String {
        return self[index ..< index + 1]
    }
    
    public func substring(fromIndex: Int) -> String {
        return self[min(fromIndex, length) ..< length]
    }
    
    public func substring(toIndex: Int) -> String {
        return self[0 ..< max(0, toIndex)]
    }
    
    subscript (range: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, range.lowerBound)),
                                            upper: min(length, max(0, range.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }
    
    public func normalize() -> String {
        var normalizedString = self.replacingOccurrences(of: " ", with: "")
        normalizedString = normalizedString.lowercased()
        normalizedString = normalizedString.replacingOccurrences(of: "ç", with: "c")
        normalizedString = normalizedString.replacingOccurrences(of: "ã", with: "a")
        normalizedString = normalizedString.replacingOccurrences(of: "õ", with: "o")
        normalizedString = normalizedString.replacingOccurrences(of: "ñ", with: "n")
        normalizedString = normalizedString.replacingOccurrences(of: "-", with: "")
        normalizedString = normalizedString.replacingOccurrences(of: "é", with: "e")
        normalizedString = normalizedString.replacingOccurrences(of: "á", with: "a")
        normalizedString = normalizedString.replacingOccurrences(of: "ó", with: "o")
        normalizedString = normalizedString.replacingOccurrences(of: "è", with: "e")
        normalizedString = normalizedString.replacingOccurrences(of: "à", with: "a")
        normalizedString = normalizedString.replacingOccurrences(of: "à", with: "o")
        normalizedString = normalizedString.replacingOccurrences(of: "/", with: "")
        normalizedString = normalizedString.replacingOccurrences(of: ",", with: "")
        normalizedString = normalizedString.replacingOccurrences(of: ".", with: "")
        
        return normalizedString
    }
    
 
    
}
