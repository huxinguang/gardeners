//
//  PostCellTwo.swift
//  FlowerLover
//
//  Created by xinguang hu on 2020/2/25.
//  Copyright © 2020 xjy. All rights reserved.
//

import UIKit
import LeanCloud

class PostCellTwo: BasePostCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let imageView1 = UIImageView()
        imageView1.contentMode = .scaleAspectFill
        imageView1.clipsToBounds = true
        imageView1.backgroundColor = Styles.Color.bgColor
        placeholderView.addSubview(imageView1)
        imageViews.append(imageView1)
        
        
        let imageView2 = UIImageView()
        imageView2.contentMode = .scaleAspectFill
        imageView2.clipsToBounds = true
        imageView2.backgroundColor = Styles.Color.bgColor
        placeholderView.addSubview(imageView2)
        imageViews.append(imageView2)
        
        for i in 0..<imageViews.count {
            let imageView = imageViews[i]
            imageView.isUserInteractionEnabled = true
            imageView.tag = i
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onImageTapped(gesture:)))
            imageView.addGestureRecognizer(tapGesture)
        }
        
        imageView1.snp.makeConstraints { (make) in
            make.top.leading.bottom.equalToSuperview()
        }
        
        imageView2.snp.makeConstraints { (make) in
            make.top.trailing.bottom.equalToSuperview()
            make.leading.equalTo(imageView1.snp.trailing).offset(Styles.Constant.spacing)
            make.width.equalTo(imageView1)
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
