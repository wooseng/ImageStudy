//
//  DetailViewController.swift
//  part01-系统滤镜
//
//  Created by 詹保成 on 2018/12/4.
//  Copyright © 2018 残无殇. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        setImageView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = filterName
        DispatchQueue.main.async {
            self.outputFilterImage()
        }
    }
    
    var filterName: String?
    
    private let sourceImageView = UIImageView.init()
    private let targetImageView = UIImageView.init()
    
    private func setImageView() {
        guard let image = UIImage.init(named: "image_\(arc4random() % 9 + 1).jpeg") else {
            return
        }
        let width = view.frame.width - 40
        let height = width * image.size.height / image.size.width
        let top = UIApplication.shared.statusBarFrame.height + (navigationController?.navigationBar.frame.height ?? 0)
        sourceImageView.frame = .init(x: 20, y: top + 20, width: width, height: height)
        targetImageView.frame = .init(x: 20, y: sourceImageView.frame.maxY + 50, width: width, height: height)
        sourceImageView.backgroundColor = UIColor.gray
        targetImageView.backgroundColor = UIColor.gray
        sourceImageView.image = image
        view.addSubview(sourceImageView)
        view.addSubview(targetImageView)
    }
    
    private func outputFilterImage() {
        guard let filterName = filterName,
            let image = sourceImageView.image,
            let ciimage = CIImage.init(image: image),
            let filter = CIFilter.init(name: filterName) else {
            return
        }
        filter.setValue(ciimage, forKey: kCIInputImageKey)
        let context = CIContext.init(options: nil)
        guard let outputImage = filter.outputImage,
            let cgimage = context.createCGImage(outputImage, from: outputImage.extent) else {
            return
        }
        let img = UIImage.init(cgImage: cgimage)
        self.targetImageView.image = img
    }
}
