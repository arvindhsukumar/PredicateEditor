//
// Created by Arvindh Sukumar on 07/07/16.
//

import Foundation

enum RowPredicateError: ErrorType {
    case InsufficientData(keyPath: String?)
    case InvalidComparisonType(keyPath: String)
}

let valueDateFormatter: NSDateFormatter = {
    let df = NSDateFormatter()
    df.dateStyle = NSDateFormatterStyle.ShortStyle
    return df
}()

let valueTimeFormatter: NSDateFormatter = {
    let df = NSDateFormatter()
    df.dateStyle = NSDateFormatterStyle.NoStyle
    df.timeStyle = NSDateFormatterStyle.ShortStyle
    return df
}()

let valueDateTimeFormatter: NSDateFormatter = {
    let df = NSDateFormatter()
    df.dateStyle = NSDateFormatterStyle.ShortStyle
    df.timeStyle = NSDateFormatterStyle.ShortStyle
    return df
}()

@objc public class Row: NSObject {
    public var descriptor: KeyPathDescriptor?
    public var comparisonType: KeyPathComparisonType?
    public var value: PredicateComparable?
    var stringValue: String? {
        get {
            return baseValueToString()
        }
        set {
            value = stringValueToBase(newValue)
        }
    }
    weak var section: Section?
    public var index: Int? {
        return section?.rows.indexOf(self)
    }
    
    required convenience public init?(descriptor: KeyPathDescriptor, comparisonType: KeyPathComparisonType, value: PredicateComparable?) {
        if !descriptor.propertyType.comparisonTypes().contains(comparisonType){
            return nil
        }
        self.init()
        self.descriptor = descriptor
        self.comparisonType = comparisonType
        self.value = value
    }
    
    func stringValueToBase(string: String?) -> PredicateComparable? {
        guard let descriptor = descriptor, comparisonType = comparisonType, let stringValue = string else {
            return nil
        }
        
        var returnValue: PredicateComparable?

        let propertyType = descriptor.propertyType
        switch propertyType {
        case .String:
            returnValue = stringValue
        case .Int:
            returnValue = Int(stringValue)
        case .Float:
            returnValue = Float(stringValue)
        case .Double:
            returnValue = Double(stringValue)
        case .Boolean:
            returnValue = Bool.fromString(stringValue)
        case .Date:
            returnValue = valueDateFormatter.dateFromString(stringValue)?.beginningOfDay
        case .Time:
            returnValue = valueTimeFormatter.dateFromString(stringValue)?.time
        case .DateTime:
            returnValue = valueDateTimeFormatter.dateFromString(stringValue)
        default:
            break
        }
        
        return returnValue
    }
    
    func baseValueToString() -> String? {
        guard let descriptor = descriptor, comparisonType = comparisonType, let value = value else {
            return nil
        }
        
        if let string = value as? String {
            return string
        }
        if let date = value as? NSDate {
            switch descriptor.propertyType {
            case .Date:
                return valueDateFormatter.stringFromDate(date)
            case .Time:
                return valueTimeFormatter.stringFromDate(date)
            case .DateTime:
                return valueDateTimeFormatter.stringFromDate(date)
            default:
                return nil
            }
        }
        if let bool = value as? Bool {
            return bool.toString()
        }
        if let stringConvertible = value as? CustomStringConvertible {
            return String(stringConvertible)
        }
        return nil
    }
    
    func toPredicate() throws -> NSPredicate {
        //TODO: throw error?
        guard let descriptor = descriptor, comparisonType = comparisonType, let value = value else {
            throw RowPredicateError.InsufficientData(keyPath: self.descriptor?.keyPath ?? "")
        }
        
        if !descriptor.propertyType.comparisonTypes().contains(comparisonType) {
            throw RowPredicateError.InvalidComparisonType(keyPath: descriptor.keyPath)
        }

        var predicate: NSPredicate!
        if let customPredicate = customPredicate(descriptor, comparison: comparisonType, arg: value){
            predicate = customPredicate
        }
        else {
            let lhsExpression = NSExpression(forKeyPath: descriptor.keyPath)
            let rhsExpression = NSExpression(forConstantValue: value.constantValue())
            
            var type: NSPredicateOperatorType = comparisonType.predicateOperatorType()!
            var options: NSComparisonPredicateOptions = (descriptor.propertyType == .String) ? [NSComparisonPredicateOptions.CaseInsensitivePredicateOption, NSComparisonPredicateOptions.DiacriticInsensitivePredicateOption] : []
            
            predicate = NSComparisonPredicate(leftExpression: lhsExpression,
                                                  rightExpression: rhsExpression,
                                                  modifier: NSComparisonPredicateModifier.DirectPredicateModifier,
                                                  type: type,
                                                  options: options)
        }
        return comparisonType.shouldNegate() ? NSCompoundPredicate(notPredicateWithSubpredicate: predicate) : predicate
    }
    
    func customPredicate(keyPathDescriptor: KeyPathDescriptor, comparison: KeyPathComparisonType, arg: PredicateComparable?) -> NSPredicate? {
        let keyPath = keyPathDescriptor.keyPath
        let constantValue = arg?.constantValue()
        
        switch comparison {
        case .IsOn, .IsNotOn:
            let date = constantValue as? NSDate
            return NSPredicate(format: "%K.beginningOfDay == %@", keyPath, date?.beginningOfDay ?? NSNull())
        case .IsExactly, .IsNotExactly:
            let date = constantValue as? NSDate
            switch keyPathDescriptor.propertyType {
            case .DateTime:
                return NSPredicate(format: "%K == %@", keyPath, date ?? NSNull())
            case .Time:
                return NSPredicate(format: "%K.time == %@", keyPath, date?.time ?? NSNull())
            default:
                return nil
            }
        case .IsAfter:
            let date = constantValue as? NSDate
            switch keyPathDescriptor.propertyType {
            case .Date:
                return NSPredicate(format: "%K.endOfDay < %@", keyPath, date?.beginningOfDay ?? NSNull())
            case .Time:
                return NSPredicate(format: "%K.time > %@", keyPath, date?.time ?? NSNull())
            case .DateTime:
                return NSPredicate(format: "%K > %@", keyPath, date ?? NSNull())
            default:
                return nil
            }
        case .IsBefore:
            let date = constantValue as? NSDate
            switch keyPathDescriptor.propertyType {
            case .Date:
                return NSPredicate(format: "%K.beginningOfDay > %@", keyPath, date?.endOfDay ?? NSNull())
            case .Time:
                return NSPredicate(format: "%K.time < %@", keyPath, date?.time ?? NSNull())
            case .DateTime:
                return NSPredicate(format: "%K < %@", keyPath, date ?? NSNull())
            default:
                return nil
            }
        case .IsToday:
            let date = constantValue as? NSDate
            return NSPredicate(format: "%K.today == %@", keyPath, NSDate.today())
        default:
            return nil
        }
    }

}

