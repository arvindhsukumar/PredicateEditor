//
//  PersonListViewController.swift
//  PredicateEditor
//
//  Created by Arvindh Sukumar on 24/07/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit
import Timepiece
import PredicateEditor

class PersonListViewController: UIViewController {
    let tableView: UITableView = {
        let tv = UITableView(frame: CGRectZero, style: UITableViewStyle.Plain)
        tv.registerClass(PersonTableViewCell.self, forCellReuseIdentifier: kPersonCellIdentifier)
        return tv
    }()
    
    var people: [Person] = []
    var filteredPeople: [Person] = []
    
    var predicateEditorVC: PredicateEditorViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPeople()
        setupPredicateEditor()
        setupViews()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Filter", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(PersonListViewController.showPredicateEditor))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showPredicateEditor() {
        let nc = UINavigationController(rootViewController: predicateEditorVC)
        nc.modalTransitionStyle = .CoverVertical
        presentViewController(nc, animated: true, completion: nil)
    }
    
    private func setupViews(){
        tableView.delegate = self
        tableView.dataSource = self
        
        // To enable self-sizing cells using auto-layout
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 60
        
        // To prevent separators for non-content cells
        tableView.tableFooterView = UIView()
        
        view.addSubview(tableView)
        tableView.snp_makeConstraints(closure: { (make) in
            make.edges.equalTo(self.view)
        }) 
        tableView.reloadData()
    }
    
    private func setupPeople() {
        let p1 = Person(name: "John",
                        dateOfBirth: NSDate.date(year: 1980, month: 6, day: 19),
                        appointmentDate: NSDate.date(year: 2016, month: 7, day: 21, hour: 20, minute: 30,second: 0),
                        favoriteColor: "Blue", gender: "Male", isADeveloper: true,
                        heightInCentimeters: 180.5)
        
        let p2 = Person(name: "Angela",
                        dateOfBirth: NSDate.date(year: 1984, month: 2, day: 11),
                        appointmentDate: NSDate.date(year: 2016, month: 8, day: 1, hour: 10, minute: 30,second: 0),
                        favoriteColor: "Green", gender: "Female", isADeveloper: true,
                        heightInCentimeters: 162.1)
        
        let p3 = Person(name: "Mark",
                        dateOfBirth: NSDate.date(year: 1986, month: 4, day: 9),
                        appointmentDate: NSDate.date(year: 2016, month: 9, day: 1, hour: 0, minute: 30,second: 0),
                        favoriteColor: "Blue", gender: "Male", isADeveloper: false,
                        heightInCentimeters: 170.8)
        
        let p4 = Person(name: "Matt",
                        dateOfBirth: NSDate.date(year: 1977, month: 9, day: 8),
                        appointmentDate: NSDate.date(year: 2016, month: 7, day: 25, hour: 12, minute: 0,second: 0),
                        favoriteColor: "Black", gender: "Male", isADeveloper: false,
                        heightInCentimeters: 177.3)
        
        let p5 = Person(name: "Jack",
                        dateOfBirth: NSDate.date(year: 1980, month: 6, day: 19),
                        appointmentDate: NSDate.date(year: 2016, month: 7, day: 22, hour: 14, minute: 45,second: 0),
                        favoriteColor: "Green", gender: "Male", isADeveloper: false,
                        heightInCentimeters: 185.1)
        
        let p6 = Person(name: "Jim",
                        dateOfBirth: NSDate.date(year: 1985, month: 2, day: 15),
                        appointmentDate: NSDate.date(year: 2016, month: 10, day: 3, hour: 13, minute: 15,second: 0),
                        favoriteColor: "Orange", gender: "Male", isADeveloper: false,
                        heightInCentimeters: 180)
        
        let p7 = Person(name: "Hannah",
                        dateOfBirth: NSDate.date(year: 1986, month: 1, day: 10),
                        appointmentDate: NSDate.date(year: 2016, month: 11, day: 25, hour: 9, minute: 0,second: 0),
                        favoriteColor: "Blue", gender: "Female", isADeveloper: true,
                        heightInCentimeters: 171)
        
        let p8 = Person(name: "Alison",
                        dateOfBirth: NSDate.date(year: 1987, month: 6, day: 27),
                        appointmentDate: NSDate.date(year: 2016, month: 12, day: 8, hour: 20, minute: 0,second: 0),
                        favoriteColor: "Black", gender: "Female", isADeveloper: true,
                        heightInCentimeters: 166.4)
        
        let p9 = Person(name: "Gilian",
                        dateOfBirth: NSDate.date(year: 1984, month: 8, day: 5),
                        appointmentDate: NSDate.date(year: 2016, month: 7, day: 31, hour: 10, minute: 40,second: 0),
                        favoriteColor: "Purple", gender: "Female", isADeveloper: false,
                        heightInCentimeters: 175)
        
        let p10 = Person(name: "Sabrina",
                        dateOfBirth: NSDate.date(year: 1990, month: 6, day: 21),
                        appointmentDate: NSDate.date(year: 2016, month: 7, day: 21, hour: 21, minute: 30,second: 0),
                        favoriteColor: "Purple", gender: "Female", isADeveloper: true,
                        heightInCentimeters: 177.4)
        
        people = [p1,p2,p3,p4,p5,p6,p7,p8,p9,p10]
        filteredPeople = people
    }
    
    private func setupPredicateEditor(){
        var keyPaths: [KeyPathDescriptor] = []
        
        let kp1 = KeyPathDescriptor(keyPath:"name", title: "Name", propertyType: .String)
        let kp2 = KeyPathDescriptor(keyPath:"dateOfBirth", title: "Date Of Birth", propertyType: .Date)
        let kp3 = KeyPathDescriptor(keyPath:"age", title: "Age", propertyType: .Int)
        let kp4 = KeyPathDescriptor(keyPath:"appointmentTime", title: "Appointment Time", propertyType: .Time)
        let kp5 = KeyPathDescriptor(keyPath:"appointmentDate", title: "Appointment Date", propertyType: .Date)
        var kp6 = KeyPathDescriptor(keyPath:"gender", title: "Gender", propertyType: .String)
        kp6.enumerationOptions = ["Male","Female"]
        var kp7 = KeyPathDescriptor(keyPath:"favoriteColor", title: "Favorite Color", propertyType: .String)
        kp7.enumerationOptions = ["Blue","Black","Orange","Purple","Green"]
        let kp8 = KeyPathDescriptor(keyPath:"heightInCentimeters", title: "Height in cm", propertyType: .Float)
        let kp9 = KeyPathDescriptor(keyPath:"isADeveloper", title: "Is a Developer", propertyType: .Boolean)


        keyPaths = [kp1, kp2, kp3, kp4, kp5, kp6, kp7, kp8, kp9]
        
        let section = Section(title: "Filter People", keyPaths: keyPaths)

        self.predicateEditorVC = PredicateEditorViewController(sections: [section])
        predicateEditorVC.delegate = self
    }
}

extension PersonListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredPeople.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(kPersonCellIdentifier, forIndexPath: indexPath) as! PersonTableViewCell
        
        let person = filteredPeople[indexPath.row]
        cell.nameLabel.text = person.name
        
        cell.selectionStyle = .None
        
        return cell
    }
}

extension PersonListViewController: PredicateEditorDelegate {
    func predicateEditorDidFinishWithPredicates(predicates: [NSPredicate]) {
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        filteredPeople = (people as NSArray).filteredArrayUsingPredicate(predicates[0]) as! [Person]
        print(filteredPeople.count)
        tableView.reloadData()
    }
}
