//
//  UISegmentedControl.swift
//  FlowerLover
//
//  Created by xinguang hu on 2020/2/20.
//  Copyright © 2020 xjy. All rights reserved.
//

import UIKit


private var normalTitleColorKey: UInt8 = 0
private var selectedTitleColorKey: UInt8 = 0

extension UISegmentedControl{
    
    @IBInspectable
    var normalTitleColor: UIColor? {
        get {
            if let color = objc_getAssociatedObject(self, &normalTitleColorKey) as? UIColor {
                return color
            }
            return nil
        }
        set {
            if let color = newValue {
                setTitleTextAttributes([NSAttributedString.Key.foregroundColor : color], for: .normal)
                objc_setAssociatedObject(self, &normalTitleColorKey, color, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            } else {
                objc_setAssociatedObject(self, &normalTitleColorKey, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
    
    @IBInspectable
    var selectedTitleColor: UIColor? {
        get {
            if let color = objc_getAssociatedObject(self, &selectedTitleColorKey) as? UIColor {
                return color
            }
            return nil
        }
        set {
            if let color = newValue {
                setTitleTextAttributes([NSAttributedString.Key.foregroundColor : color], for: .selected)
                objc_setAssociatedObject(self, &selectedTitleColorKey, color, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            } else {
                objc_setAssociatedObject(self, &selectedTitleColorKey, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }

}
