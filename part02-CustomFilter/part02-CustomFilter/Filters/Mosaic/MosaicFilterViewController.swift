//
//  MosaicFilterViewController.swift
//  part02-CustomFilter
//
//  Created by 詹保成 on 2019/1/19.
//  Copyright © 2019 残无殇. All rights reserved.
//

import UIKit

class MosaicFilterViewController: FilterViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let image = UIImage.init(named: "image_4.jpeg") {
            maskImage = CIImage(image: image)
        }
    }
    
    private let filter = MosaicFilter()
    
    private var maskImage: CIImage?
    private var touchPoint: CGPoint?
    
    override func dealImage(_ image: CIImage) -> CIImage? {
        if maskImage == nil {
            return image
        }
        filter.setValue(image, forKey: kCIInputImageKey)
        filter.radius = 50
        filter.maskImage = maskImage
        filter.touchPoint = touchPoint
        return filter.outputImage
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let location = touches.first?.location(in: view),
            targetImageView.frame.contains(location),
            let imageSize = targetImageView.image?.size else {
                return
        }
        let point = view.convert(location, to: targetImageView)
        let x = imageSize.width * point.x / targetImageView.frame.width
        let y = imageSize.height * point.y / targetImageView.frame.height
        touchPoint = CGPoint(x: x, y: y)
        startDealImage(isChainEnable: true)
    }
    
}
