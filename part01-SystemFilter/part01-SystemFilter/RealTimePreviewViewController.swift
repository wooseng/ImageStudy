//
//  RealTimePreviewViewController.swift
//  part01-SystemFilter
//
//  Created by 詹保成 on 2018/12/9.
//  Copyright © 2018 残无殇. All rights reserved.
//
//  实时预览
//

import UIKit

class RealTimePreviewViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        title = defaultTitle
        guard sourceImage != nil, filterName != nil else {
            navigationController?.popViewController(animated: true)
            return
        }
        filter = CIFilter.init(name: filterName)
        
        setImageView()
        setMainTableView()
        reloadData()
        filterQueue.append([:])
        run()
    }
    
    var sourceImage: UIImage!
    
    var filterName: String!
    
    private var filterQueue = [[String: Any?]]()
    private var filter: CIFilter!
    private let mainTableView = UITableView.init(frame: .zero, style: .grouped)
    private let previewImageView = UIImageView.init()
    
    private var dataSource = [(key: String, value: Any?)]()
    
    private var isFiltering = false {
        didSet {
            if Thread.current.isMainThread {
                if isFiltering {
                    title = "\(defaultTitle)[渲染中...]"
                } else {
                    title = defaultTitle
                }
            } else {
                DispatchQueue.main.async {
                    if self.isFiltering {
                        self.title = "\(self.defaultTitle)[渲染中...]"
                    } else {
                        self.title = self.defaultTitle
                    }
                }
            }
        }
    }
    private var isRuning = false
    private let defaultTitle = "滤镜"
    
    /// 将数据源中的属性值添加到滤镜渲染队列中
    private func insertDataToQueue() {
        var values = [String: Any?]()
        for item in dataSource {
            values[item.key] = item.value
        }
        filterQueue.append(values)
    }
    
    /// 刷新列表数据
    private func reloadData() {
        dataSource.removeAll()
        dataSource = filter.inputKeys.map ({ (key) -> (String, Any?) in
            return key.contains("Image") ? (key, nil) : (key, filter.value(forKey: key))
        }).filter({ (item) -> Bool in
            return item.key != kCIInputImageKey
        })
        if Thread.current.isMainThread {
            mainTableView.reloadData()
        } else {
            DispatchQueue.main.async {
                self.mainTableView.reloadData()
            }
        }
    }
    
    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
        if parent == nil {
            isRuning = false
        }
    }
    
    /// 运行滤镜循环渲染
    private func run() {
        isRuning = true
        DispatchQueue.global().async {
            while self.isRuning {
                if self.isFiltering {
                    sleep(1)
                    continue
                }
                guard let values = self.filterQueue.first else {
                    sleep(1)
                    continue
                }
                print("当前线程【\(Thread.current.isMainThread ? "main" : "gload")】")
                self.isFiltering = true
                self.filterQueue.removeFirst()
                guard let outputImage = self.outputFilter(inputValues: values) else {
                    self.isFiltering = false
                    self.reloadData()
                    continue
                }
                DispatchQueue.main.async {
                    self.previewImageView.image = outputImage
                }
                self.reloadData()
                self.isFiltering = false
            }
        }
    }
    
    /// 使用指定的参数进行滤镜渲染
    private func outputFilter(inputValues: [String: Any?]) -> UIImage? {
        guard let inputImage = CIImage.init(image: self.sourceImage) else {
            print("获取inputImage失败")
            return nil
        }
        self.filter.setValue(inputImage, forKey: kCIInputImageKey)
        for (key, value) in inputValues {
            self.filter.setValue(value, forKey: key)
        }
        let context = CIContext.init(options: nil)
        guard let outputCIImage = self.filter.outputImage,
             let outputCGImage = context.createCGImage(outputCIImage, from: outputCIImage.extent) else {
                print("获取输出图片失败")
            return nil
        }
        let outputImage = UIImage.init(cgImage: outputCGImage)
        return outputImage
    }
    
    private func showMessage(_ message: String) {
        let alert = UIAlertController.init(title: "提示", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "确定", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}


extension RealTimePreviewViewController {
    
    private func setImageView() {
        let top = UIApplication.shared.statusBarFrame.height + (navigationController?.navigationBar.frame.height ?? 0) + 10
        let scale = sourceImage.size.height / sourceImage.size.width
        view.addSubview(previewImageView)
        previewImageView.backgroundColor = UIColor.init(hex: "#F0F0F0")
        previewImageView.image = sourceImage
        previewImageView.snp.makeConstraints { (maker) in
            maker.top.equalTo(top)
            maker.left.equalTo(20)
            maker.right.equalTo(-20)
            maker.height.equalTo(previewImageView.snp.width).multipliedBy(scale)
        }
    }
    
    private func setMainTableView() {
        let titleLabel = UILabel.init()
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabel.textColor = UIColor.init(hex: "#333333")
        titleLabel.text = "属性设置"
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(previewImageView)
            maker.top.equalTo(previewImageView.snp.bottom).offset(20)
            maker.height.equalTo(25)
        }
        
        mainTableView.backgroundColor = UIColor.white
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.estimatedSectionFooterHeight = 0
        mainTableView.estimatedSectionHeaderHeight = 0
        view.addSubview(mainTableView)
        mainTableView.snp.makeConstraints { (maker) in
            maker.left.right.bottom.equalTo(0)
            maker.top.equalTo(titleLabel.snp.bottom)
        }
    }
    
}

