//
//  SettingViewController.swift
//  part01-SystemFilter
//
//  Created by 詹保成 on 2018/12/8.
//  Copyright © 2018 残无殇. All rights reserved.
//
//  滤镜属性设置
//

import UIKit

class SettingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        title = "设置"
        setSaveButton()
        setMainTableView()
    }

    var inputValues = [(key: String, value: Any?)]()
    
    var saveComplete: (([(key: String, value: Any?)]) -> Void)?
    
    private func setSaveButton() {
        let btn = UIButton.init(frame: .init(x: 0, y: 0, width: 50, height: 44))
        btn.setTitle("保存", for: .normal)
        btn.setTitleColor(UIColor.init(hex: "#999999"), for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.addTarget(self, action: #selector(saveButtonClick), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: btn)
    }
    
    @objc private func saveButtonClick() {
        saveComplete?(inputValues)
        navigationController?.popViewController(animated: true)
    }
    
    private let mainTableView = UITableView.init(frame: .zero, style: .plain)
    
    private func setMainTableView() {
        view.addSubview(mainTableView)
        mainTableView.backgroundColor = UIColor.white
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.estimatedSectionFooterHeight = 0
        mainTableView.estimatedSectionHeaderHeight = 0
        let top = UIApplication.shared.statusBarFrame.height + (navigationController?.navigationBar.frame.height ?? 0)
        mainTableView.snp.makeConstraints { (maker) in
            maker.left.right.bottom.equalTo(0)
            maker.top.equalTo(top)
        }
    }
}

extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inputValues.count
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let value = inputValues[indexPath.row]
        var cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell")
        if cell == nil {
            cell = UITableViewCell.init(style: .value1, reuseIdentifier: "UITableViewCell")
            cell?.textLabel?.font = UIFont.systemFont(ofSize: 14)
            cell?.textLabel?.textColor = UIColor.init(hex: "#333333")
            cell?.selectionStyle = .none
            cell?.detailTextLabel?.font = UIFont.systemFont(ofSize: 14)
            cell?.detailTextLabel?.textColor = UIColor.init(hex: "#666666")
        }
        cell?.textLabel?.text = value.key
        let v = value.value ?? "null"
        cell?.detailTextLabel?.text = "\(v)"
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var setting = inputValues[indexPath.row]
        if let value = setting.value as? Int {
            openSlider(values: [(min: 0, max: 150, current: Float.init(value))]) { [weak self](values) in
                setting.value = Int.init(values.first ?? 0)
                self?.inputValues[indexPath.row] = setting
                self?.mainTableView.reloadData()
            }
        } else if let value = setting.value as? CGFloat {
            openSlider(values: [(min: 0, max: 1, current: Float.init(value))]) { [weak self](values) in
                setting.value = values.first
                self?.inputValues[indexPath.row] = setting
                self?.mainTableView.reloadData()
            }
        } else if let value = setting.value as? CIVector {
            let max: Float = setting.key == kCIInputCenterKey ? 500 : 1
            let values: [(min: Float, max: Float, current: Float)] = [(0, max, Float.init(value.x)),
                                                                      (0, max, Float.init(value.y)),
                                                                      (0, max, Float.init(value.z)),
                                                                      (0, max, Float.init(value.w))]
            openSlider(values: values) { [weak self](value) in
                let v = value.map({ (f) -> CGFloat in
                    return CGFloat.init(f)
                })
                let vector = CIVector.init(x: v[0], y: v[1], z: v[2], w: v[3])
                setting.value = vector
                self?.inputValues[indexPath.row] = setting
                self?.mainTableView.reloadData()
            }
        }
    }
    
    private func openSlider(values: [(min: Float, max: Float, current: Float)], complate: @escaping ([Float]) -> Void) {
        let vc = SettingSilderViewController()
        vc.values = values
        vc.complete = { values in
            complate(values)
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
