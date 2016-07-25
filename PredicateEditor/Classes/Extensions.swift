//
//  Extensions.swift
//  Pods
//
//  Created by Arvindh Sukumar on 15/07/16.
//
//

import Foundation
import Timepiece

extension Dictionary {
    func keysToArray() -> [Key] {
        return Array(self.keys)
    }
    
    func valuesToArray() -> [Value] {
        return Array(self.values)
    }
}

extension NSDate {
    var time: NSDate {
        return change(year: 0, month: 0, day: 0, hour: hour, minute: minute, second: second)
    }
}

extension Bool {
    func toString() -> String {
        return self ? "true" : "false"
    }
    
    static func fromString(string: String) -> Bool {
        return string == "true" ? true : false
    }
}

extension NSPredicate {
    var isEmpty: Bool {
        return predicateFormat == "FALSEPREDICATE"
    }
}
