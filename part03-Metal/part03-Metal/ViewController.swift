//
//  ViewController.swift
//  part03-Metal
//
//  Created by 詹保成 on 2019/1/23.
//  Copyright © 2019 残无殇. All rights reserved.
//

import UIKit

class ViewController: BaseTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Metal"
        dataSource.append(HomeModel(type: .clearScreen))
        dataSource.append(HomeModel(type: .triangle))
    }
    
    override func didSelected(_ obj: BaseTableDataSource) {
        guard let obj = obj as? HomeModel else {
            return
        }
        switch obj.type {
        case .clearScreen:
            push(ClearScreenViewController())
        case .triangle:
            push(TriangleViewController())
        default:
            break
        }
    }
    
    private func push(_ viewController: UIViewController) {
        navigationController?.pushViewController(viewController, animated: true)
    }
    
}


fileprivate struct HomeModel: BaseTableDataSource {
    
    var displayTitle: String? {
        return type.rawValue
    }
    
    var type = HomeType.none
}

fileprivate enum HomeType: String {
    case none
    case clearScreen = "清屏"
    case triangle = "三角形"
}

