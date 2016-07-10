//
//  RowStackView.swift
//  PredicateEditor
//
//  Created by Arvindh Sukumar on 07/07/16.
//
//

import UIKit
import SnapKit

public class RowStackView: UIView {
    var stackView: UIStackView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    func setup(){
        self.backgroundColor = UIColor.whiteColor()
        self.setContentHuggingPriority(UILayoutPriorityRequired, forAxis: UILayoutConstraintAxis.Vertical)

        stackView = UIStackView(frame: CGRectZero)
        stackView.backgroundColor = UIColor.blueColor()
        stackView.axis = UILayoutConstraintAxis.Vertical
        stackView.distribution = .FillProportionally
        stackView.alignment = .Fill
        stackView.spacing = 3.0
        stackView.setContentHuggingPriority(UILayoutPriorityRequired, forAxis: UILayoutConstraintAxis.Vertical)
        addSubview(stackView)
        stackView.snp_makeConstraints {
            make in
            make.edges.equalTo(self)
        }
    }
}
