//
//  FilterViewController.swift
//  part02-CustomFilter
//
//  Created by 詹保成 on 2019/1/16.
//  Copyright © 2019 残无殇. All rights reserved.
//

import UIKit

class FilterViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        addSwitchButton()
        setSourceImageView()
        setTargetImageView()
        setStatusLabel()
        showFilterImage()
    }
    
    //MARK: - public
    /**
     对图片进行滤镜处理的方法
     */
    public func dealImage(_ image: CIImage) -> CIImage? {
        fatalError("this method must be overwrite in sub class")
    }
    
    public private(set) var sourceImage: UIImage?
    
    //MARK: - private
    private let sourceImageView = UIImageView.init()
    private let targetImageView = UIImageView.init()
    private let statueLabel = UILabel.init()
    private let switchButton = UIButton.init()
    private let context = CIContext.init(options: nil)
    
    private var isShowTarget = false {
        didSet {
            targetImageView.isHidden = !isShowTarget
            statueLabel.text = isShowTarget ? "效果图" : "原图"
        }
    }
    
}


//MARK: - public
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
}

//MARK: - private
extension FilterViewController {
    
    private func addSwitchButton() {
        switchButton.setTitle("切换", for: .normal)
        switchButton.setTitleColor(UIColor(hex: "#333333"), for: .normal)
        switchButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        switchButton.addTarget(self, action: #selector(switchButtonEvent), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: switchButton)
    }
    
    @objc private func switchButtonEvent() {
        isShowTarget = !isShowTarget
    }
    
    private func setSourceImageView() {
        guard let image = UIImage.init(named: "image_8.jpeg") else {
            return
        }
        sourceImage = image
        sourceImageView.image = image
        sourceImageView.backgroundColor = UIColor.init(hex: "#F0F0F0")
        view.addSubview(sourceImageView)
        let scale = image.size.height / image.size.width
        sourceImageView.snp.makeConstraints { (maker) in
            maker.left.equalTo(20)
            maker.right.equalTo(-20)
            maker.centerY.equalTo(view.snp.centerY)
            maker.height.equalTo(sourceImageView.snp.width).multipliedBy(scale)
        }
    }
    
    private func setTargetImageView() {
        targetImageView.isHidden = true
        targetImageView.backgroundColor = UIColor.init(hex: "#F0F0F0")
        view.addSubview(targetImageView)
        targetImageView.snp.makeConstraints { (maker) in
            maker.left.right.height.centerY.equalTo(sourceImageView)
        }
    }
    
    private func setStatusLabel() {
        statueLabel.textColor = UIColor(hex: "#333333")
        statueLabel.font = UIFont.boldSystemFont(ofSize: 14)
        statueLabel.text = "原图"
        statueLabel.textAlignment = .center
        view.addSubview(statueLabel)
        statueLabel.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(0)
            maker.bottom.equalTo(sourceImageView.snp.top).offset(-20)
        }
    }
}
