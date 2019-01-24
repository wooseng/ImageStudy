//
//  TriangleView.swift
//  part03-Metal
//
//  Created by 詹保成 on 2019/1/24.
//  Copyright © 2019 残无殇. All rights reserved.
//

import UIKit
import simd

class TriangleView: BaseMetalView {
    
    enum PeakPosition {
        case top, bottom, left, right
        case leftTop, rightTop
        case leftBottom, rightBottom
        case center
    }
    
    override func render() {
        render(peak1: .top, peak2: .leftBottom, peak3: .rightBottom)
    }

    private var pipelineStatus: MTLRenderPipelineState?
    
    public func render(peak1: PeakPosition, peak2: PeakPosition, peak3: PeakPosition) {
        guard let drawable = metalLayer.nextDrawable(),
            let library = device?.makeDefaultLibrary(),
            let vertexFunction = library.makeFunction(name: "vertexShader"),
            let fragmentFunction = library.makeFunction(name: "fragmentShader") else {
                return
        }
        
        let pipelineDesc = MTLRenderPipelineDescriptor()
        pipelineDesc.vertexFunction = vertexFunction
        pipelineDesc.fragmentFunction = fragmentFunction
        
        pipelineDesc.colorAttachments[0].pixelFormat = metalLayer.pixelFormat
        
        do {
            pipelineStatus = try device?.makeRenderPipelineState(descriptor: pipelineDesc)
        } catch {
            fatalError("make render pipeline state failed")
        }
        
        let desc = MTLRenderPassDescriptor.init()
        let color = UIColor.randomValue(min: 0.8, max: 1)
        let colorAttachment = desc.colorAttachments[0]
        colorAttachment?.clearColor = MTLClearColorMake(color.r.double, color.g.double, color.b.double, color.a.double)
        colorAttachment?.loadAction = .clear
        colorAttachment?.storeAction = .store
        colorAttachment?.texture = drawable.texture
        
        let commandQueue = device?.makeCommandQueue()
        let commandBuffer = commandQueue?.makeCommandBuffer()
        let commandEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: desc)
        if let status = pipelineStatus {
            commandEncoder?.setRenderPipelineState(status)
        }
        let vertices = [TriangleVertex(position: position(in: peak1), color: randomColor()),
                        TriangleVertex(position: position(in: peak2), color: randomColor()),
                        TriangleVertex(position: position(in: peak3), color: randomColor())]
        let length = MemoryLayout<TriangleVertex>.size * 3
        commandEncoder?.setVertexBytes(vertices, length: length, index: 0)
        commandEncoder?.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: 3)
        
        commandEncoder?.endEncoding()
        commandBuffer?.present(drawable)
        commandBuffer?.commit()
    }
    
}


extension TriangleView {
    
    private func randomColor() -> vector_float4 {
        let v = UIColor.randomValue()
        return .init(v.r.float, v.g.float, v.b.float, v.a.float)
    }
    
    private func position(in position: PeakPosition) -> vector_float2 {
        switch position {
        case .left:
            return .init(x: -1, y: 0)
        case .right:
            return .init(x: 1, y: 0)
        case .top:
            return .init(x: 0, y: 1)
        case .bottom:
            return .init(x: 0, y: -1)
        case .leftTop:
            return .init(x: -1, y: 1)
        case .rightTop:
            return .init(x: 1, y: 1)
        case .leftBottom:
            return .init(x: -1, y: -1)
        case .rightBottom:
            return .init(x: 1, y: -1)
        case .center:
            return .init(x: 0, y: 0)
        }
    }
    
}



