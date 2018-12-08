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
        setSettingButton()
        setScrollView()
        setInfoLabel()
        setOfficialImageView()
        setSourceImageView()
        setTargetImageView()
        outputFilterImage()
        setOfficialImage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = filterName
    }
    
    var filterName: String?
    
    /// 滤镜正在处理
    private var isFiltering = false
    private var inputValues = [(key: String, value: Any?)]()
    
    private let scrollView = UIScrollView.init()
    private let contentView = UIView.init()
    
    private let titleFont = UIFont.boldSystemFont(ofSize: 16)
    private let titleColor = UIColor.init(hex: "#333333")
    
    /// 滤镜的相关信息
    private var filterNameLabel = UILabel.init()
    private var filterDisplayNameLabel = UILabel.init()
    private var filterAvailableMacLabel = UILabel.init()
    private var filterAvailableiOSLabel = UILabel.init()
    private var filterCategoriesLabel = UILabel.init()
    private var filterInputKeysLabel = UILabel.init()
    private var filterOutputKeysLabel = UILabel.init()
    private var filterReferenceDocumentationLabel = UILabel.init()
    
    /// 官方效果图
    private let officialImageView = UIImageView.init()
    
    private let sourceImageView = UIImageView.init()
    private let targetImageView = UIImageView.init()
    
    private func outputFilterImage() {
        guard let image = sourceImageView.image  else {
            return
        }
        let inputKeys = inputValues
        DispatchQueue.global().async {
            guard let filterName = self.filterName,
                let ciimage = CIImage.init(image: image),
                let filter = CIFilter.init(name: filterName) else {
                    return
            }
            self.isFiltering = true
            filter.setValue(ciimage, forKey: kCIInputImageKey)
            for item in inputKeys {
                if item.key != kCIInputImageKey {
                    filter.setValue(item.value, forKey: item.key)
                }
            }
            if Thread.current.isMainThread {
                self.showFilterInfo(with: filter);
            } else {
                DispatchQueue.main.async {
                    self.showFilterInfo(with: filter);
                }
            }
            let context = CIContext.init(options: nil)
            guard let outputImage = filter.outputImage,
                let cgimage = context.createCGImage(outputImage, from: outputImage.extent) else {
                    self.isFiltering = false
                    return
            }
            let img = UIImage.init(cgImage: cgimage)
            DispatchQueue.main.async {
                self.targetImageView.image = img
                self.isFiltering = false
            }
        }
    }
    
    private func showFilterInfo(with filter: CIFilter) {
        filterNameLabel.text = filter.name
        
        let attributes = filter.attributes
        if let displayName = attributes["CIAttributeFilterDisplayName"] as? String {
            filterDisplayNameLabel.text = displayName
        }
        if let available_Mac = attributes["CIAttributeFilterAvailable_Mac"] /* 最低Mac OS版本 */ {
            filterAvailableMacLabel.text = "\(available_Mac)"
        }
        if let available_iOS = attributes["CIAttributeFilterAvailable_iOS"] /* 最低iOS版本 */ {
            filterAvailableiOSLabel.text = "\(available_iOS)"
        }
        if let categories = attributes["CIAttributeFilterCategories"] as? [String] {
            filterCategoriesLabel.text = categories.joined(separator: "\n")
        }
        var inputkeys = filter.inputKeys
        inputValues.removeAll()
        inputkeys = inputkeys.map { (key) -> String in
            if key == kCIInputImageKey || key.contains("Image") {
                inputValues.append((key, nil))
                return key
            }
            if let value = filter.value(forKey: key) {
                inputValues.append((key, value))
                return "\(key): \(value)"
            }
            inputValues.append((key, nil))
            return key
        }
        filterInputKeysLabel.text = inputkeys.joined(separator: "\n")
        filterOutputKeysLabel.text = filter.outputKeys.joined(separator: "\n")
        if let referenceDocumentation = attributes["CIAttributeReferenceDocumentation"] /* 文档地址 */ {
            filterReferenceDocumentationLabel.text = "\(referenceDocumentation)"
        }
    }
}

extension DetailViewController {
    
