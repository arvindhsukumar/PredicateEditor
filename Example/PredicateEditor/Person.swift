//
//  Person.swift
//  PredicateEditor
//
//  Created by Arvindh Sukumar on 24/07/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

class Person: NSObject {
    var name: String!
    var age: Int {
        return NSDate().year - dateOfBirth.year
    }
    var dateOfBirth: NSDate!
    var appointmentTime: NSDate {
        return appointmentDate
    }
    var appointmentDate: NSDate!
    var favoriteColor: String!
    var gender: String!
    var isADeveloper: Bool = false
    var heightInCentimeters: Float = 0
    
    init(name: String, dateOfBirth:NSDate, appointmentDate: NSDate, favoriteColor: String, gender: String, isADeveloper: Bool, heightInCentimeters: Float){
        super.init()
        self.name = name
        self.dateOfBirth = dateOfBirth
        self.appointmentDate = appointmentDate
        self.favoriteColor = favoriteColor
        self.gender = gender
        self.isADeveloper = isADeveloper
        self.heightInCentimeters = heightInCentimeters
    }
}