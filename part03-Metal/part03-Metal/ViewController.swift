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
    }
    
    override func didSelected(_ obj: BaseTableDataSource) {
        
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
}