    private func showAlert(_ message: String) {
        let alert = UIAlertController.init(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "确定", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    private func setSettingButton() {
        let settingBtn = UIButton.init(frame: .init(x: 0, y: 0, width: 50, height: 44))
        settingBtn.setTitle("设置", for: .normal)
        settingBtn.setTitleColor(UIColor.init(hex: "#999999"), for: .normal)
        settingBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        settingBtn.addTarget(self, action: #selector(settingButtonClick), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: settingBtn)
    }
    
    @objc private func settingButtonClick() {
        guard !isFiltering else {
            showAlert("滤镜正在处理中")
            return
        }
        guard inputValues.count > 1 else {
            showAlert("没有可以设置的属性")
            return
        }
        let vc = SettingViewController()
        vc.inputValues = inputValues
        vc.saveComplete = { [weak self](values) in
            self?.inputValues = values
            self?.outputFilterImage()
        }
        navigationController?.pushViewController(vc, animated: true)
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
        
        var filterNameTitleLabel = UILabel.init()
        setInfoTitleLabel(&filterNameTitleLabel, title: "滤镜名: ", topView: infoTitleLabel)
        setInfoDescLabel(&filterNameLabel, leftView: filterNameTitleLabel)
        
        var filterDisplayNameTitleLabel = UILabel.init()
        setInfoTitleLabel(&filterDisplayNameTitleLabel, title: "DisplayName: ", topView: filterNameLabel)
        setInfoDescLabel(&filterDisplayNameLabel, leftView: filterDisplayNameTitleLabel)
        
        var filterAvailableMacTitleLabel = UILabel.init()
        setInfoTitleLabel(&filterAvailableMacTitleLabel, title: "最低Mac OS版本: ", topView: filterDisplayNameLabel)
        setInfoDescLabel(&filterAvailableMacLabel, leftView: filterAvailableMacTitleLabel)
        
        var filterAvailableiOSTitleLabel = UILabel.init()
        setInfoTitleLabel(&filterAvailableiOSTitleLabel, title: "最低iOS版本: ", topView: filterAvailableMacLabel)
        setInfoDescLabel(&filterAvailableiOSLabel, leftView: filterAvailableiOSTitleLabel)
        
        var filterCategoriesTitleLabel = UILabel.init()
        setInfoTitleLabel(&filterCategoriesTitleLabel, title: "所属分类: ", topView: filterAvailableiOSLabel)
        setInfoDescLabel(&filterCategoriesLabel, leftView: filterCategoriesTitleLabel)
        
        var filterInputKeysTitleLabel = UILabel.init()
        setInfoTitleLabel(&filterInputKeysTitleLabel, title: "InputKeys: ", topView: filterCategoriesLabel)
        setInfoDescLabel(&filterInputKeysLabel, leftView: filterInputKeysTitleLabel)
        
        var filterOutputKeysTitleLabel = UILabel.init()
        setInfoTitleLabel(&filterOutputKeysTitleLabel, title: "OutputKeys: ", topView: filterInputKeysLabel)
        setInfoDescLabel(&filterOutputKeysLabel, leftView: filterOutputKeysTitleLabel)
        
        var filterReferenceDocumentationTitleLabel = UILabel.init()
        setInfoTitleLabel(&filterReferenceDocumentationTitleLabel, title: "官方文档: ", topView: filterOutputKeysLabel)
        setInfoDescLabel(&filterReferenceDocumentationLabel, leftView: filterReferenceDocumentationTitleLabel)
        filterReferenceDocumentationLabel.isUserInteractionEnabled = true
        filterReferenceDocumentationLabel.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(openDocument)))
    }
    
    private func setInfoTitleLabel(_ label: inout UILabel, title: String, topView: UIView) {
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = UIColor.init(hex: "#333333")
        label.text = title
        contentView.addSubview(label)
        label.snp.makeConstraints { (maker) in
            maker.left.equalTo(20)
            maker.top.equalTo(topView.snp.bottom).offset(5)
            maker.height.equalTo(20)
            maker.width.equalTo(120)
        }
    }
    
    private func setInfoDescLabel(_ label: inout UILabel, leftView: UIView) {
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.init(hex: "#666666")
        label.numberOfLines = 0
        contentView.addSubview(label)
        label.snp.makeConstraints { (maker) in
            maker.left.equalTo(leftView.snp.right).offset(5)
            maker.top.equalTo(leftView)
            maker.right.equalTo(-20)
            maker.height.greaterThanOrEqualTo(leftView.snp.height)
        }
    }
    
    /// 打开官方文档
    @objc private func openDocument() {
        guard let urlStr = filterReferenceDocumentationLabel.text,
            let url = URL.init(string: urlStr),
            UIApplication.shared.canOpenURL(url) else {
                return
        }
        if #available(iOS 10, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    private func setOfficialImageView() {
        let officialImageTitleLabel = UILabel.init()
        officialImageTitleLabel.font = titleFont
        officialImageTitleLabel.textColor = titleColor
        officialImageTitleLabel.text = "官方效果"
        contentView.addSubview(officialImageTitleLabel)
        officialImageTitleLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(20)
            maker.right.equalTo(filterReferenceDocumentationLabel)
            maker.top.equalTo(filterReferenceDocumentationLabel.snp.bottom).offset(20)
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
