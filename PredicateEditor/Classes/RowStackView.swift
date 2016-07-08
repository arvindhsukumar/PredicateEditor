//
//  RowStackView.swift
//  PredicateEditor
//
//  Created by Arvindh Sukumar on 07/07/16.
//
//

import UIKit
import SnapKit

protocol RowStackViewDatasource: class {
    func numberOfViews() -> Int
    func viewForItemAtIndex(index: Int) -> UIView
}

public class RowStackView: UIView {
    weak var datasource: RowStackViewDatasource?
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

    func reloadData(){
        for sv in stackView.arrangedSubviews{
            stackView.removeArrangedSubview(sv)
        }

        for i in 0..<(datasource?.numberOfViews() ?? 0) {
            if let view = datasource?.viewForItemAtIndex(i) {
                stackView.addArrangedSubview(view)
            }
        }
    }

}
