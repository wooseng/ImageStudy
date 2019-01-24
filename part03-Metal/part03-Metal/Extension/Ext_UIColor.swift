//
//  Ext_UIColor.swift
//  part03-Metal
//
//  Created by 詹保成 on 2019/1/24.
//  Copyright © 2019 残无殇. All rights reserved.
//

import UIKit

extension UIColor {
    
    public static func random() -> UIColor {
        let r = CGFloat(arc4random() % 255) / 255.0
        let g = CGFloat(arc4random() % 255) / 255.0
        let b = CGFloat(arc4random() % 255) / 255.0
        let a = CGFloat(arc4random() % 11) / 10.0
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
    
    public var r: CGFloat {
        return redComponent
    }
    
    public var g: CGFloat {
        return greenComponent
    }
    
    public var b: CGFloat {
        return blueComponent
    }
    
    public var a: CGFloat {
        return alphaComponent
    }
    
}
