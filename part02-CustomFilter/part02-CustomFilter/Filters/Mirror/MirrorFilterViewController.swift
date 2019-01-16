//
//  MirrorFilterViewController.swift
//  part02-CustomFilter
//
//  Created by 詹保成 on 2019/1/16.
//  Copyright © 2019 残无殇. All rights reserved.
//

import UIKit

class MirrorFilterViewController: FilterViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "图片翻转"
    }

    override func dealImage(_ image: CIImage) -> CIImage? {
        let filter = MirrorFilter.init()
        filter.setValue(image, forKey: kCIInputImageKey)
        
        return filter.outputImage
    }
    
}
