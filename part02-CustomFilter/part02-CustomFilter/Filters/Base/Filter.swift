//
//  Filter.swift
//  part02-CustomFilter
//
//  Created by 詹保成 on 2019/1/16.
//  Copyright © 2019 残无殇. All rights reserved.
//

import UIKit

class Filter: CIFilter {
    
    override init() {
        super.init()
        loadKernel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var inputImage: CIImage?
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        if key == kCIInputImageKey, let img = value as? CIImage {
            inputImage = img
        }
    }
    
    override var outputImage: CIImage? {
        if let image = inputImage {
            return dealInputImage(image)
        }
        return nil
    }
    
    public func dealInputImage(_ inputImage: CIImage) -> CIImage? {
        fatalError("must be overwrite by sub class")
    }
    
    /**
     加载kernel
     */
    public func loadKernel() {
        fatalError("must be overwrite by sub class")
    }
    
}

extension Filter {
    
    /**
     读取kernel文件中的内容
     */
    public func kernelCode(for fileName: String) -> String {
        let fileUrl = url(for: fileName)
        do {
            let kernelStr = try String.init(contentsOf: fileUrl)
            return kernelStr
        } catch {
            fatalError("load kernel file content failed")
        }
    }
    
    public func kernelData(for fileName: String) -> Data {
        let fileUrl = url(for: fileName)
        do {
            let data = try Data.init(contentsOf: fileUrl)
            return data
        } catch {
            fatalError("load kernel file data failed")
        }
    }
    
    private func url(for fileName: String) -> URL {
        guard let fileUrl = Bundle.main.url(forResource: fileName, withExtension: nil) else {
            fatalError("load cikernel file url failed")
        }
        return fileUrl
    }
}
