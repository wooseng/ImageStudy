//
//  BaseViewController.swift
//  part03-Metal
//
//  Created by 詹保成 on 2019/1/23.
//  Copyright © 2019 残无殇. All rights reserved.
//

import UIKit
import Hue
import SnapKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        setBackItem()
    }
    
    private func setBackItem() {
        let item = UIBarButtonItem.init()
        item.title = ""
        item.tintColor = UIColor(hex: "#999999")
        navigationItem.backBarButtonItem = item
    }
    
}
