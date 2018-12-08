//
//  SettingSilderViewController.swift
//  part01-SystemFilter
//
//  Created by 詹保成 on 2018/12/8.
//  Copyright © 2018 残无殇. All rights reserved.
//
//  滑动条
//

import UIKit

class SettingSilderViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        setSlider()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        var sliderValues = sliders.map { (slider) -> Float in
            return slider.value
        }
        for (index, value) in values.enumerated() {
            if value.current != sliderValues[index] {
                complete?(sliderValues)
                break
            }
        }
    }
    
    var complete: (([Float]) -> Void)?
    
    var values = [(min: Float, max: Float, current: Float)]()
    
    private var sliders = [Slider]()
    
    private func setSlider() {
        sliders.removeAll()
        let space: CGFloat = 20
        var top = UIApplication.shared.statusBarFrame.height + (navigationController?.navigationBar.frame.height ?? 0) + space
        let width = view.frame.width
        let height: CGFloat = 40
        for value in values {
            let slider = Slider.init(frame: .init(x: 0, y: top, width: width, height: height))
            slider.min = value.min
            slider.max = value.max
            slider.value = value.current
            view.addSubview(slider)
            sliders.append(slider)
            top = slider.frame.maxY + space
        }
    }
}

fileprivate class Slider: UIView {
    
    var min: Float = 0 {
        didSet {
            slider.minimumValue = min
            leftLabel.text = "\(min)"
        }
    }
    
    var max: Float = 0 {
        didSet {
            slider.maximumValue = max
            rightLabel.text = "\(max)"
        }
    }
    
    var value: Float {
        set {
            slider.setValue(newValue, animated: true)
            centerLabel.text = "\(newValue)"
        }
        get {
            return slider.value
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(leftLabel)
        addSubview(rightLabel)
        addSubview(slider)
        addSubview(centerLabel)
        
        leftLabel.font = UIFont.systemFont(ofSize: 14)
        leftLabel.textColor = UIColor.init(hex: "#333333")
        rightLabel.font = UIFont.systemFont(ofSize: 14)
        rightLabel.textColor = UIColor.init(hex: "#333333")
        centerLabel.font = UIFont.systemFont(ofSize: 14)
        centerLabel.textColor = UIColor.init(hex: "#333333")
        centerLabel.textAlignment = .center
        
        leftLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(10)
            maker.top.bottom.equalTo(0)
        }
        rightLabel.snp.makeConstraints { (maker) in
            maker.right.equalTo(-10)
            maker.top.bottom.equalTo(0)
        }
        centerLabel.snp.makeConstraints { (maker) in
            maker.left.right.bottom.equalTo(0)
        }
        slider.snp.makeConstraints { (maker) in
            maker.left.equalTo(leftLabel.snp.right).offset(5)
            maker.right.equalTo(rightLabel.snp.left).offset(-5)
            maker.top.equalTo(0)
            maker.bottom.equalTo(centerLabel.snp.top)
        }
        slider.addTarget(self, action: #selector(sliderValueChange), for: .valueChanged)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let leftLabel = UILabel.init()
    private let rightLabel = UILabel.init()
    private let centerLabel = UILabel.init()
    private let slider = UISlider.init()
    
    @objc private func sliderValueChange() {
        centerLabel.text = "\(slider.value)"
    }
}
