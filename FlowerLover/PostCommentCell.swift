//
//  PostCommentCell.swift
//  FlowerLover
//
//  Created by xinguang hu on 2020/3/1.
//  Copyright © 2020 xjy. All rights reserved.
//

import UIKit
import LeanCloud
import SwiftDate

class PostCommentCell: UITableViewCell {

    @IBOutlet weak var avatarView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    var model: LCObject!{
        didSet{
            let user = model.get("user") as! LCObject
            nameLabel.text = user.get("nickname")?.stringValue
            let avatar = user.get("avatar")?.stringValue ?? ""
            avatarView.kf.setImage(with: URL(string: avatar), placeholder: UIImage(named: "fl_default_icon"))
            contentLabel.text = model.get("content")?.stringValue
            let date = model.get("createdAt")?.dateValue
            timeLabel.text = date?.toRelative(style: RelativeFormatter.defaultStyle(), locale: Locales.english)
        }
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
