//
//  QuestionCell.swift
//  FlowerLover
//
//  Created by xinguang hu on 2020/2/28.
//  Copyright © 2020 xjy. All rights reserved.
//

import UIKit
import LeanCloud
import SwiftDate

class QuestionCell: UITableViewCell {

    @IBOutlet weak var abstractLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    var model: LCObject!{
        didSet{
            let user = model.get("user") as! LCObject
            nameLabel.text = user.get("nickname")?.stringValue

            let date = model.get("createdAt")?.dateValue
            timeLabel.text = "Asked " + (date?.toRelative(style: RelativeFormatter.defaultStyle(), locale: Locales.english) ?? "")
            abstractLabel.text = model.get("abstract")?.stringValue
            detailLabel.text = model.get("detail")?.stringValue
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
