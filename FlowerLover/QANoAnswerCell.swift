//
//  QANoAnswerCell.swift
//  FlowerLover
//
//  Created by xinguang hu on 2020/2/26.
//  Copyright © 2020 xjy. All rights reserved.
//

import UIKit
import LeanCloud

class QANoAnswerCell: UITableViewCell {
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var answerButton: UIButton!
    var model: LCObject!{
        didSet{
            questionLabel.text = model.get("abstract")?.stringValue
            let count = model.get("answer_count")?.intValue ??  0
            countLabel.text = "\(count)" + (count > 1 ? " answers" : " answer")
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
