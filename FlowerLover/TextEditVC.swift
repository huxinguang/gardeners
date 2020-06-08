//
//  TextEditVC.swift
//  FlowerLover
//
//  Created by xinguang hu on 2020/2/28.
//  Copyright © 2020 xjy. All rights reserved.
//

import UIKit
import KMPlaceholderTextView
import LeanCloud

enum ContentType {
    case post_comment
    case question_answer
}

class TextEditVC: UIViewController {

    @IBOutlet weak var textView: KMPlaceholderTextView!
    var contentType: ContentType!
    var post: LCObject!
    var question: LCObject!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.tintColor = Styles.Color.themeColor
        textView.placeholder = contentType == .post_comment ? "Enter your comment here..." : "Enter your answer here..."
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onCancel(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onPost(_ sender: UIButton) {
        if contentType == .post_comment {
            if textView.text.count <= 0 {
                MBProgressHUD.showTipMessageInView(message: "Content required", hideDelay: 1.5)
                return
            }
            
            let comment = LCObject(className: "Comment")
            let user = LCApplication.default.currentUser
            do {
                try comment.set("content", value: textView.text)
                try comment.set("user", value: user)
                try comment.set("post", value: post)
                //更新计数器(原子操作)
                try post.increase("comment_count", by: 1)
            } catch  {
                print(error)
            }
            _ = comment.save {[weak self] (result) in
                guard let strongSelf = self else{return}
                
                switch result{
                case .success:
                    strongSelf.dismiss(animated: true) {
                        MBProgressHUD.showTipMessageInWindow(message: "Comment posted", hideDelay: 1.5)
                        NotificationCenter.default.post(name: NSNotification.Name.App.RefreshComments, object: nil)
                    }
                    break
                case .failure(error: let error):
                    MBProgressHUD.showTipMessageInWindow(message: "Comment unposted", hideDelay: 1.5)
                    print(error)
                    break
                }
            }
            
        }else{
            if textView.text.count <= 0 {
                MBProgressHUD.showTipMessageInView(message: "Content required", hideDelay: 1.5)
                return
            }
            
            let answer = LCObject(className: "Answer")
            let user = LCApplication.default.currentUser
            do {
                try answer.set("content", value: textView.text)
                try answer.set("user", value: user)
                try answer.set("question", value: question)
                //更新计数器(原子操作)
                try question.increase("answer_count", by: 1)
            } catch  {
                print(error)
            }
            _ = answer.save {[weak self] (result) in
                guard let strongSelf = self else{return}
                
                switch result{
                case .success:
                    strongSelf.dismiss(animated: true) {
                        MBProgressHUD.showTipMessageInWindow(message: "Answer posted", hideDelay: 1.5)
                        NotificationCenter.default.post(name: NSNotification.Name.App.RefreshAnswers, object: nil)
                    }
                    break
                case .failure(error: let error):
                    MBProgressHUD.showTipMessageInWindow(message: "Answer unposted", hideDelay: 1.5)
                    print(error)
                    break
                }
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
