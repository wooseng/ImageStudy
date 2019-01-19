//
//  PixellateFilter.swift
//  part02-CustomFilter
//
//  Created by 詹保成 on 2019/1/19.
//  Copyright © 2019 残无殇. All rights reserved.
//

import UIKit

fileprivate var pixellateKernel: CIWarpKernel?

class PixellateFilter: Filter {

    var radius: CGFloat = 1
    
    override func loadKernel() {
        guard pixellateKernel == nil else {
            return
        }
        let code = kernelCode(for: "Pixellate.cikernel")
        pixellateKernel = CIWarpKernel.init(source: code)
    }
    
    override func dealInputImage(_ inputImage: CIImage) -> CIImage? {
        let result = pixellateKernel?.apply(extent: inputImage.extent, roiCallback: { (_, rect) -> CGRect in
            return rect
        }, image: inputImage, arguments: [radius])
        return result
    }
    
}
