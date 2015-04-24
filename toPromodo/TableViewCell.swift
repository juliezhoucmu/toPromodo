//
//  TableViewCell.swift
//  toPromodo
//
//  Created by Julie Zhou on 4/24/15.
//  Copyright (c) 2015 Julie Zhou. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    //下面的两个property为pan gesture recognizer 所用
    var originalCenter = CGPoint()
    var deleteOnDragRelease = false //确定该次手势是否需要产生Delete的动作


    //UITableViewCell 继承自UIView， 而UIView conforms to Protocol NSCoding, 所以必须要有一个这样的init函数，这里其实不写这个也没事
    required init(coder aDecoder:NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // 为自定义的cell定义pan手势 recognizer ，实现：右划 delete的动作
        var recognizer = UIPanGestureRecognizer(target:self,action: "handlePan:")
        recognizer.delegate = self //一条龙的自产自销，这一样必须在自己的类里面定义handlePan函数了
        addGestureRecognizer(recognizer) //加到自己身上
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func handlePan(recognizer: UIPanGestureRecognizer) {
        if recognizer.state == .Began {
            originalCenter = center //表示该cell所在view的center
        }
        
        if recognizer.state == .Changed {
            
            let translation = recognizer.translationInView(self)
            center = CGPointMake(originalCenter.x + translation.x, originalCenter.y)
            deleteOnDragRelease  = frame.origin.x < -frame.size.width / 2.0 //左划超过一半才算
        }
        
        if recognizer.state == .Ended {
            let originalFrame = CGRect(x: 0, y: frame.origin.y, width: bounds.size.width, height: bounds.size.height)
            
            if !deleteOnDragRelease { //恢复原状
                UIView.animateWithDuration(0.2, animations: {self.frame = originalFrame})
            }
            
        }
        
        
    }


}
