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
        let section = Section(title: "Test", keyPaths: [KeyPathDescriptor(keyPath:"name", displayString: "Name", propertyType: .String)])
        
        let descriptor = KeyPathDescriptor(keyPath: "score", displayString: "Score", propertyType: KeyPathPropertyType.Number)
        let comparisonType: KeyPathComparisonType = .IsGreaterThan
        let value = 30
        let row = Row(descriptor: descriptor, comparisonType: comparisonType, value: value)
        section.append(row!)
        
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

