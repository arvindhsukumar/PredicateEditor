//
//  RowView.swift
//  Pods
//
//  Created by Arvindh Sukumar on 14/07/16.
//
//

import UIKit
import SnapKit

let kHorizontalMargin: CGFloat = 16
let kVerticalMargin: CGFloat = 6

private let kButtonHeight: CGFloat = 36

private let kButtonTint: UIColor = UIColor(red:0.34, green:0.15, blue:0.43, alpha:1.00)
private let kFontSize: CGFloat = 18

protocol RowViewDelegate: class {
    func didTapKeyPathButtonInRowView(rowView:RowView)
    func didTapComparisonButtonInRowView(rowView:RowView)
    func didTapInputButtonInRowView(rowView:RowView)
    func didTapDeleteButtonInRowView(rowView:RowView)
    func inputValueChangedInRowView(rowView: RowView, value: String?)
}

class RowView: UIView {
    weak var delegate: RowViewDelegate?
    var config: PredicatorEditorConfig = PredicatorEditorConfig() {
        didSet {
            configureViews()
        }
    }
    let inputStackView: UIStackView = {
        let stackView = UIStackView(frame: CGRectZero)
        stackView.axis = .Horizontal
        stackView.distribution = .EqualSpacing
        return stackView
    }()
    var stackViewHeightConstraint: Constraint!
    var stackViewBottomMarginConstraint: Constraint!
    
    let deleteButton: UIButton = {
        let button = UIButton(type: .Custom)
        button.setContentHuggingPriority(900, forAxis: UILayoutConstraintAxis.Horizontal)
        let image = UIImage(named: "delete", inBundle: NSBundle(forClass:RowView.self), compatibleWithTraitCollection: nil)?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        button.setImage(image, forState: UIControlState.Normal)
        button.tintColor = UIColor(white: 0.7, alpha: 1)
        return button
    }()
    
    let buttonStackView: UIStackView = {
        let stackView = UIStackView(frame: CGRectZero)
        stackView.axis = .Horizontal
        stackView.distribution = .Fill
        stackView.spacing = 8
        stackView.clipsToBounds = true
        return stackView
    }()

    let inputTextField: UITextField = {
        let textField = UITextField(frame: CGRectZero)
        textField.borderStyle = .None
        textField.placeholder = "Value"
        textField.font = UIFont.systemFontOfSize(kFontSize)
        return textField
    }()
    
    let inputPicker: UIButton = {
        let button = UIButton(type: .Custom)
        button.setContentHuggingPriority(900, forAxis: UILayoutConstraintAxis.Horizontal)
        button.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        button.contentHorizontalAlignment = .Left
        button.setTitle("Picker!", forState: UIControlState.Normal)
        button.titleLabel?.font = UIFont.systemFontOfSize(kFontSize)
        return button
    }()
    
    let keyPathButton: UIButton = {
        let button = UIButton(type: .Custom)
        button.setContentHuggingPriority(901, forAxis: UILayoutConstraintAxis.Horizontal)
        button.setContentCompressionResistancePriority(900, forAxis: UILayoutConstraintAxis.Horizontal)
        button.contentHorizontalAlignment = .Left
        button.setTitleColor(kButtonTint, forState: UIControlState.Normal)
        button.titleLabel?.font = UIFont.systemFontOfSize(kFontSize)
        return button
    }()
    
