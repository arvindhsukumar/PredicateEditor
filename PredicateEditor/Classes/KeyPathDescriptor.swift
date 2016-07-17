//
// Created by Arvindh Sukumar on 07/07/16.
//

import Foundation
import Timepiece

enum InputType {
    case Text
    case Picker
}

public enum KeyPathPropertyType {
    case String
    case Int
    case Float
    case Double
    case Boolean
    case Date
    case Time
    case DateTime
    case Array
    
    public func comparisonTypes() -> [KeyPathComparisonType] {
        switch self {
            case .String:
                return [.Is, .IsNot, .Contains, .DoesNotContain, .BeginsWith, .EndsWith]
            case .Int, .Float, .Double:
                return [.Is, .IsNot, .IsGreaterThan, .IsGreaterThanOrEqualTo, .IsLessThan, .IsLessThanOrEqualTo]
            case .Date:
                return [.IsOn, .IsNotOn, .IsAfter, .IsBefore, .IsToday, .IsBetween]
            case .Time:
                return [.IsExactly, .IsNotExactly, .IsAfter, .IsBefore, .IsBetween]
            case .DateTime:
                return [.IsExactly, .IsNotExactly, .IsAfter, .IsBefore, .IsBetween]
            case .Array:
                return [.Contains]
            case .Boolean:
                return [.Is, .IsNot]
            default:
                return []
        }
    }
}

public enum KeyPathComparisonType: String {
    case Is = "is"
    case IsNot = "is not"
    case Contains = "contains"
    case DoesNotContain = "does not contain"
    case BeginsWith = "begins with"
    case EndsWith = "ends with"
    
    // Numbers
    case IsGreaterThan = "is greater than"
    case IsGreaterThanOrEqualTo = "is greater than or equal to"
    case IsLessThan = "is less than"
    case IsLessThanOrEqualTo = "is less than or equal to"

    // Dates & Times
    case IsOn = "is on"
    case IsNotOn = "is not on"
    case IsAfter = "is after"
    case IsBefore = "is before"
    case IsToday = "is today"
    case IsBetween = "is between"
    case IsExactly = "is exactly"
    case IsNotExactly = "is not exactly"
    
    func predicateOperatorType() -> NSPredicateOperatorType? {
        switch self {
        case .Is:
            return .EqualToPredicateOperatorType
        case .IsNot:
            return .NotEqualToPredicateOperatorType
        case .Contains:
            return .ContainsPredicateOperatorType
        case .DoesNotContain:
            return .ContainsPredicateOperatorType
        case .BeginsWith:
            return .BeginsWithPredicateOperatorType
        case .EndsWith:
            return .EndsWithPredicateOperatorType
        case .IsGreaterThan:
            return .GreaterThanPredicateOperatorType
        case .IsGreaterThanOrEqualTo:
            return .GreaterThanOrEqualToPredicateOperatorType
        case .IsLessThan:
            return .LessThanPredicateOperatorType
        case .IsLessThanOrEqualTo:
            return .LessThanOrEqualToPredicateOperatorType
        default:
            return nil
        }
    }
    
    func shouldNegate() -> Bool {
        switch self {
            case .DoesNotContain, .IsNotOn, .IsNotExactly:
                return true
            default:
                return false
        }
    }
}

enum UnitType {
    // For use with "in the last x" date/time comparison type
    case Year
    case Month
    case Week
    case Day
    case Hour
    case Minute
    case Second
}

public struct KeyPathDescriptor {
    public var title: String!
    public var keyPath: String
    public var propertyType: KeyPathPropertyType = .String
    public var enumerationOptions: [String] = []
    let commonInit = {
        (inout descriptor: KeyPathDescriptor) in
        
        if descriptor.propertyType == .Boolean {
            descriptor.enumerationOptions = ["true", "false"]
        }
    }
    
    public init(keyPath: String, title: String, propertyType: KeyPathPropertyType){
        self.keyPath = keyPath
        self.title = title
        self.propertyType = propertyType
        commonInit(&self)
    }
    
    public init(keyPath: String, @noescape initialiser: (inout descriptor: KeyPathDescriptor)->()){
        self.keyPath = keyPath
        initialiser(descriptor: &self)        
        commonInit(&self)
    }
}

extension KeyPathDescriptor {
    func inputType() -> InputType {
        if enumerationOptions.count > 0 {
            return .Picker
        }
        switch propertyType {
        case .String, .Int, .Float, .Double:
            return .Text
        default:
            return .Picker
        }
    }
    
    func keyboardType() -> UIKeyboardType {
        switch propertyType {
        case .Int:
            return .NumberPad
        case .Float, .Double:
            return .DecimalPad
        default:
            return .Default
        }
    }

}
