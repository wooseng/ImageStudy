//
//  BaseTableViewController.swift
//  part03-Metal
//
//  Created by 詹保成 on 2019/1/23.
//  Copyright © 2019 残无殇. All rights reserved.
//

import UIKit

class BaseTableViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
    }
    
    public let tableView = UITableView(frame: .zero, style: .plain)

    public var dataSource = [BaseTableDataSource]()
    
    public func didSelected(_ obj: BaseTableDataSource) {
        fatalError("this method must be override")
    }
}


extension BaseTableViewController {
    
    private  func setTableView() {
        view.addSubview(tableView)
        tableView.backgroundColor = UIColor.white
        tableView.delegate = self
        tableView.dataSource = self
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


extension BaseTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = dataSource[indexPath.row].displayTitle
        cell.textLabel?.font = UIFont.systemFont(ofSize: 14)
        cell.textLabel?.textColor = UIColor(hex: "#292929")
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        didSelected(dataSource[indexPath.row])
    }
    
}
