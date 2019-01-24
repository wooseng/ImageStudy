//
//  ClearScreenViewController.swift
//  part03-Metal
//
//  Created by 詹保成 on 2019/1/23.
//  Copyright © 2019 残无殇. All rights reserved.
//
//  清屏
//

import UIKit



class ClearScreenViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "清屏"
        setMetalView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        metalView.render()
    }
    
    private let metalView = ClearScreenView.init(frame: .zero)
    
    private func setMetalView() {
        view.addSubview(metalView)
        metalView.snp.makeConstraints { (maker) in
            maker.center.equalTo(view)
            maker.width.height.equalTo(200)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        metalView.render()
    }
    
}
