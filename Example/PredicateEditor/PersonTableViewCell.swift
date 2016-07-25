//
//  PersonTableViewCell.swift
//  PredicateEditor
//
//  Created by Arvindh Sukumar on 24/07/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit

let kPersonCellIdentifier = "PersonCell"

class PersonTableViewCell: UITableViewCell {
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFontOfSize(17)
        label.backgroundColor = UIColor.whiteColor()
        return label
    }()
    
    let detailsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFontOfSize(14)
        label.numberOfLines = 0
        label.textColor = UIColor(white: 0.4, alpha: 1)
        label.backgroundColor = UIColor.whiteColor()
        return label
    }()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    private func setupView(){
        contentView.addSubview(nameLabel)
        nameLabel.snp_makeConstraints { (make) in
            make.left.equalTo(contentView).offset(16)
            make.top.equalTo(contentView).offset(10)
            make.right.equalTo(contentView).offset(-16)
        }
        
        contentView.addSubview(detailsLabel)
        detailsLabel.snp_makeConstraints { (make) in
            make.top.equalTo(nameLabel.snp_bottom).offset(2)
            make.bottom.equalTo(contentView).offset(-10)
            make.right.equalTo(nameLabel)
            make.left.equalTo(nameLabel)
        }
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
