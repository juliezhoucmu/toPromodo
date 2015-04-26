//
//  TableViewCell.swift
//  toPromodo
//
//  Created by Julie Zhou on 4/24/15.
//  Copyright (c) 2015 Julie Zhou. All rights reserved.
//

import UIKit

protocol TableViewCellDelegate {
    func toDoItemDeleted(todoItem: ToDoItem)
}

class TableViewCell: UITableViewCell {
    
    //下面的两个property为pan gesture recognizer 所用
    var originalCenter = CGPoint()
    var deleteOnDragRelease = false //确定该次手势是否需要产生Delete的动作
    var completeOnDragRelease = false //确定该次手势是否需要产生Complete的动作
    
    let label: StrikeThroughText
    var itemCompleteLayer = CALayer()
    
    var delegate: TableViewCellDelegate? //需要派一个间谍，但是现在还不知道间谍是谁
    var toDoItem: ToDoItem? {//同步更新cell背后的label，如果这个item已经complete了，就让它显示出来
        didSet {
            label.text = toDoItem!.text //label的文字和cell的文字重叠显示
            label.strikeThrough = toDoItem!.completed
            itemCompleteLayer.hidden = !label.strikeThrough
        }
    }


    //UITableViewCell 继承自UIView， 而UIView conforms to Protocol NSCoding, 所以必须要有一个这样的init函数，这里其实不写这个也没事
    required init(coder aDecoder:NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        label = StrikeThroughText(frame: CGRect.nullRect)
        label.textColor = UIColor.blackColor()
        label.backgroundColor = UIColor.clearColor()
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(label)
        selectionStyle = .None
        
        
        // 给label再加一个sublayer，是它文字的绿色背景
        // 不过一开始的时候先hidden
        itemCompleteLayer = CALayer(layer: layer) // init from copy this cell's layer,layer不包括text
        itemCompleteLayer.backgroundColor = UIColor(red: 0.2, green: 0.8, blue: 0.2, alpha: 1.0).CGColor
        itemCompleteLayer.hidden = true
        layer.insertSublayer(itemCompleteLayer, atIndex: 0)
        
        // 为自定义的cell定义pan手势 recognizer ，实现：左划 delete的动作， 右划 complete的动作
        var recognizer = UIPanGestureRecognizer(target:self,action: "handlePan:")
        recognizer.delegate = self //一条龙的自产自销，这一样必须在自己的类里面定义handlePan函数
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
            completeOnDragRelease = frame.origin.x > frame.size.width / 2.0 //右划超过一半才算
        }
        
        if recognizer.state == .Ended {
            let originalFrame = CGRect(x: 0, y: frame.origin.y, width: bounds.size.width, height: bounds.size.height)
            
            if !deleteOnDragRelease && !completeOnDragRelease { //左划右划都不生效，就恢复原状
                UIView.animateWithDuration(0.2, animations: {self.frame = originalFrame})
            }
                
            else if deleteOnDragRelease { //删除对应的数据
                if delegate != nil && toDoItem != nil {
                    delegate!.toDoItemDeleted(toDoItem!)
                }
            }
            else if completeOnDragRelease {
                if toDoItem != nil {
                    toDoItem!.completed  = true
                }
                label.strikeThrough = true
                itemCompleteLayer.hidden = false
                UIView.animateWithDuration(0.2, animations: {self.frame = originalFrame})
            }
        }
    }
    
    
    //加上下面这个限定条件：只有横向划动才能激活这个手势，竖着划没用
    override func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let panGestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer {
            let translation = panGestureRecognizer.translationInView(superview!)
            if fabs(translation.x) > fabs(translation.y) {
                return true;
            }
            return false;
        }
        return false;
    }
    
    let kLabelLeftMargin: CGFloat = 15.0
    override func layoutSubviews() {
        super.layoutSubviews()
        itemCompleteLayer.frame = bounds //绿色背景层的大小跟cell保持一致
        label.frame = CGRect(x: kLabelLeftMargin, y: 0, width: bounds.size.width - kLabelLeftMargin, height: bounds.size.height) //label文字层需要缩进，而itemCompleteLayer是颜色层，需要沾满整行

    }
}
