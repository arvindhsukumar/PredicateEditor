//
// Created by Arvindh Sukumar on 07/07/16.
//

import Foundation

public enum KeyPathPropertyType {
    case String
    case Number
    case Boolean
    case Date
    case Time
    case Array
    case Enumeration
    
    public func comparisonTypes() -> [KeyPathComparisonType] {
        switch self {
            case .String:
                return [.Is, .IsNot, .Contains, .DoesNotContain, .BeginsWith, .EndsWith]
            case .Number:
                return [.Is, .IsNot, .IsGreaterThan, .IsGreaterThanOrEqualTo, .IsLessThan, .IsLessThanOrEqualTo]
            case .Date:
                return [.IsOn, .IsNotOn, .IsAfter, .IsBefore, .IsToday, .IsBetween, .IsInTheLast]
            case .Time:
                return [.IsExactly, .IsNotExactly, .IsAfter, .IsBefore, .IsToday, .IsBetween, .IsInTheLast]
            case .Array:
                return [.Contains]
            case .Enumeration, .Boolean:
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
    case IsInTheLast = "is in the last"
    case IsExactly = "is exactly"
    case IsNotExactly = "is not exactly"
}


public struct KeyPathDescriptor {
    var displayString: String!
    var keyPath: String
    var propertyType: KeyPathPropertyType = .String
    
    public init(keyPath: String, displayString: String, propertyType: KeyPathPropertyType){
        self.keyPath = keyPath
        self.displayString = displayString
        self.propertyType = propertyType
    }
    
    public init(keyPath: String, @noescape initialiser: (inout descriptor: KeyPathDescriptor)->()){
        self.keyPath = keyPath
        initialiser(descriptor: &self)
    }
}
