//
//  DetailViewController.swift
//  part01-系统滤镜
//
//  Created by 詹保成 on 2018/12/4.
//  Copyright © 2018 残无殇. All rights reserved.
//

import UIKit
import SnapKit
import Hue
import Kingfisher

class DetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        setScrollView()
        setInfoLabel()
        setOfficialImageView()
        setSourceImageView()
        setTargetImageView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = filterName
        setOfficialImage()
        self.outputFilterImage()
    }
    
    var filterName: String?
    
    private let scrollView = UIScrollView.init()
    private let contentView = UIView.init()
    
    private let titleFont = UIFont.boldSystemFont(ofSize: 16)
    private let titleColor = UIColor.init(hex: "#333333")
    
    /// 滤镜的相关信息
    private let infoLabel = UILabel.init()
    
    /// 官方效果图
    private let officialImageView = UIImageView.init()
    
    private let sourceImageView = UIImageView.init()
    private let targetImageView = UIImageView.init()
    
    private func outputFilterImage() {
        guard let image = sourceImageView.image  else {
            return
        }
        DispatchQueue.global().async {
            guard let filterName = self.filterName,
                let ciimage = CIImage.init(image: image),
                let filter = CIFilter.init(name: filterName) else {
                    return
            }
            filter.setValue(ciimage, forKey: kCIInputImageKey)
            self.showFilterInfo(with: filter)
            let context = CIContext.init(options: nil)
            guard let outputImage = filter.outputImage,
                let cgimage = context.createCGImage(outputImage, from: outputImage.extent) else {
                    return
            }
            let img = UIImage.init(cgImage: cgimage)
            DispatchQueue.main.async {
                self.targetImageView.image = img
            }
        }
    }
    
    private func showFilterInfo(with filter: CIFilter) {
        var infoStr = ""
        infoStr.append(contentsOf: "滤镜名: \(filter.name)\n")
        
        let attributes = filter.attributes
        if let displayName = attributes["CIAttributeFilterDisplayName"] as? String {
            infoStr.append(contentsOf: "displayName: \(displayName)\n")
        }
        if let available_Mac = attributes["CIAttributeFilterAvailable_Mac"] /* 最低Mac OS版本 */ {
            infoStr.append(contentsOf: "最低Mac OS版本: \(available_Mac)\n")
        }
        if let available_iOS = attributes["CIAttributeFilterAvailable_iOS"] /* 最低iOS版本 */ {
            infoStr.append(contentsOf: "最低iOS版本: \(available_iOS)\n")
        }
        if let categories = attributes["CIAttributeFilterCategories"] as? [String] {
            let str = categories.joined(separator: ", ")
            infoStr.append(contentsOf: "分类: \(str)\n")
        }
        let inputKeys = filter.inputKeys.joined(separator: ", ")
        let outputKeys = filter.outputKeys.joined(separator: ", ")
        infoStr.append(contentsOf: "输入参数名: \(inputKeys)\n")
        infoStr.append(contentsOf: "输出参数名: \(outputKeys)\n")
        if let referenceDocumentation = attributes["CIAttributeReferenceDocumentation"] /* 文档地址 */ {
            infoStr.append(contentsOf: "文档地址: \(referenceDocumentation)")
        }
        let para = NSMutableParagraphStyle.init()
        para.lineSpacing = 5
        let attr = NSMutableAttributedString.init(string: infoStr)
        attr.addAttribute(.paragraphStyle, value: para, range: .init(location: 0, length: attr.length))
        if Thread.current.isMainThread {
            infoLabel.attributedText = attr
        } else {
            DispatchQueue.main.async {
                self.infoLabel.attributedText = attr
            }
        }
        
    }
}

extension DetailViewController {
    
