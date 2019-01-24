//
//  TriangleViewController.swift
//  part03-Metal
//
//  Created by 詹保成 on 2019/1/24.
//  Copyright © 2019 残无殇. All rights reserved.
//

import UIKit

class TriangleViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "三角形"
        setTriangleView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        triangleView.render()
    }
    
    private let triangleView = TriangleView.init(frame: .zero)
    
    private func setTriangleView() {
        view.addSubview(triangleView)
        let top = UIApplication.shared.statusBarFrame.height + (navigationController?.navigationBar.frame.height ?? 0)
        triangleView.snp.makeConstraints { (maker) in
            maker.bottom.left.right.equalTo(0)
            maker.top.equalTo(top)
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let peak = randomPosition() else {
            return
        }
        triangleView.render(peak1: peak.0, peak2: peak.1, peak3: peak.2)
    }
    
    
    private func randomPosition() -> (TriangleView.PeakPosition, TriangleView.PeakPosition, TriangleView.PeakPosition)? {
        var set: Set<TriangleView.PeakPosition> = [.top, .bottom, .left, .right, .leftTop, .leftBottom, .rightTop, .rightBottom, .center]
        guard let peak1 = set.randomElement() else {
            return nil
        }
        set.remove(peak1)
        guard let peak2 = set.randomElement() else {
            return nil
        }
        set.remove(peak2)
        guard let peak3 = set.randomElement() else {
            return nil
        }
        return (peak1, peak2, peak3)
    }
    
}
