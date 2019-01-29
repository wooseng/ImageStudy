//
//  ImageRenderViewController.swift
//  part03-Metal
//
//  Created by 詹保成 on 2019/1/27.
//  Copyright © 2019 残无殇. All rights reserved.
//

import UIKit

class ImageRenderViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "图形渲染"
        setMetalView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        metalView.render()
    }
    
    private let metalView = ImageRenderView.init(frame: .zero)
    
    private func setMetalView() {
        view.addSubview(metalView)
        guard let image = UIImage(named: UIImage.name.image_4) else {
            return
        }
        metalView.image = image
        let scale = image.size.height / image.size.width
        metalView.snp.makeConstraints { (maker) in
            maker.left.equalTo(30)
            maker.right.equalTo(-30)
            maker.centerY.equalTo(view)
            maker.height.equalTo(metalView.snp.width).multipliedBy(scale)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        metalView.render()
    }
    
}
