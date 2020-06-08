//
//  ProfileCell.swift
//  FlowerLover
//
//  Created by xinguang hu on 2020/3/3.
//  Copyright © 2020 xjy. All rights reserved.
//

import UIKit

class ProfileCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    
    @IBAction func onEdittingEnd(_ sender: UITextField) {
        NotificationCenter.default.post(name: NSNotification.Name.App.UpdateUser, object: sender)
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
