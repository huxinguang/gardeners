//
//  AnswerCell.swift
//  FlowerLover
//
//  Created by xinguang hu on 2020/2/28.
//  Copyright © 2020 xjy. All rights reserved.
//

import UIKit
import LeanCloud
import SwiftDate

class AnswerCell: UITableViewCell {

    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    var model: LCObject!{
        didSet{
            let user = model.get("user") as! LCObject
            nameLabel.text = user.get("nickname")?.stringValue

            let date = model.get("createdAt")?.dateValue
            timeLabel.text = "Answered " + (date?.toRelative(style: RelativeFormatter.defaultStyle(), locale: Locales.english) ?? "")
            contentLabel.text = model.get("content")?.stringValue
            
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
