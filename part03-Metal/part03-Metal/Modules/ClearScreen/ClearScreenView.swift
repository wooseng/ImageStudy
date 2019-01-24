//
//  ClearScreenView.swift
//  part03-Metal
//
//  Created by 詹保成 on 2019/1/23.
//  Copyright © 2019 残无殇. All rights reserved.
//

import UIKit

class ClearScreenView: UIView {
    
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
    
    public func render() {
        guard let drawable = metalLayer.nextDrawable() else {
            return
        }
        let desc = MTLRenderPassDescriptor.init()
        let colorAttachment = desc.colorAttachments[0]
        let color = UIColor.random()
        colorAttachment?.clearColor = MTLClearColorMake(color.r.double, color.g.double, color.b.double, color.a.double)
        colorAttachment?.texture = drawable.texture
        colorAttachment?.loadAction = .clear
        colorAttachment?.storeAction = .store
        
        let commandQueue = device?.makeCommandQueue()
        let commandBuffer = commandQueue?.makeCommandBuffer()
        let commandEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: desc)
        commandEncoder?.endEncoding()
        commandBuffer?.present(drawable)
        commandBuffer?.commit()
    }
    
}
