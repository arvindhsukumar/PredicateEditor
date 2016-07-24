//
//  ViewController.swift
//  PredicateEditor
//
//  Created by Arvindh Sukumar on 07/07/2016.
//  Copyright (c) 2016 Arvindh Sukumar. All rights reserved.
//

import UIKit
import PredicateEditor
import StackViewController

class ViewController: UIViewController {
    var predicateEditor: PredicateEditorViewController!
    
    @IBAction func generatePredicate(sender: AnyObject) {
        try? predicateEditor.predicates()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let section = createSection()
        let section2 = createSection()
        createRows(inSection: section)
        createRows(inSection: section2)
        
        predicateEditor = PredicateEditorViewController(sections: [section, section2])
        addChildViewController(predicateEditor)
        view.addSubview(predicateEditor.view)
        predicateEditor.didMoveToParentViewController(self)
        
        predicateEditor.view.snp_makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func createSection() -> Section {
        var keyPaths: [KeyPathDescriptor] = []
        
        let kp1 = KeyPathDescriptor(keyPath:"name", title: "Name", propertyType: .Float)
        let kp2 = KeyPathDescriptor(keyPath:"dob", title: "Date Of Birth", propertyType: .Date)
        let kp3 = KeyPathDescriptor(keyPath:"isFunny", title: "Is Funny", propertyType: .Boolean)
        keyPaths = [kp1, kp2, kp3]
        
        let section = Section(title: "Test", keyPaths: keyPaths)
        return section
    }
    
    private func createRows(inSection section: Section) {
        let descriptor = KeyPathDescriptor(keyPath: "name", title: "Name", propertyType: KeyPathPropertyType.Float)
        let comparisonType: KeyPathComparisonType = .IsLessThanOrEqualTo
        let value = 2.24
        let row = Row(descriptor: descriptor, comparisonType: comparisonType, value: value)
        section.append(row!)
        
        let descriptor2 = KeyPathDescriptor(keyPath: "dob", title: "Date of Birth", propertyType: KeyPathPropertyType.Time)
        let comparisonType2: KeyPathComparisonType = .IsAfter
        let value2 = NSDate(timeIntervalSince1970: 321312311)
        let row2 = Row(descriptor: descriptor2, comparisonType: comparisonType2, value: value2)
        section.append(row2!)
        
        let descriptor3 = KeyPathDescriptor(keyPath: "isFunny", title: "Is Funny", propertyType: KeyPathPropertyType.Boolean)
        let comparisonType3: KeyPathComparisonType = .Is
        let value3 = false
        let row3 = Row(descriptor: descriptor3, comparisonType: comparisonType3, value: value3)
//        section.append(row3!)
        
        var descriptor4 = KeyPathDescriptor(keyPath: "designation", title: "Designation", propertyType: KeyPathPropertyType.String)
        descriptor4.enumerationOptions = ["SE", "SSE"]
        let comparisonType4: KeyPathComparisonType = .Is
        let value4 = "SSE"
        let row4 = Row(descriptor: descriptor4, comparisonType: comparisonType4, value: nil)
        section.append(row4!)
        
        let descriptor5 = KeyPathDescriptor(keyPath: "createdAt", title: "Born At", propertyType: KeyPathPropertyType.DateTime)
        let comparisonType5: KeyPathComparisonType = .IsAfter
        let row5 = Row(descriptor: descriptor5, comparisonType: comparisonType5, value: nil)
        section.append(row5!)
    }

}

