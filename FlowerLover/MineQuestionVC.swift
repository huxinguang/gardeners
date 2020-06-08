//
//  MineQuestionVC.swift
//  FlowerLover
//
//  Created by xinguang hu on 2020/3/3.
//  Copyright © 2020 xjy. All rights reserved.
//

import UIKit
import LeanCloud

class MineQuestionVC: UITableViewController {
    
    private var refreshCtrl : UIRefreshControl!
    lazy var data = [LCObject]()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableFooterView = UIView()
        
        refreshCtrl = UIRefreshControl()
        refreshCtrl.tintColor = Styles.Color.themeColor
        refreshCtrl.addTarget(self, action: #selector(fetchData), for: .valueChanged)
        tableView.addSubview(refreshCtrl)
                
        MBProgressHUD.showActivityMessageInView(message: "")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
    }
    
    @objc
    private func fetchData(){
        let query = LCQuery(className: "Question")
        query.whereKey("user", .equalTo(LCApplication.default.currentUser!))
        query.whereKey("createdAt", .descending)
        query.whereKey("user", .included)
        query.whereKey("status", .equalTo(0))
        if let user = LCApplication.default.currentUser {
            let shield_users = user.get("shield_users") as? LCArray ?? []
            query.whereKey("user", .notContainedIn(shield_users))
            let shield_posts = user.get("shield_questions") as? LCArray ?? []
            query.whereKey("objectId", .notContainedIn(shield_posts))
        }
        _ = query.find {[weak self] result in
            guard let strongSelf = self else{return}
            strongSelf.refreshCtrl.endRefreshing()
            MBProgressHUD.hideHUD()
            switch result {
            case .success(objects: let data):
                print(data)
                strongSelf.data = data
                strongSelf.tableView.reloadData()
                break
            case .failure(error: let error):
                strongSelf.refreshCtrl.endRefreshing()
                print(error)
            }
        }
    }
    

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QANoAnswerCell", for: indexPath) as! QANoAnswerCell
        cell.model = data[indexPath.row]
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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "ShowQuestionDetail" {
            let cell = sender as! QANoAnswerCell
            let indexPath = tableView.indexPath(for: cell)
            let vc = segue.destination as! QADetailVC
            vc.question = data[indexPath!.row]
        }
    }

}
