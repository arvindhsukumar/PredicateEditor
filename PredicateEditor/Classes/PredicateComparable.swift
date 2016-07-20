//
//  PredicateComparable.swift
//  Pods
//
//  Created by Arvindh Sukumar on 12/07/16.
//
//

import Foundation

public protocol PredicateComparable {
    func constantValue() -> AnyObject
}

extension String: PredicateComparable {
    public func constantValue() -> AnyObject {
        return self
    }
}

extension NSDate: PredicateComparable {
    public func constantValue() -> AnyObject {
        return self
    }
}

extension NSNumber: PredicateComparable {
    public func constantValue() -> AnyObject {
        return self
    }
}

extension Int: PredicateComparable {
    public func constantValue() -> AnyObject {
        return NSNumber(integer: self)
    }
}

extension Bool: PredicateComparable {
    public func constantValue() -> AnyObject {
        return NSNumber(bool: self)
    }
}

extension Float: PredicateComparable {
    public func constantValue() -> AnyObject {
        return NSNumber(float: self)
    }
}

extension Double: PredicateComparable {
    public func constantValue() -> AnyObject {
        return NSNumber(double: self)
    }
}
