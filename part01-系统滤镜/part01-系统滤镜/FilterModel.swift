//
//  FilterModel.swift
//  part01-系统滤镜
//
//  Created by 詹保成 on 2018/12/5.
//  Copyright © 2018 残无殇. All rights reserved.
//

import UIKit

struct FilterModel {
    
    var categoryName = ""
    
    var name = ""
    
    /// 属性值
    var values: [String: Any]?
    
    /// 官方原图
    var officialSourceImage = ""
    
    /// 官方效果图
    var officialTargetImage = ""
}
