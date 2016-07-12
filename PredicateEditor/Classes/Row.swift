//
// Created by Arvindh Sukumar on 07/07/16.
//

import Foundation

enum RowPredicateError: ErrorType {
    case InvalidComparisonType
}

@objc public class Row: NSObject {
    var descriptor: KeyPathDescriptor?
    var comparisonType: KeyPathComparisonType?
    var value: ValueHolder?
    
    required convenience public init?(descriptor: KeyPathDescriptor, comparisonType: KeyPathComparisonType, value: PredicateComparable?) {
        if !descriptor.propertyType.comparisonTypes().contains(comparisonType){
            return nil
        }
        self.init()
        self.descriptor = descriptor
        self.comparisonType = comparisonType
        self.value = ValueHolder(baseValue: value)
    }
    
    func toPredicate() throws -> NSPredicate? {
        //TODO: throw error?
        guard let descriptor = descriptor, comparisonType = comparisonType, let value = value else {return nil}
        
        if !descriptor.propertyType.comparisonTypes().contains(comparisonType) {
            throw RowPredicateError.InvalidComparisonType
        }
        
        let lhsExpression = NSExpression(forKeyPath: descriptor.keyPath)
        let rhsExpression = NSExpression(forConstantValue: value.baseValue?.constantValue())
        var type: NSPredicateOperatorType = comparisonType.predicateOperatorType()
        var options: NSComparisonPredicateOptions = (descriptor.propertyType == .String) ? [NSComparisonPredicateOptions.CaseInsensitivePredicateOption, NSComparisonPredicateOptions.DiacriticInsensitivePredicateOption] : []
        
        let predicate = NSComparisonPredicate(leftExpression: lhsExpression,
                                              rightExpression: rhsExpression,
                                              modifier: NSComparisonPredicateModifier.DirectPredicateModifier,
                                              type: type,
                                              options: options )
        
        return comparisonType.shouldNegate() ? NSCompoundPredicate(notPredicateWithSubpredicate: predicate) : predicate
    }
}