extension RealTimePreviewViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell.init(style: .value1, reuseIdentifier: "cell")
            cell?.textLabel?.font = UIFont.systemFont(ofSize: 14)
            cell?.detailTextLabel?.font = UIFont.systemFont(ofSize: 14)
            cell?.textLabel?.textColor = UIColor.init(hex: "#333333")
            cell?.detailTextLabel?.textColor = UIColor.init(hex: "#666666")
            cell?.selectionStyle = .none
        }
        let item = dataSource[indexPath.row]
        cell?.textLabel?.text = item.key
        let value = item.value ?? "null"
        cell?.detailTextLabel?.text = "\(value)"
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var item = dataSource[indexPath.row]
        
        switch item.key {
        case kCIInputRadiusKey:
            let intValue = item.value as? Int ?? 0
            let floatValue = Float.init(intValue)
            openSlider(values: [(0, 150, floatValue)]) { [weak self](value) in
                item.value = Int.init(value[0])
                self?.dataSource[indexPath.row] = item
                self?.insertDataToQueue()
            }
        case kCIInputAngleKey:
            let value = item.value as? CGFloat ?? 0
            let floatValue = Float.init(value)
            let max = Float.init(Double.pi * 2)
            openSlider(values: [(0, max, floatValue)]) { [weak self](value) in
                item.value = value[0]
                self?.dataSource[indexPath.row] = item
                self?.insertDataToQueue()
            }
        case "inputNoiseLevel":
            let value = item.value as? CGFloat ?? 0
            let floatValue = Float.init(value)
            openSlider(values: [(0, 1, floatValue)]) { [weak self](value) in
                item.value = value[0]
                self?.dataSource[indexPath.row] = item
                self?.insertDataToQueue()
            }
        case kCIInputSharpnessKey:
            let value = item.value as? CGFloat ?? 0
            let floatValue = Float.init(value)
            openSlider(values: [(0, 1, floatValue)]) { [weak self](value) in
                item.value = value[0]
                self?.dataSource[indexPath.row] = item
                self?.insertDataToQueue()
            }
        case kCIInputAmountKey:
            let intValue = item.value as? Int ?? 0
            let floatValue = Float.init(intValue)
            openSlider(values: [(0, 150, floatValue)]) { [weak self](value) in
                item.value = Int.init(value[0])
                self?.dataSource[indexPath.row] = item
                self?.insertDataToQueue()
            }
        case kCIInputCenterKey:
            let value = item.value as? CIVector ?? CIVector.init(x: 0, y: 0)
            let x = Float.init(value.x)
            let y = Float.init(value.y)
            let maxX = Float.init(previewImageView.frame.width)
            let maxY = Float.init(previewImageView.frame.height)
            openSlider(values: [(0, maxX, x), (0, maxY, y)]) { (values) in
                item.value = CIVector.init(x: CGFloat.init(values[0]), y: CGFloat.init(values[1]))
                self.dataSource[indexPath.row] = item
                self.insertDataToQueue()
            }
        default:
            showMessage("暂不支持属性[\(item.key)]的设置")
        }
    }
    
    private func openSlider(values: [(min: Float, max: Float, current: Float)], didChange: @escaping ([Float]) -> Void) {
        let vc = RealTimePreviewSilderViewController()
        vc.values = values
        vc.complete = { newValue in
            didChange(newValue)
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