    private func showAlert(_ message: String) {
        let alert = UIAlertController.init(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "确定", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    private func setScrollView() {
        scrollView.backgroundColor = UIColor.white
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { (maker) in
            maker.left.right.top.bottom.equalTo(0)
        }
        
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { (maker) in
            maker.left.right.top.bottom.equalTo(0)
            maker.width.equalTo(view)
        }
    }
    
    private func setInfoLabel() {
        let infoTitleLabel = UILabel.init()
        infoTitleLabel.font = titleFont
        infoTitleLabel.textColor = titleColor
        infoTitleLabel.text = "滤镜信息"
        contentView.addSubview(infoTitleLabel)
        infoTitleLabel.snp.makeConstraints { (maker) in
            maker.left.top.height.equalTo(20)
            maker.right.equalTo(-20)
        }
        
        infoLabel.font = UIFont.systemFont(ofSize: 14)
        infoLabel.textColor = UIColor.init(hex: "#666666")
        infoLabel.numberOfLines = 0
        contentView.addSubview(infoLabel)
        infoLabel.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(infoTitleLabel)
            maker.top.equalTo(infoTitleLabel.snp.bottom).offset(10)
        }
    }
    
    private func setOfficialImageView() {
        let officialImageTitleLabel = UILabel.init()
        officialImageTitleLabel.font = titleFont
        officialImageTitleLabel.textColor = titleColor
        officialImageTitleLabel.text = "官方效果"
        contentView.addSubview(officialImageTitleLabel)
        officialImageTitleLabel.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(infoLabel)
            maker.top.equalTo(infoLabel.snp.bottom).offset(20)
        }
        
        officialImageView.backgroundColor = UIColor.init(hex: "#F0F0F0")
        contentView.addSubview(officialImageView)
        officialImageView.snp.makeConstraints { (maker) in
            maker.top.equalTo(officialImageTitleLabel.snp.bottom).offset(10)
            maker.left.greaterThanOrEqualTo(officialImageTitleLabel.snp.left)
            maker.right.lessThanOrEqualTo(officialImageTitleLabel.snp.right)
            maker.centerX.equalTo(officialImageTitleLabel.snp.centerX)
            maker.height.equalTo(200)
        }
    }
    
    private func setSourceImageView() {
        let titleLabel = UILabel.init()
        titleLabel.font = titleFont
        titleLabel.textColor = titleColor
        titleLabel.text = "滤镜原图"
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(officialImageView.snp.bottom).offset(20)
            maker.left.right.equalTo(officialImageView)
            maker.height.equalTo(20)
        }
        
        let image = UIImage.init(named: "image_\(arc4random() % 9 + 1).jpeg")
        sourceImageView.backgroundColor = UIColor.init(hex: "#F0F0F0")
        sourceImageView.image = image
        contentView.addSubview(sourceImageView)
        var scale: CGFloat = 1
        if let img = image {
            scale = img.size.height / img.size.width
        }
        sourceImageView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(titleLabel)
            maker.top.equalTo(titleLabel.snp.bottom).offset(10)
            maker.height.equalTo(sourceImageView.snp.width).multipliedBy(scale)
        }
    }
    
    private func setTargetImageView() {
        let titleLabel = UILabel.init()
        titleLabel.font = titleFont
        titleLabel.textColor = titleColor
        titleLabel.text = "滤镜效果图"
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(sourceImageView.snp.bottom).offset(20)
            maker.left.right.equalTo(sourceImageView)
            maker.height.equalTo(20)
        }
        
        targetImageView.backgroundColor = UIColor.init(hex: "#F0F0F0")
        contentView.addSubview(targetImageView)
        targetImageView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(titleLabel)
            maker.top.equalTo(titleLabel.snp.bottom).offset(10)
            maker.height.equalTo(sourceImageView.snp.height)
            maker.bottom.equalTo(-20)
        }
    }
    
}

extension DetailViewController {
    
    private func setOfficialImage() {
        guard let name = filterName else {
            return
        }
        let urlStr = "https://developer.apple.com/library/archive/documentation/GraphicsImaging/Reference/CoreImageFilterReference/Art/\(name)_2x.png"
        guard let url = URL.init(string: urlStr) else {
            return
        }
        let imageResource = ImageResource.init(downloadURL: url)
        officialImageView.kf.setImage(with: imageResource, placeholder: nil, options: nil, progressBlock: { (current, total) in
            
        }) { [weak self](image, error, cacheType, url) in
            if let img = image, var maxWidth = self?.view.frame.width {
                maxWidth -= 40
                let width = img.size.width >= maxWidth ? maxWidth : img.size.width
                let height = width * img.size.height / img.size.width
                self?.officialImageView.snp.updateConstraints({ (maker) in
                    maker.height.equalTo(height)
                })
            } else {
                self?.showAlert("官方图加载失败")
            }
        }
    }
    
}
