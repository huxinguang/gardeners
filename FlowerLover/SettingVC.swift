//
//  SettingVC.swift
//  FlowerLover
//
//  Created by xinguang hu on 2020/2/27.
//  Copyright © 2020 xjy. All rights reserved.
//

import UIKit
import LeanCloud
import Kingfisher

class SettingVC: UITableViewController {
    
    private let titles: [String] = ["Clear cache","About Us", "Version"]
    private var detailTexts: [String] = ["0M","","v 1.0.0"]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        let footerView = UIView()
        footerView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44)
        let button = UIButton()
        button.frame = CGRect(x: 15, y: 0, width: footerView.frame.size.width - 30, height: footerView.frame.size.height)
        button.backgroundColor = UIColor(hexString: "FC5960")
        button.setTitle("Sign out", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 3
        button.addTarget(self, action: #selector(onSignOut), for: .touchUpInside)
        footerView.addSubview(button)
        
        button.isHidden = LCApplication.default.currentUser == nil
        
        tableView.tableFooterView = footerView
        
        
        KingfisherManager.shared.cache.calculateDiskStorageSize {(result) in
            var sizeText = "0M"
            switch result{
            case .success(let size):
                if (size >= 1000000000) {
                    sizeText = String(format: "%.1fG", Float(size)/1000000000)
                } else if (size >= 1000000) {
                    sizeText = String(format: "%.1fM", Float(size)/1000000 )
                } else if (size >= 1000) {
                    sizeText = String(format: "%.1fK", Float(size)/1000)
                } else {
                    sizeText = "0M"
                }
            case .failure(let error):
                print(error)
                break
            }
            
            self.detailTexts[0] = sizeText
            self.tableView.reloadData()
            
        }
        
    }
    
    @objc
    private func onSignOut(){
        LCUser.logOut()
        UserDefaults.standard.removeObject(forKey: "sessionToken")
        UserDefaults.standard.synchronize()
        navigationController?.popViewController(animated: true)
        MBProgressHUD.showTipMessageInWindow(message: "Account has been logged out", hideDelay: 1.5)
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return titles.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingCell", for: indexPath)
        cell.textLabel?.text = titles[indexPath.row]
        cell.textLabel?.textColor = UIColor(hexString: "333333")
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 16)
        cell.detailTextLabel?.text = detailTexts[indexPath.row]
        cell.detailTextLabel?.textColor = UIColor(hexString: "999999")
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 15)
        cell.accessoryType = indexPath.row == 2 ? .none : .disclosureIndicator
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            KingfisherManager.shared.cache.clearDiskCache {
                self.detailTexts[0] = "0M"
                self.tableView.reloadData()
                MBProgressHUD.showTipMessageInView(message: "Cache cleared", hideDelay: 1.5)
            }
            
        }else if indexPath.row == 1{
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let vc = storyboard.instantiateViewController(withIdentifier: "AboutVC")
            navigationController?.pushViewController(vc, animated: true)
        }else{
            
        }
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
