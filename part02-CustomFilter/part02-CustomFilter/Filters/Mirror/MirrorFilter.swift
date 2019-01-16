//
//  MirrorFilter.swift
//  part02-CustomFilter
//
//  Created by 詹保成 on 2019/1/16.
//  Copyright © 2019 残无殇. All rights reserved.
//

import UIKit

fileprivate var mirrorKernel: CIWarpKernel?

class MirrorFilter: Filter {
    
    override func dealInputImage(_ inputImage: CIImage) -> CIImage? {
        let width = inputImage.extent.width
        let height = inputImage.extent.height
        let result = mirrorKernel?.apply(extent: inputImage.extent, roiCallback: { (index, rect) -> CGRect in
            return rect
        }, image: inputImage, arguments: [width, height])
        
        return result
    }
    
    private var type = MirrorFilterType.center
    
    override func loadKernel() {
        guard mirrorKernel == nil else {
            return
        }
        let kernelStr = kernelCode(for: "Mirror.cikernel")
        guard let kernels = CIWarpKernel.makeKernels(source: kernelStr), kernels.count == 3 else {
            fatalError("load mirror kernel failed")
        }
        switch type {
        case .x:
            mirrorKernel = kernels[0] as? CIWarpKernel // 沿X轴翻转
        case .y:
            mirrorKernel = kernels[1] as? CIWarpKernel // 沿Y轴翻转
        case .center:
            mirrorKernel = kernels[2] as? CIWarpKernel // 沿中心翻转
        }
    }
}

fileprivate enum MirrorFilterType {
    case x
    case y
    case center
}
