//
//  ErrorToastView.swift
//  Pods
//
//  Created by Arvindh Sukumar on 25/07/16.
//
//

import UIKit

class ErrorToastView: UIView {
    let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .Center
        label.numberOfLines = 0
        label.setContentHuggingPriority(1000, forAxis: UILayoutConstraintAxis.Vertical)
        label.textColor = UIColor.whiteColor()
        return label
    }()
    
    convenience init(message: String){
        self.init(frame: CGRectZero)
        label.text = message
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
        
    func commonInit()  {
        setContentHuggingPriority(1000, forAxis: UILayoutConstraintAxis.Vertical)
        addSubview(label)
        label.snp_makeConstraints { (make) in
            make.edges.equalTo(self).inset(10).priority(900)
        }
    }

}
