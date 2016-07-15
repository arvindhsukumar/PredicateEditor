//
//  RowView.swift
//  Pods
//
//  Created by Arvindh Sukumar on 14/07/16.
//
//

import UIKit
import SnapKit

private let kSideMargin: CGFloat = 16
private let kButtonHeight: CGFloat = 36

private let kButtonTint: UIColor = UIColor(red:0.34, green:0.15, blue:0.43, alpha:1.00)

@objc protocol RowViewDelegate {
    func didTapKeyPathButton(index:Int)
}

class RowView: UIView {
    weak var delegate: RowViewDelegate?
    let inputStackView: UIStackView = {
        let stackView = UIStackView(frame: CGRectZero)
        stackView.axis = .Horizontal
        stackView.distribution = .Fill
        return stackView
    }()
    var stackViewHeightConstraint: Constraint!
    
    let buttonStackView: UIStackView = {
        let stackView = UIStackView(frame: CGRectZero)
        stackView.axis = .Horizontal
        stackView.distribution = .FillProportionally
        return stackView
    }()

    let inputTextField: UITextField = {
        let textField = UITextField(frame: CGRectZero)
        textField.borderStyle = .None
        textField.placeholder = "Value"
        return textField
    }()
    
    let keyPathButton: UIButton = {
        let button = UIButton(type: .Custom)
        button.setContentHuggingPriority(900, forAxis: UILayoutConstraintAxis.Horizontal)
        button.setTitleColor(kButtonTint, forState: UIControlState.Normal)
        return button
    }()
    
    let comparisonButton: UIButton = {
        let button = UIButton(type: .Custom)
        button.setContentHuggingPriority(900, forAxis: UILayoutConstraintAxis.Horizontal)
        button.setTitleColor(kButtonTint, forState: UIControlState.Normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        setContentHuggingPriority(1000, forAxis: UILayoutConstraintAxis.Vertical)
        translatesAutoresizingMaskIntoConstraints = false
        
        keyPathButton.addTarget(self, action: #selector(RowView.didTapKeyPathButton(_:)), forControlEvents: .TouchUpInside)
        addSubview(keyPathButton)
        keyPathButton.snp_makeConstraints { (make) in
            make.left.equalTo(self).offset(kSideMargin)
            make.top.equalTo(self).offset(4)
            make.height.equalTo(kButtonHeight)
        }
        
        addSubview(comparisonButton)
        comparisonButton.snp_makeConstraints { (make) in
            make.left.equalTo(keyPathButton.snp_right).offset(kSideMargin)
            make.right.greaterThanOrEqualTo(self).offset(-kSideMargin).priority(750)
            make.top.equalTo(self).offset(4)
            make.height.equalTo(kButtonHeight)
        }
        
        addSubview(inputStackView)
        inputStackView.snp_makeConstraints { (make) in
            make.left.equalTo(self).offset(kSideMargin)
            make.right.equalTo(self).offset(kSideMargin)
            make.top.equalTo(keyPathButton.snp_bottom).offset(4)
            self.stackViewHeightConstraint = make.height.equalTo(0).constraint
            make.bottom.equalTo(self).offset(-4)
        }
        setupStackView()

    }
    
    func didTapKeyPathButton(sender: AnyObject) {
        delegate?.didTapKeyPathButton(self.tag)
        self.stackViewHeightConstraint.updateOffset(kButtonHeight)
    }
    
    func setupStackView(){
        inputStackView.addArrangedSubview(self.inputTextField)
    }
    
    func configureWithRow(row: Row) {
        keyPathButton.setTitle(row.descriptor?.keyPath ?? "Select", forState: UIControlState.Normal)
        if let descriptor = row.descriptor {
            comparisonButton.setTitle(row.comparisonType?.rawValue ?? "", forState: UIControlState.Normal)
        }
        else {
            comparisonButton.setTitle("", forState: UIControlState.Normal)
        }
    }
}
