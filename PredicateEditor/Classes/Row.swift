//
// Created by Arvindh Sukumar on 07/07/16.
//

import Foundation

enum RowPredicateError: ErrorType {
    case InsufficientData(keyPath: String?)
    case InvalidComparisonType(keyPath: String)
}

@objc public class Row: NSObject {
    public var descriptor: KeyPathDescriptor?
    public var comparisonType: KeyPathComparisonType?
    private var value: ValueHolder?
    public var baseValue: PredicateComparable? {
        get {
            return value?.baseValue
        }
        set {
            value?.baseValue = newValue
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
        self.value = ValueHolder(baseValue: value)
    }
    
    func toPredicate() throws -> NSPredicate {
        //TODO: throw error?
        guard let descriptor = descriptor, comparisonType = comparisonType, let value = value else {
            throw RowPredicateError.InsufficientData(keyPath: self.descriptor?.keyPath ?? "")
        }
        
        if !descriptor.propertyType.comparisonTypes().contains(comparisonType) {
            throw RowPredicateError.InvalidComparisonType(keyPath: descriptor.keyPath)
        }
        print("base value = \(value.baseValue)")
        var predicate: NSPredicate!
        if let customPredicate = customPredicate(descriptor, comparison: comparisonType, arg: value.baseValue) where comparisonType.needsCustomPredicate() {
            predicate = customPredicate
        }
        else {
            let lhsExpression = NSExpression(forKeyPath: descriptor.keyPath)
            let rhsExpression = NSExpression(forConstantValue: value.baseValue?.constantValue())
            
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
        switch comparison {
        case .IsOn, .IsNotOn:
            let date = arg as? NSDate
            return NSPredicate(format: "%K.beginningOfDay == %@", keyPath, date?.beginningOfDay ?? NSNull())
        case .IsExactly, .IsNotExactly:
            let date = arg as? NSDate
            switch keyPathDescriptor.propertyType {
            case .DateTime:
                return NSPredicate(format: "%K == %@", keyPath, date ?? NSNull())
            case .Time:
                return NSPredicate(format: "%K.time == %@", keyPath, date?.time ?? NSNull())
            default:
                return nil
            }
            
        case .IsAfter:
            let date = arg as? NSDate
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
            let date = arg as? NSDate
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
            let date = arg as? NSDate
            return NSPredicate(format: "%K.today == %@", keyPath, NSDate.today())
        default:
            return nil
        }
    }

}

