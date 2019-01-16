//
//  FilterViewController.swift
//  part02-CustomFilter
//
//  Created by 詹保成 on 2019/1/16.
//  Copyright © 2019 残无殇. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        setSourceImageView()
        setTargetImageView()
        showFilterImage()
    }
    
    /**
     对图片进行滤镜处理的方法
     */
    public func dealImage(_ image: CIImage) -> CIImage? {
        fatalError("this method must be overwrite in sub class")
    }
    
    private let sourceImageView = UIImageView.init()
    private let targetImageView = UIImageView.init()
    
    private let context = CIContext.init(options: nil)
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        showFilterImage()
    }
}


extension FilterViewController {
    
    public func showFilterImage() {
        guard let image = sourceImageView.image,
            let inputImage = CIImage.init(image: image),
            let outputImage = dealImage(inputImage),
            let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else {
                return
        }
        let resultImage = UIImage.init(cgImage: cgImage)
        targetImageView.image = resultImage
    }
    
    private func setSourceImageView() {
        guard let image = UIImage.init(named: "image_8.jpeg") else {
            return
        }
        
        let top = UIApplication.shared.statusBarFrame.height + (navigationController?.navigationBar.frame.height ?? 0) + 20
        let titleLabel = getTitleLabel(with: "原图")
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(20)
            maker.right.equalTo(-20)
            maker.top.equalTo(top)
        }
        
        sourceImageView.image = image
        sourceImageView.backgroundColor = UIColor.init(hex: "#F0F0F0")
        view.addSubview(sourceImageView)
        let scale = image.size.height / image.size.width
        sourceImageView.snp.makeConstraints { (maker) in
            maker.left.equalTo(20)
            maker.right.equalTo(-20)
            maker.top.equalTo(titleLabel.snp.bottom).offset(10)
            maker.height.equalTo(sourceImageView.snp.width).multipliedBy(scale)
        }
    }
    
    private func setTargetImageView() {
        let titleLabel = getTitleLabel(with: "效果图")
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(20)
            maker.right.equalTo(-20)
            maker.top.equalTo(sourceImageView.snp.bottom).offset(50)
        }
        
        targetImageView.backgroundColor = UIColor.init(hex: "#F0F0F0")
        view.addSubview(targetImageView)
        targetImageView.snp.makeConstraints { (maker) in
            maker.left.right.height.equalTo(sourceImageView)
            maker.top.equalTo(titleLabel.snp.bottom).offset(10)
        }
    }
    
    private func getTitleLabel(with title: String) -> UILabel {
        let titleLabel = UILabel.init()
        titleLabel.text = title
        titleLabel.font = UIFont.boldSystemFont(ofSize: 14)
        titleLabel.textColor = UIColor.init(hex: "#333333")
        titleLabel.textAlignment = .center
        return titleLabel
    }
}
