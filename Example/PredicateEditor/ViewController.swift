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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let section = Section(title: "Test", keyPaths: [KeyPathDescriptor(keyPath:"name", title: "Name", propertyType: .String)])
        
        let descriptor = KeyPathDescriptor(keyPath: "score", title: "Score", propertyType: KeyPathPropertyType.Number)
        let comparisonType: KeyPathComparisonType = .IsGreaterThan
        let value = 30
        let row = Row(descriptor: descriptor, comparisonType: comparisonType, value: value)
        section.append(row!)
        
        let descriptor2 = KeyPathDescriptor(keyPath: "dob", title: "Date of Birth", propertyType: KeyPathPropertyType.DateTime)
        let comparisonType2: KeyPathComparisonType = .IsAfter
        let value2 = NSDate(timeIntervalSince1970: 321312311)
        let row2 = Row(descriptor: descriptor2, comparisonType: comparisonType2, value: value2)
        section.append(row2!)
        
        let row3 = Row()
        section.append(row3)
        
        let predicateEditorVC = PredicateEditorViewController(sections: [section])
        addChildViewController(predicateEditorVC)
        view.addSubview(predicateEditorVC.view)
        predicateEditorVC.didMoveToParentViewController(self)
        
        predicateEditorVC.view.snp_makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