    let comparisonButton: UIButton = {
        let button = UIButton(type: .Custom)
        button.setContentHuggingPriority(500, forAxis: UILayoutConstraintAxis.Horizontal)
        button.setContentCompressionResistancePriority(500, forAxis: UILayoutConstraintAxis.Horizontal)
        button.clipsToBounds = true
        button.titleLabel?.lineBreakMode = .ByTruncatingTail;
        button.contentHorizontalAlignment = .Left
        button.setTitleColor(UIColor.magentaColor(), forState: UIControlState.Normal)
        button.titleLabel?.font = UIFont.systemFontOfSize(kFontSize)
        return button
    }()
    
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.9, alpha: 1)
        return view
    }()
    
    let inputAccessory: UIToolbar = {
        let toolbar = UIToolbar(frame: CGRectMake(0,0,0,44))
        toolbar.translucent = true
        return toolbar
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
        
        configureViews()
        
        keyPathButton.addTarget(self, action: #selector(RowView.didTapKeyPathButton(_:)), forControlEvents: .TouchUpInside)
        comparisonButton.addTarget(self, action: #selector(RowView.didTapComparisonButton(_:)), forControlEvents: .TouchUpInside)

        let resignTextFieldButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: #selector(RowView.resignTextFieldResponder))
        let flexiSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        inputAccessory.setItems([flexiSpace, resignTextFieldButton], animated: false)
        
        inputTextField.addTarget(self, action: #selector(RowView.inputTextFieldValueChanged(_:)), forControlEvents: .EditingChanged)
        inputTextField.inputAccessoryView = inputAccessory
        inputPicker.addTarget(self, action: #selector(RowView.didTapInputPickerButton(_:)), forControlEvents: .TouchUpInside)

        let containerView = UIView()
        containerView.setContentHuggingPriority(1000, forAxis: .Vertical)
        addSubview(containerView)
        containerView.snp_makeConstraints { (make) in
            make.left.equalTo(kHorizontalMargin)
            make.top.equalTo(kVerticalMargin)
            make.bottom.equalTo(-kVerticalMargin)
        }
        
        containerView.addSubview(buttonStackView)
        setupButtonStackView()
        buttonStackView.snp_makeConstraints { (make) in
            make.left.equalTo(containerView)
            make.top.equalTo(containerView)
            make.height.equalTo(28)
            make.right.equalTo(containerView).priority(1000)
        }
        
        containerView.addSubview(inputStackView)
        inputStackView.snp_makeConstraints { (make) in
            make.left.equalTo(containerView)
            make.right.equalTo(containerView)
            make.top.equalTo(buttonStackView.snp_bottom).offset(0)
            self.stackViewHeightConstraint = make.height.equalTo(0).constraint
            self.stackViewBottomMarginConstraint = make.bottom.equalTo(containerView).constraint
        }
        
        addSubview(separatorView)
        separatorView.snp_makeConstraints { (make) in
            make.left.equalTo(self).offset(15).priority(990)
            make.right.equalTo(self)
            make.bottom.equalTo(self)
            make.height.equalTo(1)
        }
        
        deleteButton.addTarget(self, action: #selector(RowView.didTapDeleteButton(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        addSubview(deleteButton)
        deleteButton.snp_makeConstraints { (make) in
            make.width.equalTo(24)
            make.height.equalTo(24)
            make.centerY.equalTo(containerView)
            make.right.equalTo(self).offset(-8).priority(990)
            make.left.equalTo(containerView.snp_right).priority(989)
        }

    }
    
    func configureViews() {
        inputTextField.textColor = config.inputColor
        inputPicker.setTitleColor(config.inputColor, forState: UIControlState.Normal)
        keyPathButton.setTitleColor(config.keyPathDisplayColor, forState: UIControlState.Normal)
        comparisonButton.setTitleColor(config.comparisonButtonColor, forState: UIControlState.Normal)
    }
    
    func didTapKeyPathButton(sender: AnyObject) {
        delegate?.didTapKeyPathButtonInRowView(self)
    }
    
    func didTapComparisonButton(sender: AnyObject) {
        delegate?.didTapComparisonButtonInRowView(self)
    }
    
    func inputTextFieldValueChanged(sender: UITextField) {
        delegate?.inputValueChangedInRowView(self, value: sender.text)
    }
    
    func didTapInputPickerButton(sender: UIButton) {
        delegate?.didTapInputButtonInRowView(self)
    }
    
    func didTapDeleteButton(sender: UIButton) {
        delegate?.didTapDeleteButtonInRowView(self)
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
            
            if descriptor.inputType() == .Picker || descriptor.enumerationOptions.count > 0 {
                inputStackView.addArrangedSubview(inputPicker)
                let title = row.stringValue ?? "Select Option"
                inputPicker.setTitle(title, forState: .Normal)
            }
            else {
                inputStackView.addArrangedSubview(inputTextField)
                inputTextField.keyboardType = descriptor.keyboardType()
                inputTextField.text = row.stringValue
            }
                        
            let comparisonType = row.comparisonType
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
    
    func resignTextFieldResponder() {
        inputTextField.resignFirstResponder()
    }
}

extension RowView: UITextFieldDelegate {
    
}
