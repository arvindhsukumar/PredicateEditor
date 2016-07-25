//
//  DatePickerViewController.swift
//  Pods
//
//  Created by Arvindh Sukumar on 18/07/16.
//
//

import UIKit

protocol DatePickerDelegate: class {
    func datePickerDidSelectDate(row: Row, date: NSDate, datePickerMode: UIDatePickerMode)
}

class DatePickerViewController: UIViewController {
    weak var delegate: DatePickerDelegate?
    var row: Row!
    var date: NSDate?
    var datePickerMode: UIDatePickerMode = .Date
    let datePicker: UIDatePicker = {
        let dp = UIDatePicker(frame: CGRectZero)
        dp.timeZone = NSTimeZone.defaultTimeZone()
        dp.backgroundColor = UIColor.whiteColor()
        dp.setContentCompressionResistancePriority(1000, forAxis: .Vertical)
        return dp
    }()
    
    let toolBar: UIToolbar = {
        let toolbar = UIToolbar(frame: CGRectZero)
        toolbar.translucent = false
        toolbar.backgroundColor = UIColor.whiteColor()
        return toolbar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(DatePickerViewController.close(_:)))
        tapGR.delegate = self
        view.addGestureRecognizer(tapGR)
        setupDatePicker()
        setupToolbar()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupDatePicker() {
        datePicker.datePickerMode = datePickerMode
        if let date = date {
            datePicker.setDate(date, animated: false)
        }
        view.addSubview(datePicker)
        datePicker.snp_makeConstraints { (make) in
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.bottom.equalTo(view)
        }
    }
    
    func setupToolbar() {
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: #selector(DatePickerViewController.doneButtonTapped(_:)))
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: self, action: #selector(DatePickerViewController.cancelButtonTapped(_:)))

        let flexiSpace = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: self, action: nil)
        
        toolBar.setItems([cancelButton, flexiSpace, doneButton], animated: false)
        view.addSubview(toolBar)
        toolBar.snp_makeConstraints { (make) in
            make.height.equalTo(44)
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.bottom.equalTo(datePicker.snp_top)
        }
    }
    
    func close(sender: UITapGestureRecognizer) {
        if sender.state == .Recognized {
            dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func doneButtonTapped(sender:UIBarButtonItem) {
        delegate?.datePickerDidSelectDate(row, date:
            datePicker.date, datePickerMode: datePickerMode)
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func cancelButtonTapped(sender:UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}

extension DatePickerViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        return touch.view == view
    }
}


