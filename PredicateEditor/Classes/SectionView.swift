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

@objc protocol SectionViewDelegate {

}

@objc protocol SectionViewDataSource {
    func sectionViewTitle() -> String
    func sectionViewNumberOfRows() -> Int
    func sectionViewRowForItemAtIndex(index: Int) -> UIView
}

public class SectionView: UIView {
    weak var delegate: SectionViewDelegate?
    weak var dataSource: SectionViewDataSource?
    var titleLabel: UILabel!
    var rowStackView: UIStackView!

    override public init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func setup() {
        self.backgroundColor = UIColor(white: 0.9, alpha: 1)
        self.setContentHuggingPriority(UILayoutPriorityRequired, forAxis: UILayoutConstraintAxis.Vertical)
        
        titleLabel = UILabel()
        titleLabel.font = UIFont.systemFontOfSize(17)
        titleLabel.text = dataSource?.sectionViewTitle()
        addSubview(titleLabel)
        titleLabel.snp_makeConstraints {
            make in
            make.left.equalTo(self)
            make.right.equalTo(self)
            make.top.equalTo(self)
            make.height.equalTo(44)
        }

        rowStackView = UIStackView(frame: CGRectZero)
        rowStackView = UIStackView(frame: CGRectZero)
        rowStackView.backgroundColor = UIColor.blueColor()
        rowStackView.axis = UILayoutConstraintAxis.Vertical
        rowStackView.distribution = .FillProportionally
        rowStackView.alignment = .Fill
        rowStackView.spacing = 3.0
        rowStackView.setContentHuggingPriority(UILayoutPriorityRequired, forAxis: UILayoutConstraintAxis.Vertical)
        addSubview(rowStackView)
        rowStackView.snp_makeConstraints {
            make in
            make.top.equalTo(titleLabel.snp_bottom).offset(4)
            make.left.equalTo(self).offset(4)
            make.right.equalTo(self).offset(-4)
            make.bottom.equalTo(self).offset(-4)
        }
        
        reloadData()
    }

    func reloadData(){
        titleLabel.text = dataSource?.sectionViewTitle()
        for sv in rowStackView.arrangedSubviews{
            rowStackView.removeArrangedSubview(sv)
        }

        for i in 0..<(dataSource?.sectionViewNumberOfRows() ?? 0) {
            if let view = dataSource?.sectionViewRowForItemAtIndex(i) {
                rowStackView.addArrangedSubview(view)
            }
        }
    }
}
