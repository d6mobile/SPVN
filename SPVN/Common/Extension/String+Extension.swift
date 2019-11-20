//
//  String+Extension.swift
//  CoffeeFloat
//
//  Created by ntq on 8/20/18.
//  Copyright © 2018 NTQ. All rights reserved.
//

import Foundation
import UIKit

extension String {
    
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
    
    var localizable: String {
        return NSLocalizedString(self, comment: "")
    }
    /**
     Return length of the current string
     */
    var length: Int {
        return self.count
    }
    
    var toURL: URL? {
        return URL(string: self)
    }
    
    /**
     Triming white space from start and end of the string
     */
    func trim() -> String {
        return trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    func replace(_ target: String, withString: String) -> String {
        return self.replacingOccurrences(of: target, with: withString, options: NSString.CompareOptions.literal, range: nil)
    }
    
    func containsCharactersInRegexString(regexString: String) -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: regexString,
                                                options: NSRegularExpression.Options(rawValue: 0))
            let matches = regex.numberOfMatches(in: self,
                                                options: NSRegularExpression.MatchingOptions(rawValue: 0),
                                                range: NSMakeRange(0, self.count))
            return (matches > 0)
        } catch let error {
            print(error)
            return false
        }
    }
    
    func substring(startTo: Int) -> String {
        let startIdx = self.index(self.startIndex, offsetBy: startTo)
        let endIdx = self.endIndex
        return String(self[startIdx..<endIdx])
    }
    
    func isNumberPad() -> Bool {
        return self.containsCharactersInRegexString(regexString: "^([0-9０-９]*)?$")
    }
    
    func isValidEmail() -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    func validateUrl () -> Bool {
        let urlRegEx = "(http|https|ftp)://[-A-Za-z0-9+&@#/%?=~_|!:,.;]+[-A-Za-z0-9+&@#/%=~_|]"
        return NSPredicate(format: "SELF MATCHES %@", urlRegEx).evaluate(with: self)
    }
    
    func dateRepresentation(format: String, useCurrentTimeZone: Bool = false) -> Date? {
        guard !self.isEmpty, !format.isEmpty else {
            return nil
        }
        
        let dateFormatter = DateFormatter()
        let locale = Locale(identifier: "ja_JP")
        dateFormatter.locale = locale
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = useCurrentTimeZone ? TimeZone.current : TimeZone(identifier: "UTC")
        
        return dateFormatter.date(from:self)
    }
    
    func dateRepresentationUTC(format: String) -> Date? {
        guard !self.isEmpty, !format.isEmpty else {
            return nil
        }
        
        let dateFormatter = DateFormatter()
        let locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.locale = locale
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone.current
        
        return dateFormatter.date(from: self)
    }
    
    public var lastPathComponent: String {
        return (self as NSString).lastPathComponent
    }
    
    public var deletingLastPathComponent: String {
        return (self as NSString).deletingLastPathComponent
    }

    public func appendingPathComponent(_ str: String) -> String {
        return (self as NSString).appendingPathComponent(str)
    }
    
    public var pathExtension: String {
        return (self as NSString).pathExtension
    }
    
    public var deletingPathExtension: String {
        return (self as NSString).deletingPathExtension
    }
    
    public func appendingPathExtension(_ str: String) -> String? {
        return (self as NSString).appendingPathExtension(str)
    }
    
    func utf8DecodedString()-> String {
        let data = self.data(using: .utf8)
        if let message = String(data: data!, encoding: .nonLossyASCII){
            return message
        }
        return ""
    }

    func utf8EncodedString()-> String {
        let messageData = self.data(using: .nonLossyASCII)
        let text = String(data: messageData!, encoding: .utf8)
        return text ?? ""
    }

    func encodeUrl() -> String? {
        return self.addingPercentEncoding( withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
    }
    
    func decodeUrl() -> String? {
        return self.removingPercentEncoding
    }
}

extension String {
    var optionIndexArray: [String] {
        return self.components(separatedBy: ".")
    }
    
    func integerValue() -> NSInteger {
        return (self as NSString).integerValue
    }
    
    func toHalfWidth() -> String {
        let string = NSMutableString(string: self)
        CFStringTransform( string, nil, kCFStringTransformFullwidthHalfwidth, false)
        return String(string)
    }
    
    func toFullWidth() -> String {
        let string = NSMutableString(string: self)
        CFStringTransform( string, nil, kCFStringTransformFullwidthHalfwidth, true)
        return String(string)
    }
}

extension String {
    var toLocale: Locale {
        return Locale(identifier: self)
    }
}

extension Numeric {
    
    func format(numberStyle: NumberFormatter.Style = NumberFormatter.Style.decimal, locale: Locale = Locale.current) -> String? {
        if let num = self as? NSNumber {
            let formater = NumberFormatter()
            formater.numberStyle = numberStyle
            formater.locale = locale
            return formater.string(from: num)
        }
        return nil
    }
    
    func format(numberStyle: NumberFormatter.Style = NumberFormatter.Style.decimal, groupingSeparator: String = ".", decimalSeparator: String = ",") -> String? {
        if let num = self as? NSNumber {
            let formater = NumberFormatter()
            formater.numberStyle = numberStyle
            formater.groupingSeparator = groupingSeparator
            formater.decimalSeparator = decimalSeparator
            return formater.string(from: num)
        }
        return nil
    }
}
