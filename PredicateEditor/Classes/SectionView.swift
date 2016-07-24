//
//  SectionView.swift
//  PredicateEditor
//
//  Created by Arvindh Sukumar on 07/07/16.
//
//

import UIKit
import SnapKit
import StackViewController

protocol SectionViewDelegate: class {
    func sectionViewWillInsertRow()
    func sectionViewChooseCompoundPredicateType()
}

protocol SectionViewDataSource: class {
    func sectionViewCompoundPredicateType() -> SectionPredicateType
    func sectionViewTitle() -> String
    func sectionViewNumberOfRows() -> Int
    func sectionViewRowForItemAtIndex(index: Int) -> UIView
}

public class SectionView: UIView {
    weak var delegate: SectionViewDelegate?
    weak var dataSource: SectionViewDataSource?
    var config: PredicatorEditorConfig = PredicatorEditorConfig() {
        didSet {
            configureViews()
        }
    }
    let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFontOfSize(20)
        titleLabel.textColor = UIColor(white: 0.2, alpha: 1)
        return titleLabel
    }()
    
    let compoundPredicateTypeButton: UIButton = {
        let button = UIButton(type: .Custom)
        button.setContentHuggingPriority(900, forAxis: UILayoutConstraintAxis.Horizontal)
        button.backgroundColor = UIColor.whiteColor()
        button.contentHorizontalAlignment = .Left
        button.setTitle("Any or All?", forState: UIControlState.Normal)
        return button
    }()
    
    let rowStackView: UIStackView = {
        let rowStackView = UIStackView(frame: CGRectZero)
        rowStackView.backgroundColor = UIColor.blueColor()
        rowStackView.axis = UILayoutConstraintAxis.Vertical
        rowStackView.distribution = .FillProportionally
        rowStackView.alignment = .Fill
        rowStackView.spacing = 3.0
        rowStackView.setContentHuggingPriority(UILayoutPriorityRequired, forAxis: UILayoutConstraintAxis.Vertical)
        return rowStackView
    }()
    
    var rowViews: [Int: UIView] = [:]
    
    let newRowView: UIView = {
        let view = UIView(frame: CGRectZero)
        view.backgroundColor = UIColor.whiteColor()
        
        let button = UIButton(type: UIButtonType.Custom)
        button.contentHorizontalAlignment = .Left
        button.setTitle("Add Filter", forState: UIControlState.Normal)
        
        view.addSubview(button)
        button.snp_makeConstraints(closure: { (make) in
            make.left.equalTo(view).offset(kHorizontalMargin)
            make.right.equalTo(view).offset(-kHorizontalMargin).priority(990)
            make.top.equalTo(view).offset(kVerticalMargin)
            make.bottom.equalTo(view).offset(-kVerticalMargin)
            make.height.equalTo(28)
        })
        
        return view
    }()
    
    var newRowButton: UIButton {
        return newRowView.subviews.filter({ $0 is UIButton}).first as! UIButton
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        self.setContentHuggingPriority(UILayoutPriorityRequired, forAxis: UILayoutConstraintAxis.Vertical)
        newRowButton.addTarget(self, action: #selector(SectionView.addNewRow(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        titleLabel.text = dataSource?.sectionViewTitle()
        addSubview(titleLabel)
        titleLabel.snp_makeConstraints {
            make in
            make.left.equalTo(self).offset(10)
            make.right.equalTo(self).offset(-10)
            make.top.equalTo(self)
            make.height.equalTo(44)
        }
        
        let predicateTypeButtonContainer = UIView(frame: CGRectZero)
        predicateTypeButtonContainer.backgroundColor = UIColor.whiteColor()
        predicateTypeButtonContainer.layer.borderColor = UIColor(white: 0.95, alpha: 1).CGColor
        predicateTypeButtonContainer.layer.borderWidth = 1
        predicateTypeButtonContainer.layer.cornerRadius = 4
        predicateTypeButtonContainer.clipsToBounds = true
        
        addSubview(predicateTypeButtonContainer)
        predicateTypeButtonContainer.snp_makeConstraints {
            make in
            make.top.equalTo(titleLabel.snp_bottom).offset(4)
            make.left.equalTo(self).offset(10)
            make.right.equalTo(self).offset(-10)
            make.height.equalTo(44)
        }
        
        compoundPredicateTypeButton.addTarget(self, action: #selector(SectionView.didTapCompoundPredicateTypeButton(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        predicateTypeButtonContainer.addSubview(compoundPredicateTypeButton)
        compoundPredicateTypeButton.snp_makeConstraints {
            make in
            make.top.equalTo(predicateTypeButtonContainer)
            make.left.equalTo(predicateTypeButtonContainer).offset(16)
            make.right.equalTo(predicateTypeButtonContainer).offset(-16)
            make.bottom.equalTo(predicateTypeButtonContainer)
        }

        let rowViewContainer = UIView(frame: CGRectZero)
        rowViewContainer.backgroundColor = UIColor.whiteColor()
        rowViewContainer.layer.borderColor = UIColor(white: 0.95, alpha: 1).CGColor
        rowViewContainer.layer.borderWidth = 1
        rowViewContainer.layer.cornerRadius = 4
        rowViewContainer.clipsToBounds = true

        addSubview(rowViewContainer)
        rowViewContainer.snp_makeConstraints {
            make in
            make.top.equalTo(predicateTypeButtonContainer.snp_bottom).offset(4)
            make.left.equalTo(self).offset(10)
            make.right.equalTo(self).offset(-10)
            make.bottom.equalTo(self).offset(-10)
        }
        rowViewContainer.addSubview(rowStackView)
        rowStackView.snp_makeConstraints {
            make in
            make.edges.equalTo(rowViewContainer)
        }
        
        reloadCompoundPredicateButton()
        reloadData()
    }
    
    func configureViews() {
        backgroundColor = config.sectionBackgroundColor
        newRowButton.setTitleColor(config.keyPathDisplayColor, forState: UIControlState.Normal)
        compoundPredicateTypeButton.setTitleColor(config.comparisonButtonColor, forState: UIControlState.Normal)
    }
    
    func didTapCompoundPredicateTypeButton(sender: UIButton) {
        delegate?.sectionViewChooseCompoundPredicateType()
    }

    func reloadCompoundPredicateButton() {
        let predicateType = dataSource?.sectionViewCompoundPredicateType() ?? SectionPredicateType.OR
        let title = predicateType == .OR ? "Any of the following are true" : "All of the following are true"
        compoundPredicateTypeButton.setTitle(title, forState: UIControlState.Normal)
    }
    
    func reloadData(){
        titleLabel.text = dataSource?.sectionViewTitle()
        rowStackView.removeAllArrangedSubviews()

        for i in 0..<(dataSource?.sectionViewNumberOfRows() ?? 0) {
            if let view = dataSource?.sectionViewRowForItemAtIndex(i) {
                rowStackView.addArrangedSubview(view)
                rowViews[i] = view
            }
        }
        rowStackView.addArrangedSubview(newRowView)
    }
    
    func reloadItemAtIndex(index: Int) {
        print("there are \(rowViews.count) rows")
        if index >= rowViews.count {
            return
        }        
        rowViews[index] = dataSource?.sectionViewRowForItemAtIndex(index)
    }
    
    func indexOfRowView(rowView: RowView) -> Int? {
        for (i,r) in rowViews {
            if r == rowView {
                return i
            }
        }
        return nil
    }
}

extension SectionView {
    func addNewRow(sender: UIButton) {
        delegate?.sectionViewWillInsertRow()
    }
    
    func insertRowView() {
        let insertIndex = rowViews.count
        if let rowViewToInsert = dataSource?.sectionViewRowForItemAtIndex(insertIndex) {
            rowViews[insertIndex] = rowViewToInsert
            rowStackView.insertArrangedSubview(rowViewToInsert, atIndex: insertIndex)
        }
    }
    
    func removeAllRowViews() {
        rowStackView.arrangedSubviews.forEach {
            if $0 != newRowView{
                $0.removeFromSuperview()
            }
        }
    }
}