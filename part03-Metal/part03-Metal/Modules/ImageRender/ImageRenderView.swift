//
//  ImageRenderView.swift
//  part03-Metal
//
//  Created by 詹保成 on 2019/1/27.
//  Copyright © 2019 残无殇. All rights reserved.
//

import UIKit

class ImageRenderView: BaseMetalView {

    var image: UIImage? {
        didSet {
            setupBuffer()
            newTexture()
        }
    }
    
    private var texture: MTLTexture?
    private var vertexBuffer: MTLBuffer?
    
    private func newTexture() {
        guard let imageRef = image?.cgImage else {
            return
        }
        let (width, height) = (imageRef.width, imageRef.height)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let rawData = calloc(height * width * 4, MemoryLayout<UInt8>.size)
        let bytesPerPixel = 4
        let bytesPerRow = bytesPerPixel * width
        let bitsPerComponent = 8
        let bitmapContext = CGContext(data: rawData,
                                      width: width,
                                      height: height,
                                      bitsPerComponent: bitsPerComponent,
                                      bytesPerRow: bytesPerRow,
                                      space: colorSpace,
                                      bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Big.rawValue)
        bitmapContext?.draw(imageRef, in: .init(x: 0, y: 0, width: CGFloat(width), height: CGFloat(height)))
        let textureDesc = MTLTextureDescriptor.texture2DDescriptor(pixelFormat: .rgba8Unorm, width: width, height: height, mipmapped: false)
        texture = device?.makeTexture(descriptor: textureDesc)
        let region = MTLRegionMake2D(0, 0, width, height)
        guard let tempRawData = bitmapContext?.data else {
            return
        }
        texture?.replace(region: region, mipmapLevel: 0, withBytes: tempRawData, bytesPerRow: bytesPerRow)
        free(tempRawData)
    }
    
    
    override func render() {
        guard let drawable = metalLayer.nextDrawable() else {
            return
        }
        let desc = MTLRenderPassDescriptor.init()
        let colorAttachment = desc.colorAttachments[0]
        colorAttachment?.texture = drawable.texture
        
        let commandQueue = device?.makeCommandQueue()
        let commandBuffer = commandQueue?.makeCommandBuffer()
        let commandEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: desc)
        
        if let state = getPipelineState() {
            commandEncoder?.setRenderPipelineState(state)
        }
        commandEncoder?.setFragmentTexture(texture, index: 0)
        commandEncoder?.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        commandEncoder?.drawPrimitives(type: .triangleStrip, vertexStart: 0, vertexCount: 4)
        
        commandEncoder?.endEncoding()
        commandBuffer?.present(drawable)
        commandBuffer?.commit()
    }
    
    
    private func getPipelineState() -> MTLRenderPipelineState? {
        guard let library = device?.makeDefaultLibrary(),
            let vertexFunction = library.makeFunction(name: "imageRenderVertexShader"),
            let fragmentFunction = library.makeFunction(name: "imageRenderFragmentShader") else {
                return nil
        }
        let desc = MTLRenderPipelineDescriptor.init()
        desc.colorAttachments[0].pixelFormat = metalLayer.pixelFormat
        desc.vertexFunction = vertexFunction
        desc.fragmentFunction = fragmentFunction
        do {
            let state = try device?.makeRenderPipelineState(descriptor: desc)
            return state
        } catch {
            fatalError("make render pipeline state failed")
        }
        return nil
    }
    
    
    private func setupBuffer() {
        let vertices = [ImageRenderVertex(position: [-1.0, -1.0], textureCoordinate: [0, 1.0]),
                        ImageRenderVertex(position: [-1.0, 1.0], textureCoordinate: [0, 0]),
                        ImageRenderVertex(position: [1.0, -1.0], textureCoordinate: [1.0, 1.0]),
                        ImageRenderVertex(position: [1.0, 1.0], textureCoordinate: [1.0, 0])]
        let length = MemoryLayout<ImageRenderVertex>.size * vertices.count
        vertexBuffer = device?.makeBuffer(bytes: vertices, length: length, options: .cpuCacheModeWriteCombined)
    }

}
