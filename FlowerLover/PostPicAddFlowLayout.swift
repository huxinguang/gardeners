//
//  CircleFlowLayout.swift
//  storage
//
//  Created by xinguang hu on 2019/8/16.
//  Copyright © 2019 huxinguang. All rights reserved.
//

import UIKit

class PostPicAddFlowLayout: UICollectionViewFlowLayout {

    let cellSpacing: CGFloat = 0.0
    let lineSpacing: CGFloat = 10.0
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.scrollDirection = .horizontal
        let exactH = 100
        let exactW = exactH
        self.itemSize = CGSize(width: Int(exactW), height: Int(exactH))
        self.minimumLineSpacing = lineSpacing
        self.minimumInteritemSpacing = cellSpacing
    }
    
}
