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

public class SectionView: UIView, RowStackViewDatasource {
    var section: Section!
    var titleLabel: UILabel!
    var rowStackView: RowStackView!

    convenience public init(section: Section){
        self.init(frame: CGRectZero)
        self.section = section
        setup()
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func setup() {
        self.backgroundColor = UIColor(white: 0.9, alpha: 1)
        self.setContentHuggingPriority(UILayoutPriorityRequired, forAxis: UILayoutConstraintAxis.Vertical)
        
        titleLabel = UILabel()
        titleLabel.font = UIFont.systemFontOfSize(17)
        titleLabel.text = section.title
        addSubview(titleLabel)
        titleLabel.snp_makeConstraints {
            make in
            make.left.equalTo(self)
            make.right.equalTo(self)
            make.top.equalTo(self)
            make.height.equalTo(44)
        }

        rowStackView = RowStackView()
        rowStackView.datasource = self
        addSubview(rowStackView)
        rowStackView.snp_makeConstraints {
            make in
            make.top.equalTo(titleLabel.snp_bottom).offset(4)
            make.left.equalTo(self).offset(4)
            make.right.equalTo(self).offset(-4)
            make.bottom.equalTo(self).offset(-4)
        }
        
        rowStackView.reloadData()
    }

    func numberOfViews() -> Int {
        return 2
    }

    func viewForItemAtIndex(index: Int) -> UIView {
        let view = UIView(frame: CGRectMake(0,0,200,100))
        view.translatesAutoresizingMaskIntoConstraints = false
        let label = UILabel()
        label.text = "Item \(index)"
        view.addSubview(label)
        label.snp_makeConstraints { (make) in
            make.edges.equalTo(view).inset(10).priority(990)
        }
        view.backgroundColor = UIColor.redColor()

        return view
    }

}
