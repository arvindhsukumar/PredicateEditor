//
//  Extensions.swift
//  Pods
//
//  Created by Arvindh Sukumar on 15/07/16.
//
//

import Foundation

extension Dictionary {
    func keysToArray() -> [Key] {
        return Array(self.keys)
    }
    
    func valuesToArray() -> [Value] {
        return Array(self.values)
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
