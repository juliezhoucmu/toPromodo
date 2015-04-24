//
//  TableViewCell.swift
//  toPromodo
//
//  Created by Julie Zhou on 4/24/15.
//  Copyright (c) 2015 Julie Zhou. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {


    //UITableViewCell 继承自UIView， 而UIView conforms to Protocol NSCoding, 所以必须要有一个这样的init函数，这里其实不写这个也没事
    required init(coder aDecoder:NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
