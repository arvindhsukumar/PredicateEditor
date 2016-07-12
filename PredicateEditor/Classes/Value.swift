//
//  Value.swift
//  Pods
//
//  Created by Arvindh Sukumar on 12/07/16.
//
//

import Foundation

protocol ValueType {
    var baseValue: PredicateComparable? {get set}
    var displayString: String? {get}
    var rawString: String? {get}
}

let valueDateFormatter: NSDateFormatter = {
    let df = NSDateFormatter()
    df.dateStyle = NSDateFormatterStyle.ShortStyle
    return df
}()

public struct ValueHolder: ValueType {
    var baseValue: PredicateComparable?
    var displayString: String? {
        if let string = baseValue as? String {
            return string
        }
        if let date = baseValue as? NSDate {
            return dateToString(date)
        }
        return nil
    }
    var rawString: String? {
        if let string = baseValue as? String {
            return string
        }
        if let date = baseValue as? NSDate {
            return "\(date.timeIntervalSince1970)"
        }
        return nil
    }
    
    private let dateToString: (NSDate) -> (String) = {
        date in
        return valueDateFormatter.stringFromDate(date)
    }
}

