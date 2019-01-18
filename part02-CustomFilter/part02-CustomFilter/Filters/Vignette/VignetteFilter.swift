//
//  VignetteFilter.swift
//  part02-CustomFilter
//
//  Created by 詹保成 on 2019/1/18.
//  Copyright © 2019 残无殇. All rights reserved.
//

import UIKit

fileprivate var vignetteKernel: CIColorKernel?

class VignetteFilter: Filter {
    
    var radius: CGFloat = -1
    var alpha: CGFloat = 1.0
    
    override func loadKernel() {
        guard vignetteKernel == nil else {
            return
        }
        let code = kernelCode(for: "Vignette.cikernel")
        vignetteKernel = CIColorKernel.init(source: code)
    }
    
    override func dealInputImage(_ inputImage: CIImage) -> CIImage? {
        let size = inputImage.extent.size
        let center = CIVector(x: size.width / 2, y: size.height / 2)
        let image = vignetteKernel?.apply(extent: inputImage.extent, roiCallback: { (_, rect) -> CGRect in
            return rect
        }, arguments: [inputImage, center, radius, alpha])
        return image
    }
    
}
