//
//  MosaicFilter.swift
//  part02-CustomFilter
//
//  Created by 詹保成 on 2019/1/19.
//  Copyright © 2019 残无殇. All rights reserved.
//

import UIKit

fileprivate var mosaicKernel: CIKernel?

class MosaicFilter: Filter {
    
    var maskImage: CIImage?
    var touchPoint: CGPoint?
    var radius: CGFloat = 10

    override func loadKernel() {
        guard mosaicKernel == nil else {
            return
        }
        let code = kernelCode(for: "Mosaic.cikernel")
        mosaicKernel = CIKernel.init(source: code)
    }
    
    override func dealInputImage(_ inputImage: CIImage) -> CIImage? {
        guard let maskImage = maskImage, let touchPoint = touchPoint else {
            return nil
        }
        let point = CIVector(x: touchPoint.x, y: inputImage.extent.height - touchPoint.y)
        let result = mosaicKernel?.apply(extent: inputImage.extent, roiCallback: { (_, rect) -> CGRect in
            return rect
        }, arguments: [inputImage, maskImage, point, radius, maskImage.extent.width, maskImage.extent.height])
        return result
    }
    
}
