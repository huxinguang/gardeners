//
//  AccountVC.swift
//  FlowerLover
//
//  Created by xinguang hu on 2020/2/20.
//  Copyright © 2020 xjy. All rights reserved.
//

import UIKit
import SafariServices
import LeanCloud

class AccountVC: UIViewController {

    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var signinupButton: UIButton!
    @IBOutlet weak var parentStackView: UIStackView!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var checkBox: UIButton!
    
    private lazy var nicknameStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = 10
        
        let label = UILabel()
        label.text = "Nickname"
        label.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.semibold)
        stackView.addArrangedSubview(label)
        
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.font = UIFont.systemFont(ofSize: 14)
        stackView.addArrangedSubview(textField)
        
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func onCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onSegment(_ sender: UISegmentedControl) {
        signinupButton.setTitle(sender.selectedSegmentIndex == 0 ? "Sign in" : "Sign up", for: .normal)
        if sender.selectedSegmentIndex == 0 {
            nicknameStackView.removeFromSuperview()
        }else{
            if !parentStackView.arrangedSubviews.contains(nicknameStackView) {
                parentStackView.insertArrangedSubview(nicknameStackView, at: 2)
            }
        }
    }
    
    @IBAction func onCheck(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func onAgreement(_ sender: Any) {
        guard let url = URL(string: "https://raw.githubusercontent.com/huxinguang/pravicy/master/gardeners.md") else { return }
        let sf = SFSafariViewController(url: url)
        sf.preferredBarTintColor = UIColor.white
        sf.preferredControlTintColor = Styles.Color.themeColor
        if #available(iOS 11.0, *){
            sf.dismissButtonStyle = .close
        }
        present(sf, animated: true, completion: nil)
    }
    
    @IBAction func onSignInOrUp(_ sender: UIButton) {
        if !checkBox.isSelected {
            MBProgressHUD.showTipMessageInView(message: "You must agree user agreement", hideDelay: 1.5)
            return
        }
        
        if segmentControl.selectedSegmentIndex == 0 {//Sign in
            if let phone = phoneTextField.text, let password = passwordTextField.text{
                MBProgressHUD.showActivityMessageInView(message: "")
                _ = LCUser.logIn(username: phone, password: password) { result in
                    MBProgressHUD.hideHUD()
                    switch result {
                    case .success(object: let user):
                        print(user)
                        let sessionToken = user.sessionToken?.stringValue
                        UserDefaults.standard.set(sessionToken, forKey: "sessionToken")
                        UserDefaults.standard.synchronize()
                        self.dismiss(animated: true) {
                            NotificationCenter.default.post(name: NSNotification.Name.App.UserDidSignIn, object: nil)
                        }
                    case .failure(error: let error):
                        MBProgressHUD.showTipMessageInView(message: error.reason != nil ? error.reason! : "Failure, error code" + "\(error.code)", hideDelay: 1.5)
                    }
                }
            }
            
        }else{// Sign up
            if let nicknameTextField = nicknameStackView.arrangedSubviews[1] as? UITextField, let phone = phoneTextField.text, let password = passwordTextField.text, let nickname = nicknameTextField.text{
                MBProgressHUD.showActivityMessageInView(message: "")
                let user = LCUser()
                do {
                    try user.set("username", value: phone)
                    try user.set("password", value: password)
                    try user.set("nickname", value: nickname)
                } catch  {
                    print(error)
                }
                
                _ = user.signUp { (result) in
                    MBProgressHUD.hideHUD()
                    switch result{
                    case .success:
                        MBProgressHUD.showTipMessageInWindow(message: "Success", hideDelay: 1.5)
                        self.segmentControl.selectedSegmentIndex = 0
                        self.onSegment(self.segmentControl)
                        break
                    case .failure(error: let error):
                        MBProgressHUD.showTipMessageInView(message: error.reason != nil ? error.reason! : "Failure, error code" + "\(error.code)", hideDelay: 1.5)
                        break
                    }
                }
                
            }else {
                
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
