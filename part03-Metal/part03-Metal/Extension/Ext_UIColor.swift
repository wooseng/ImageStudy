//
//  Ext_UIColor.swift
//  part03-Metal
//
//  Created by 詹保成 on 2019/1/24.
//  Copyright © 2019 残无殇. All rights reserved.
//

import UIKit

public typealias ColorValue = (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat)

extension UIColor {
    
    /// 获取随机的颜色
    public static func random() -> UIColor {
        let v = randomValue()
        return UIColor(red: v.r, green: v.g, blue: v.b, alpha: v.a)
    }
    
    /// 获取随机的颜色值
    public static func randomValue() -> ColorValue {
        return randomValue(min: 0, max: 1)
    }
    
    public static func randomValue(min: CGFloat, max: CGFloat) -> ColorValue {
        let minInt = UInt32(255.0 * min)
        let maxInt = UInt32(255.0 * max)
        let r = CGFloat(arc4random() % (maxInt - minInt) + minInt) / 255.0
        let g = CGFloat(arc4random() % (maxInt - minInt) + minInt) / 255.0
        let b = CGFloat(arc4random() % (maxInt - minInt) + minInt) / 255.0
        
        let minA = UInt32(11.0 * min)
        let maxA = UInt32(11.0 * max)
        let a = CGFloat(arc4random() % (maxA - minA) + minA) / 10.0
        return (r, g, b, a)
    }
    
}
