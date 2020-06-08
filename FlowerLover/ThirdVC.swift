//
//  ThirdVC.swift
//  FlowerLover
//
//  Created by xinguang hu on 2020/2/26.
//  Copyright © 2020 xjy. All rights reserved.
//

import UIKit
import LeanCloud
import MessageUI

class ThirdVC: UITableViewController {
    
    private let images = [["fl_me_avatar"],["fl_me_post","fl_me_question","fl_me_like","fl_me_collect"],["fl_me_appstore"],["fl_me_invite","fl_me_feedback","fl_me_setting"]]
    private var titles = [["Tap to edit profile"],["Posts","Questions","Likes","Favorites"],["Rate"],["Share","Feedback","Settings"]]

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        NotificationCenter.default.addObserver(self, selector: #selector(onSignIn), name: NSNotification.Name.App.UserDidSignIn, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let user = LCApplication.default.currentUser {
            titles[0][0] = user.get("nickname")?.stringValue ?? "Tap to edit profile"
        }else{
            titles[0][0] = "Tap to edit profile"
        }
        tableView.reloadData()
    }

    @objc
    private func onSignIn(){
        let user = LCApplication.default.currentUser
        titles[0][0] = user!.get("nickname")?.stringValue ?? ""
        tableView.reloadData()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 4
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return images[section].count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MeCell", for: indexPath)
        cell.textLabel?.text =  titles[indexPath.section][indexPath.row]
        cell.imageView?.image = UIImage(named: images[indexPath.section][indexPath.row])
        if indexPath.section == 0 {
            if let user = LCApplication.default.currentUser {
                let url = user.get("avatar")?.stringValue ?? ""
                cell.imageView?.kf.setImage(with: URL(string: url), placeholder: UIImage(named: "fl_default_icon"))
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 103.5
        }else{
            return 44
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        if indexPath.section == 0 {
            if LCApplication.default.currentUser == nil{
                let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                let vc = storyboard.instantiateViewController(withIdentifier: "AccountVC")
                present(vc, animated: true, completion: nil)
                return
            }
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let vc = storyboard.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
            navigationController?.pushViewController(vc, animated: true)
            
        }else if indexPath.section == 1{
            if LCApplication.default.currentUser == nil{
                let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                let vc = storyboard.instantiateViewController(withIdentifier: "AccountVC")
                present(vc, animated: true, completion: nil)
                return
            }
            if indexPath.row == 0 {
                let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                let vc = storyboard.instantiateViewController(withIdentifier: "MinePostVC") as! MinePostVC
                vc.type = .me_author
                navigationController?.pushViewController(vc, animated: true)
            }else if indexPath.row == 1{
                let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                let vc = storyboard.instantiateViewController(withIdentifier: "MineQuestionVC") as! MineQuestionVC
                navigationController?.pushViewController(vc, animated: true)
            }else if indexPath.row == 2{
                let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                let vc = storyboard.instantiateViewController(withIdentifier: "MinePostVC") as! MinePostVC
                vc.type = .like
                navigationController?.pushViewController(vc, animated: true)
            }else{
                let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                let vc = storyboard.instantiateViewController(withIdentifier: "MinePostVC") as! MinePostVC
                vc.type = .collect
                navigationController?.pushViewController(vc, animated: true)
            }
            
        }else if indexPath.section == 2{
            let appUrl = URL.init(string: "itms-apps://itunes.apple.com/app/id1501350998?action=write-review")!
            if UIApplication.shared.canOpenURL(appUrl){
                UIApplication.shared.open(appUrl, options: [:], completionHandler: nil)
            }
        }else{
            if indexPath.row == 0 {
                showActions()
            }else if indexPath.row == 1{
                if LCApplication.default.currentUser == nil{
                    let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                    let vc = storyboard.instantiateViewController(withIdentifier: "AccountVC")
                    present(vc, animated: true, completion: nil)
                    return
                }
                guard let vc = storyboard.instantiateViewController(withIdentifier: "FeedbackVC") as? FeedbackVC else { return }
                navigationController?.pushViewController(vc, animated: true)
            }else{
                guard let vc = storyboard.instantiateViewController(withIdentifier: "SettingVC") as? SettingVC else { return }
                navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    private func showActions() {
        let alertVC = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
        let action1 = UIAlertAction.init(title: "SMS", style: .default) { (action) in
            if MFMessageComposeViewController.canSendText(){
                let sms = MFMessageComposeViewController()
                sms.navigationBar.tintColor = Styles.Color.themeColor
                sms.body = "I recommend Gardeners to you, it is very convenient to use, you can go to the App Store to download it"
                sms.messageComposeDelegate = self
                sms.modalPresentationStyle = .fullScreen
                self.present(sms, animated: true, completion: nil)
            }else{
                MBProgressHUD.showTipMessageInView(message: "Your device does not have a SIM card", hideDelay: 1.5)
            }
            
        }
        let action2 = UIAlertAction.init(title: "Mail", style: .default) { (action) in
            if MFMailComposeViewController.canSendMail(){
                let mail = MFMailComposeViewController.init()
                mail.navigationBar.tintColor = Styles.Color.themeColor
                mail.setSubject("Recommendation")
                let msgBody = "I recommend Gardeners to you, it is very convenient to use, you can go to the App Store to download it"
                mail.setMessageBody(msgBody, isHTML: false)
                mail.mailComposeDelegate = self
                mail.modalPresentationStyle = .fullScreen
                self.present(mail, animated: true, completion: nil)
            }else{
                MBProgressHUD.showTipMessageInView(message: "You have not set up mailing for this device", hideDelay: 1.5)
            }
        }
        let action3 = UIAlertAction.init(title: "Cancel", style: .cancel) { (action) in

        }
        alertVC.addAction(action1)
        alertVC.addAction(action2)
        alertVC.addAction(action3)
        if alertVC.responds(to: #selector(getter: popoverPresentationController)) {
            alertVC.popoverPresentationController?.sourceView = self.navigationItem.rightBarButtonItem?.customView;
            alertVC.popoverPresentationController?.sourceRect = CGRect(x: 0, y: 0, width: 44, height: 44);
        }
        self.present(alertVC, animated: true, completion: nil)
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ThirdVC : MFMailComposeViewControllerDelegate{
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        var msg = ""
        if result == .cancelled {
            msg = "Cancelled"
        }else if result == .sent{
            msg = "Success"
        }else{
            msg = "Failure"
        }
        MBProgressHUD.showTipMessageInWindow(message: msg, hideDelay: 1.5)
        controller.dismiss(animated: true, completion: nil)
        
    }
}


extension ThirdVC: MFMessageComposeViewControllerDelegate{
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        var msg = ""
        if result == .cancelled {
            msg = "Cancelled"
        }else if result == .sent{
            msg = "Success"
        }else{
            msg = "Failure"
        }
        MBProgressHUD.showTipMessageInWindow(message: msg, hideDelay: 1.5)
        controller.dismiss(animated: true, completion: nil)
    }
    
}

