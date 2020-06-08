//
//  UITabBar.swift
//  FlowerLover
//
//  Created by xinguang hu on 2020/2/21.
//  Copyright © 2020 xjy. All rights reserved.
//

import UIKit

private var normalItemTintColorKey: UInt8 = 0
private var selectedItemTintColorKey: UInt8 = 0

extension UITabBar{
    @IBInspectable
    var normalItemTintColor: UIColor? {
        get {
            if let color = objc_getAssociatedObject(self, &normalItemTintColorKey) as? UIColor {
                return color
            }
            return nil
        }
        set {
            if let color = newValue {
                unselectedItemTintColor = color
                objc_setAssociatedObject(self, &normalItemTintColorKey, color, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            } else {
                objc_setAssociatedObject(self, &normalItemTintColorKey, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
    
    @IBInspectable
    var selectedItemTintColor: UIColor? {
        get {
            if let color = objc_getAssociatedObject(self, &selectedItemTintColorKey) as? UIColor {
                return color
            }
            return nil
        }
        set {
            if let color = newValue {
                if #available(iOS 13.0, *) {
                    tintColor = color
                }else{
                    if let barItems = items {
                        for item in barItems {
                            item.setTitleTextAttributes([NSAttributedString.Key.foregroundColor:color], for: .selected)
                        }
                    }
                }
                objc_setAssociatedObject(self, &selectedItemTintColorKey, color, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            } else {
                objc_setAssociatedObject(self, &selectedItemTintColorKey, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
}
