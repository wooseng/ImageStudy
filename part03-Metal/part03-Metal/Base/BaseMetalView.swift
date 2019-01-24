//
//  BaseMetalView.swift
//  part03-Metal
//
//  Created by 詹保成 on 2019/1/24.
//  Copyright © 2019 残无殇. All rights reserved.
//
//  自定义实现支持Metal渲染的基础视图
//

import UIKit

class BaseMetalView: UIView {

    public let device = MTLCreateSystemDefaultDevice()
    
    var metalLayer: CAMetalLayer {
        return layer as! CAMetalLayer
    }
    
    override class var layerClass : AnyClass {
        return CAMetalLayer.self
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if metalLayer.drawableSize != frame.size {
            metalLayer.drawableSize = frame.size
        }
    }

}
