//
//  PixellateFilterViewController.swift
//  part02-CustomFilter
//
//  Created by 詹保成 on 2019/1/19.
//  Copyright © 2019 残无殇. All rights reserved.
//

import UIKit

class PixellateFilterViewController: FilterViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setRadiusSlider()
        title = "像素化"
    }
 
    private let filter = PixellateFilter()
    
    override func dealImage(_ image: CIImage) -> CIImage? {
        filter.setValue(image, forKey: kCIInputImageKey)
        filter.radius = radius
        return filter.outputImage
    }
    
    private var radius: CGFloat = 1
    
    private let radiusSlider = UISlider.init()
 
    private func setRadiusSlider() {
        view.addSubview(radiusSlider)
        radiusSlider.minimumValue = 1
        radiusSlider.maximumValue = 100
        radiusSlider.addTarget(self, action: #selector(radiusSliderDidValueChange), for: .valueChanged)
        radiusSlider.snp.makeConstraints { (maker) in
            maker.left.equalTo(20)
            maker.right.equalTo(-20)
            maker.bottom.equalTo(-20)
            maker.height.equalTo(40)
        }
    }
    
    @objc private func radiusSliderDidValueChange() {
        radius = CGFloat(radiusSlider.value)
        startDealImage(isChainEnable: false)
    }
    
}
