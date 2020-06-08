//
//  QAAnswerCell.swift
//  FlowerLover
//
//  Created by xinguang hu on 2020/2/26.
//  Copyright © 2020 xjy. All rights reserved.
//

import UIKit

class QAAnswerCell: UITableViewCell {
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var answerButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
