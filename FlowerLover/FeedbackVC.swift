//
//  FeedbackVC.swift
//  FlowerLover
//
//  Created by xinguang hu on 2020/2/26.
//  Copyright © 2020 xjy. All rights reserved.
//

import UIKit
import KMPlaceholderTextView
import LeanCloud

class FeedbackVC: UIViewController {

    @IBOutlet weak var textView: KMPlaceholderTextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.tintColor = UIColor(hexString: "FECC0A")

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onSubmit(_ sender: UIButton) {
        if textView.text.count <= 0 {
            MBProgressHUD.showTipMessageInView(message: "Content required", hideDelay: 1.5)
            return
        }
        
        let feedback = LCObject(className: "Feedback")
        let user = LCApplication.default.currentUser
        do {
            try feedback.set("content", value: textView.text)
            try feedback.set("user", value: user)
        } catch  {
            print(error)
        }
        _ = feedback.save {[weak self] (result) in
            guard let strongSelf = self else{return}
            
            switch result{
            case .success:
                strongSelf.navigationController?.popViewController(animated: true)
                MBProgressHUD.showTipMessageInWindow(message: "Thanks for your feedback", hideDelay: 1.5)
                break
            case .failure(error: let error):
                MBProgressHUD.showTipMessageInWindow(message: "Feedback unposted", hideDelay: 1.5)
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
