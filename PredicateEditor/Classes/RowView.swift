//
//  RowView.swift
//  Pods
//
//  Created by Arvindh Sukumar on 14/07/16.
//
//

import UIKit
import SnapKit

private let kHorizontalMargin: CGFloat = 16
private let kVerticalMargin: CGFloat = 10

private let kButtonHeight: CGFloat = 36

private let kButtonTint: UIColor = UIColor(red:0.34, green:0.15, blue:0.43, alpha:1.00)

@objc protocol RowViewDelegate {
    func didTapKeyPathButton(index:Int)
    func didTapComparisonButton(index:Int)
}

class RowView: UIView {
    weak var delegate: RowViewDelegate?
    let inputStackView: UIStackView = {
        let stackView = UIStackView(frame: CGRectZero)
        stackView.axis = .Horizontal
        stackView.distribution = .EqualSpacing
        return stackView
    }()
    var stackViewHeightConstraint: Constraint!
    var stackViewBottomMarginConstraint: Constraint!
    
    let buttonStackView: UIStackView = {
        let stackView = UIStackView(frame: CGRectZero)
        stackView.axis = .Horizontal
        stackView.distribution = .FillProportionally
        stackView.spacing = 8
        return stackView
    }()

    let inputTextField: UITextField = {
        let textField = UITextField(frame: CGRectZero)
        textField.borderStyle = .None
        textField.placeholder = "Value"
        return textField
    }()
    
    let inputPicker: UIButton = {
        let button = UIButton(type: .Custom)
        button.setContentHuggingPriority(900, forAxis: UILayoutConstraintAxis.Horizontal)
        button.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        button.contentHorizontalAlignment = .Left
        button.setTitle("Picker!", forState: UIControlState.Normal)
        return button
    }()
    
    let keyPathButton: UIButton = {
        let button = UIButton(type: .Custom)
        button.setContentHuggingPriority(901, forAxis: UILayoutConstraintAxis.Horizontal)
        button.setTitleColor(kButtonTint, forState: UIControlState.Normal)
        return button
    }()
    
    let comparisonButton: UIButton = {
        let button = UIButton(type: .Custom)
        button.setContentHuggingPriority(900, forAxis: UILayoutConstraintAxis.Horizontal)
        button.setTitleColor(UIColor.magentaColor(), forState: UIControlState.Normal)
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
        comparisonButton.addTarget(self, action: #selector(RowView.didTapComparisonButton(_:)), forControlEvents: .TouchUpInside)

        addSubview(buttonStackView)
        setupButtonStackView()
        buttonStackView.snp_makeConstraints { (make) in
            make.left.equalTo(self).offset(kHorizontalMargin)
            make.right.equalTo(self).offset(-kHorizontalMargin).priority(990)
            make.top.equalTo(self).offset(kVerticalMargin)
            make.height.equalTo(28)
        }
                
        addSubview(inputStackView)
        inputStackView.snp_makeConstraints { (make) in
            make.left.equalTo(self).offset(kHorizontalMargin)
            make.right.equalTo(self).offset(-kHorizontalMargin).priority(990)
            make.top.equalTo(buttonStackView.snp_bottom).offset(0)
            self.stackViewHeightConstraint = make.height.equalTo(0).constraint
            self.stackViewBottomMarginConstraint = make.bottom.equalTo(self).offset(-kVerticalMargin).constraint
        }

    }
    
    func didTapKeyPathButton(sender: AnyObject) {
        delegate?.didTapKeyPathButton(self.tag)
    }
    
    func didTapComparisonButton(sender: AnyObject) {
        delegate?.didTapComparisonButton(self.tag)
    }
    
    func setupButtonStackView() {
        buttonStackView.addArrangedSubview(keyPathButton)
        buttonStackView.addArrangedSubview(comparisonButton)
    }
    func setupStackView(){
        inputStackView.addArrangedSubview(self.inputTextField)
    }
    
    func configureWithRow(row: Row) {
        keyPathButton.setTitle(row.descriptor?.title ?? "Select", forState: UIControlState.Normal)
        
        if let descriptor = row.descriptor {
            showInputView()
            inputStackView.removeAllArrangedSubviews()
            if descriptor.propertyType.inputType() == .Text {
                inputStackView.addArrangedSubview(inputTextField)
            }
            else {
                inputStackView.addArrangedSubview(inputPicker)
            }
            
            let comparisonType = row.comparisonType ?? descriptor.propertyType.comparisonTypes().first            
            comparisonButton.setTitle(comparisonType?.rawValue ?? "", forState: UIControlState.Normal)
        }
        else {
            hideInputView()
            comparisonButton.setTitle("", forState: UIControlState.Normal)
        }
        
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    private func hideInputView(){
        self.stackViewHeightConstraint.updateOffset(0)
    }
    
    private func showInputView(){
        self.stackViewHeightConstraint.updateOffset(kButtonHeight)
    }
}
