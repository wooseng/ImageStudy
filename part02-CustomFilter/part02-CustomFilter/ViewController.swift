//
//  ViewController.swift
//  part02-CustomFilter
//
//  Created by 詹保成 on 2019/1/16.
//  Copyright © 2019 残无殇. All rights reserved.
//

import UIKit
import SnapKit
import Hue

class ViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "自定义滤镜"
        setTableView()
    }
    
    private let tableView = UITableView.init(frame: .zero, style: .grouped)
    
    private var dataSource: [FilterType] = [.mirror, .vignette, .pixellate, .mosaic]
}

extension ViewController {
    
    private func setTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.white
        tableView.estimatedSectionFooterHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        let top = UIApplication.shared.statusBarFrame.height + (navigationController?.navigationBar.frame.height ?? 0)
        tableView.snp.makeConstraints { (maker) in
            maker.left.right.bottom.equalTo(0)
            maker.top.equalTo(top)
        }
    }
    
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.font = UIFont.systemFont(ofSize: 14)
        cell.textLabel?.textColor = UIColor.init(hex: "#333333")
        cell.textLabel?.text = dataSource[indexPath.row].rawValue
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let type = dataSource[indexPath.row]
        switch type {
        case .mirror:
            navigationController?.pushViewController(MirrorFilterViewController(), animated: true)
        case .vignette:
            navigationController?.pushViewController(VignetteFilterViewController(), animated: true)
        case .pixellate:
            navigationController?.pushViewController(PixellateFilterViewController(), animated: true)
        case .mosaic:
            navigationController?.pushViewController(MosaicFilterViewController(), animated: true)
        }
    }
}

fileprivate enum FilterType: String {
    case mirror = "图像翻转，可沿X轴、Y轴、中心点翻转"
    case vignette = "图像光晕"
    case pixellate = "像素化"
    case mosaic = "马赛克"
}
