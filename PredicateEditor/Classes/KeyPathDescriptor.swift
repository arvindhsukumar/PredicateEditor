//
// Created by Arvindh Sukumar on 07/07/16.
//

import Foundation

public enum KeyPathPropertyType {
    case String
    case Number
    case Date
    case Time
    case Array
}

public struct KeyPathDescriptor {
    var displayString: String
    var keyPath: String
    var propertyType: KeyPathPropertyType = .String
    
    public init(keyPath: String, displayString: String, propertyType: KeyPathPropertyType){
        self.keyPath = keyPath
        self.displayString = displayString
        self.propertyType = propertyType
    }
}
