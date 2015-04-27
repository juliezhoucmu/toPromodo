//
//  StrikeThroughText.swift
//  toPromodo
//
//  Created by Julie Zhou on 4/24/15.
//  Copyright (c) 2015 Julie Zhou. All rights reserved.
//

import UIKit
import QuartzCore


class StrikeThroughText: UITextField {
    let strikeThroughLayer: CALayer // 子layer,strikeThrough= true是才会显示
    
    var strikeThrough: Bool {
        didSet { //初始化的时候不被调用，之后被外部调用改变值的时候会执行didSet函数体
            strikeThroughLayer.hidden = !strikeThrough
            if strikeThrough {     //只有当strikeThrough被设成true的时候这个函数被调用
                resizeStrikeThrough()
            }
        }
    }
    
    required init(coder aDecorder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    override init(frame: CGRect) {
        strikeThroughLayer = CALayer() //是一个白色背景的layer,只有strikeThrough = true 的时候才被调用
        strikeThroughLayer.backgroundColor = UIColor.blackColor().CGColor //字体是黑色的嘛，所以这条线是也黑色的
        strikeThroughLayer.hidden = true
        strikeThrough = false
        super.init(frame: frame) //非option的property必须在super.init之前赋值
        layer.addSublayer(strikeThroughLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        resizeStrikeThrough()
    }
    
    let kStrikeOutThickness: CGFloat = 2.0

    //只有当strikeThrough被设成true的时候这个函数被调用
    func resizeStrikeThrough() {
        let textSize = text!.sizeWithAttributes([NSFontAttributeName: font])
        // 创造 黑色粗线 框框 -- 字体是黑色的嘛，所以这条线是黑色的
        strikeThroughLayer.frame = CGRect(x: 0, y: bounds.size.height/2, width: textSize.width,height: kStrikeOutThickness)
    }
}
