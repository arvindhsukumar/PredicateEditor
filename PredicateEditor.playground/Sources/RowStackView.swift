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

class RowStackView: UIView {
    weak var datasource: RowStackViewDatasource?
    var stackView: UIStackView!

    override init(){
        super.init()
        setup()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    override init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    func setup(){
        stackView = UIStackView()
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
        
    }

}
