//
//  PostCellOne.swift
//  FlowerLover
//
//  Created by xinguang hu on 2020/2/25.
//  Copyright © 2020 xjy. All rights reserved.
//

import UIKit
import LeanCloud

class PostCellOne: BasePostCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let imageView = UIImageView()
        imageView.tag = 0
        imageView.backgroundColor = Styles.Color.bgColor
        imageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onImageTapped(gesture:)))
        imageView.addGestureRecognizer(tapGesture)
        placeholderView.addSubview(imageView)
        imageViews.append(imageView)
        
        imageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
