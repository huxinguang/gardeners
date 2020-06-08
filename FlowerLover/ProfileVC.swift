//
//  ProfileVC.swift
//  FlowerLover
//
//  Created by xinguang hu on 2020/3/3.
//  Copyright © 2020 xjy. All rights reserved.
//

import UIKit
import LeanCloud
import TZImagePickerController
import QCloudCore
import QCloudCOSXML

class ProfileVC: UITableViewController {

    fileprivate let titles = ["Nickname","Signature","Gender", "Age", "Location"]
    fileprivate lazy var infoTexts = ["","","","",""]
    fileprivate lazy var placeholders = ["","Briefly introduce yourself","Your gender","Your age","Your location"]
    fileprivate var avatar: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 160))
        let button = UIButton()
        button.backgroundColor = UIColor.red
        button.addTarget(self, action: #selector(onAvatar), for: .touchUpInside)
        button.layer.borderColor = UIColor(hexString: "eeeeee").cgColor
        button.layer.borderWidth = 5
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        headerView.addSubview(button)
        button.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: 90, height: 90))
        }
        avatar = button
        
        let imageView = UIImageView(image: UIImage(named: "fl_camera"))
        headerView.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.bottom.trailing.equalTo(button).offset(-5)
        }
        
        tableView.tableHeaderView = headerView
        
        if let user = LCApplication.default.currentUser {
            let url = user.get("avatar")?.stringValue ?? ""
            button.kf.setBackgroundImage(with: URL(string: url), for: .normal, placeholder: UIImage(named: "fl_default_icon"))
            updateIndoTexts(with: user)
        }
    
        tableView.tableFooterView = UIView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateUser), name: NSNotification.Name.App.UpdateUser, object: nil)
    }
    
    func updateIndoTexts(with user: LCUser) {
        infoTexts[0] = user.get("nickname")?.stringValue ?? ""
        infoTexts[1] = user.get("signature")?.stringValue ?? ""
        infoTexts[2] = user.get("gender")?.stringValue ?? ""
        infoTexts[3] = user.get("age")?.stringValue ?? ""
        infoTexts[4] = user.get("location")?.stringValue ?? ""
    }
    
    @objc
    private func updateUser(notification: Notification){
        let textField = notification.object as! UITextField
        let kv_pair = NSMutableDictionary()
        if textField.tag == 0 {
            if textField.text?.count ?? 0 > 0 {
                kv_pair["nickname"] = textField.text
            }
        }else if textField.tag == 1{
            if textField.text?.count ?? 0 > 0 {
                kv_pair["signature"] = textField.text
            }
        }else if textField.tag == 2{
            if textField.text?.count ?? 0 > 0 {
                kv_pair["gender"] = textField.text
            }
        }else if textField.tag == 3{
            if textField.text?.count ?? 0 > 0 {
                kv_pair["age"] = textField.text
            }
        }else{
            if textField.text?.count ?? 0 > 0 {
                kv_pair["location"] = textField.text
            }
        }
        
        let currentUser = LCApplication.default.currentUser
        do {
            guard kv_pair.allKeys.count > 0, let key = kv_pair.allKeys[0] as? String, let value = kv_pair[key] as? String else { return }
            try currentUser?.set(key, value: value)
            _ = currentUser?.save(completion: { (ret) in
                switch ret{
                case .success:
                    MBProgressHUD.showTipMessageInView(message: "Updated", hideDelay: 1.5)
                    self.updateIndoTexts(with: currentUser!)
                    self.tableView.reloadData()
                    break
                case .failure(error: let error):
                    print(error)
                    MBProgressHUD.showTipMessageInView(message: "Failed", hideDelay: 1.5)
                }
            })
        } catch {
            print(error)
            MBProgressHUD.showTipMessageInView(message: "Failed", hideDelay: 1.5)
        }
    }
    
    
    
    @objc
    private func onAvatar(){
        let vc = TZImagePickerController.init(maxImagesCount: 1, delegate: self)
        vc?.navLeftBarButtonSettingBlock = { leftBtn in
            leftBtn?.setImage(UIImage.init(named: "fl_picker_back"), for: .normal)
            leftBtn?.contentEdgeInsets =  UIEdgeInsets.init(top: 0, left: -10, bottom: 0, right: 0)
            leftBtn?.setTitle("Back", for: .normal)
            leftBtn?.setTitleColor(Styles.Color.themeColor, for: .normal)
            leftBtn?.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        }
        vc?.statusBarStyle = .default
        vc?.naviBgColor = UIColor.white
        vc?.naviTitleColor = UIColor.black
        vc?.naviTitleFont = UIFont.boldSystemFont(ofSize: 18)
        vc?.barItemTextColor = Styles.Color.themeColor
        vc?.navigationBar.isTranslucent = false
        vc?.oKButtonTitleColorNormal = Styles.Color.themeColor
        vc?.allowPickingVideo = false
        vc?.allowTakeVideo = false
        vc?.allowCrop = true
        let rWidth = UIScreen.main.bounds.size.width - 2*10
        vc?.cropRect = CGRect.init(x: 10, y: UIScreen.main.bounds.size.height/2-rWidth/2, width: rWidth, height: rWidth)
        present(vc!, animated: true, completion: nil)
    }
    

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath) as! ProfileCell
        cell.titleLabel.text = titles[indexPath.row]
        if infoTexts[indexPath.row].isEmpty {
            cell.textField.placeholder = placeholders[indexPath.row]
        }else{
            cell.textField.text = infoTexts[indexPath.row]
        }
        cell.textField.tag = indexPath.row
        return cell
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

extension ProfileVC: TZImagePickerControllerDelegate{
    
    func imagePickerController(_ picker: TZImagePickerController!, didFinishPickingPhotos photos: [UIImage]!, sourceAssets assets: [Any]!, isSelectOriginalPhoto: Bool) {
        let image = photos[0]
        if let data = image.jpegData(compressionQuality: 0.3) {
            MBProgressHUD.showActivityMessageInView(message: "Uploading...")
            let put = QCloudCOSXMLUploadObjectRequest<AnyObject>()
            let time = Date().timeIntervalSince1970*1000
            let obj = String.init(format: "ios/%ld.jpg", Int64(time))
            put.object = obj
            put.bucket = Constant.Thirdparty.qCloudBucket
            put.body = data as AnyObject
            put.setFinish {[weak self] (outputObject, error) in
                DispatchQueue.main.async {
                    MBProgressHUD.hideHUD()
                }
                if error != nil{
                    MBProgressHUD.showTipMessageInView(message: "Upload failed", hideDelay: 1.5)
                }else{
                    let url = outputObject!.location
                    let currentUser = LCApplication.default.currentUser
                    do {
                        try currentUser?.set("avatar", value: url)
                        _ = currentUser?.save(completion: { (ret) in
                            switch ret{
                            case .success:
                                guard let strongSelf = self else{return}
                                strongSelf.avatar.kf.setBackgroundImage(with: URL(string: url), for: .normal, placeholder: UIImage(named: "fl_default_icon"))
                            case .failure(error: let error):
                                print(error)
                                MBProgressHUD.showTipMessageInView(message: "Failed", hideDelay: 1.5)
                            }
                        })
                    } catch {
                        print(error)
                        MBProgressHUD.showTipMessageInView(message: "Failed", hideDelay: 1.5)
                    }
                    
                }
                
            }
            QCloudCOSTransferMangerService.defaultCOSTransferManager().uploadObject(put)
            
        }
    
    }

}
