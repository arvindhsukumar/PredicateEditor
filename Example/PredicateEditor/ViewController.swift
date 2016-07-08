//
//  ViewController.swift
//  PredicateEditor
//
//  Created by Arvindh Sukumar on 07/07/2016.
//  Copyright (c) 2016 Arvindh Sukumar. All rights reserved.
//

import UIKit
import PredicateEditor

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let section = Section(title: "Test", keyPaths: [KeyPathDescriptor(keyPath:"name", displayString: "Name", propertyType: .String)])
        let sectionView = SectionView(section: section)
        view.addSubview(sectionView)
        sectionView.snp_makeConstraints { (make) in
            make.top.equalTo(view).inset(4)
            make.left.equalTo(view).inset(4)
            make.right.equalTo(view).inset(4)
        }
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

