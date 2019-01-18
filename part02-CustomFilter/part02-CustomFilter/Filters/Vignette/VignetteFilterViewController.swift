//
//  VignetteFilterViewController.swift
//  part02-CustomFilter
//
//  Created by 詹保成 on 2019/1/18.
//  Copyright © 2019 残无殇. All rights reserved.
//

import UIKit

class VignetteFilterViewController: FilterViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setRadiusSlider()
    }

    private var radius: Float = -1
    
    private let filter = VignetteFilter()
    
    override func dealImage(_ image: CIImage) -> CIImage? {
        filter.setValue(image, forKey: kCIInputImageKey)
        if radius < 0 {
            filter.radius = image.extent.width / 2
        } else {
            filter.radius = CGFloat(radius)
        }
        return filter.outputImage
    }
    
    private let radiusSlider = UISlider.init()
    
}

extension VignetteFilterViewController {
    
    private func setRadiusSlider() {
        view.addSubview(radiusSlider)
        radiusSlider.minimumValue = 0
        radiusSlider.maximumValue = Float(sourceImage?.size.width ?? 100)
        radiusSlider.addTarget(self, action: #selector(radiusSliderDidValueChange), for: .valueChanged)
        radiusSlider.snp.makeConstraints { (maker) in
            maker.left.equalTo(20)
            maker.right.equalTo(-20)
            maker.bottom.equalTo(-20)
            maker.height.equalTo(40)
        }
    }
    
    @objc private func radiusSliderDidValueChange() {
        radius = radiusSlider.maximumValue - radiusSlider.value
        showFilterImage()
    }
    
}
