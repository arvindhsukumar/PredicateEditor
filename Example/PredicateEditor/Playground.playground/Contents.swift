//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

let kp = KeyPathDescriptor(keyPath: "test") {
    $0.displayString = "no"
}

public enum SectionPredicateType {
    case AND
    case OR
}

public class Section {
    public var title: String
    public var keyPathDescriptors: [KeyPathDescriptor] = []
    public var rows: [Row] = []
    public var compoundPredicateType: SectionPredicateType = .OR
    
    
    public init(title: String, keyPaths: [KeyPathDescriptor]){
        self.title = title
        self.keyPathDescriptors = keyPaths
    }
    
    public func predicates() throws -> [NSPredicate] {
        let predicates = try rows.flatMap { (row:Row) -> NSPredicate? in
            do {
                return try row.toPredicate()
            }
        }
        return predicates
    }
    
    internal func ANDPredicate() throws -> NSCompoundPredicate {
        return try NSCompoundPredicate(orPredicateWithSubpredicates: predicates())
    }
    
    internal func ORPredicate() throws -> NSCompoundPredicate {
        return try NSCompoundPredicate(orPredicateWithSubpredicates: predicates())
    }
    
    public func compoundPredicate() throws -> NSCompoundPredicate {
        return try compoundPredicateType == .OR ? ORPredicate() : ANDPredicate()
    }
}

extension Section {
    public func append(row: Row) {
        rows.append(row)
    }
    
    public func insertRow(row: Row, atIndex: Int){
        rows.insert(row, atIndex: atIndex)
    }
    
    public func deleteRow(row: Row){
        for (i,r) in rows.enumerate() {
            if row === r {
                rows.removeAtIndex(i)
            }
        }
    }
}

let descriptor = KeyPathDescriptor(keyPath: "name", displayString: "Age", propertyType: KeyPathPropertyType.String)
let comparisonType: KeyPathComparisonType = .Is
let value: String = "John"
let row = Row(descriptor: descriptor, comparisonType: comparisonType, value: value)

let descriptor2 = KeyPathDescriptor(keyPath: "dob", displayString: "Name", propertyType: KeyPathPropertyType.DateTime)
let comparisonType2: KeyPathComparisonType = .IsAfter
let value2 = NSDate(timeIntervalSince1970: 321312311)
let row2 = Row()
row2.descriptor = descriptor2
row2.comparisonType = comparisonType2
row2.value = ValueHolder(baseValue: value2)


let section = Section(title: "Test", keyPaths: [])
section.append(row!)
//section.append(row2)

do {
    let ps = try section.predicates()
    dump(ps)
}
catch {
    print(error)
}

class Person: NSObject {
    var name: String
    var funny: Bool = true
    var age: Int = 30
    var score: Float
    var dob: NSDate
    init(name: String, funny: Bool = true, age: Int = 30, score: Float = 100, dob: NSDate = NSDate()){
        self.name = name
        self.funny = funny
        self.age = age
        self.score = score
        self.dob = dob
    }
}

let people = [Person(name: "Johnathan", funny: false, score: 25.2), Person(name: "john", age: 41), Person(name: "ben", age: 24, dob: NSDate(timeIntervalSince1970: 321312312))]
let array = (people as NSArray)
dump(try? (people as NSArray).filteredArrayUsingPredicate(section.ORPredicate()))
