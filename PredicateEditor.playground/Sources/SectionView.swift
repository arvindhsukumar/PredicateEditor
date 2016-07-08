//
//  SectionView.swift
//  PredicateEditor
//
//  Created by Arvindh Sukumar on 07/07/16.
//
//

import UIKit
import SnapKit

class SectionView: UIView, RowStackViewDatasource {
    var section: Section
    var titleLabel: UILabel!
    var rowStackView: RowStackView!

    convenience init(section: Section){
        self.init()
        self.section = section
        setup()
    }

    func setup() {
        self.backgroundColor = UIColor(white: 0.7, alpha: 1)

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
    }

    func numberOfViews() -> Int {
        return section.rows.count
    }

    func viewForItemAtIndex(index: Int) -> UIView {
        return nil
    }

}
