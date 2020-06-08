//
//  Styles.swift
//  StarWelfare
//
//  Created by xinguang hu on 2020/1/9.
//  Copyright © 2020 weiyou. All rights reserved.
//

import UIKit

struct Styles {
    
    struct Adapter {
        static let scale = UIScreen.main.bounds.size.width/375.0
    }

    struct Fonts {
        static let pfscR: String = "PingFangSC-Regular"
        static let pfscM: String = "PingFangSC-Medium"
        static let pfscS: String = "PingFangSC-Semibold"
    }
    
    struct Color {
        static let themeColor = UIColor(hexString: "1EB18A")
        static let bgColor = UIColor(hexString: "F5F5F5")
    }
    
    struct Constant {
        static let spacing = 3.0
    }

}
