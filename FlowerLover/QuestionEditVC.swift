//
//  QuestionEditVC.swift
//  FlowerLover
//
//  Created by xinguang hu on 2020/2/29.
//  Copyright © 2020 xjy. All rights reserved.
//

import UIKit
import KMPlaceholderTextView
import LeanCloud

class QuestionEditVC: UIViewController {
    @IBOutlet weak var abstractTextView: KMPlaceholderTextView!
    @IBOutlet weak var detailTextView: KMPlaceholderTextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        abstractTextView.tintColor = Styles.Color.themeColor
        detailTextView.tintColor = Styles.Color.themeColor
        
    }
    
    @IBAction func onCancel(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onPost(_ sender: UIButton) {
        if abstractTextView.text.count <= 0 || detailTextView.text.count <= 0{
            MBProgressHUD.showTipMessageInView(message: "Content required", hideDelay: 1.5)
            return
        }
        
        let question = LCObject(className: "Question")
        let user = LCApplication.default.currentUser
        do {
            try question.set("abstract", value: abstractTextView.text)
            try question.set("detail", value: detailTextView.text)
            try question.set("user", value: user)
        } catch  {
            print(error)
        }
        _ = question.save {[weak self] (result) in
            guard let strongSelf = self else{return}
            
            switch result{
            case .success:
                strongSelf.dismiss(animated: true) {
                    MBProgressHUD.showTipMessageInWindow(message: "Question posted", hideDelay: 1.5)
                    NotificationCenter.default.post(name: NSNotification.Name.App.RefreshQuestions, object: nil)
                }
                break
            case .failure(error: let error):
                MBProgressHUD.showTipMessageInWindow(message: "Question unposted", hideDelay: 1.5)
                print(error)
                break
            }
        }
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
