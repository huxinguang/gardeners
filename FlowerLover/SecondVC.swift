//
//  SecondVC.swift
//  FlowerLover
//
//  Created by xinguang hu on 2020/2/25.
//  Copyright © 2020 xjy. All rights reserved.
//

import UIKit
import LeanCloud

class SecondVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    private var refreshCtrl : UIRefreshControl!
    lazy var data = [LCObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        
        refreshCtrl = UIRefreshControl()
        refreshCtrl.tintColor = Styles.Color.themeColor
        refreshCtrl.addTarget(self, action: #selector(fetchData), for: .valueChanged)
        tableView.addSubview(refreshCtrl)
        
        NotificationCenter.default.addObserver(self, selector: #selector(fetchData), name: NSNotification.Name.App.RefreshQuestions, object: nil)
        
        MBProgressHUD.showActivityMessageInView(message: "")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
    }
    
    @objc
    private func fetchData(){
        let query = LCQuery(className: "Question")
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
    

    // MARK: - Navigation
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "ShowQuestionEditVC" && LCApplication.default.currentUser == nil{
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let vc = storyboard.instantiateViewController(withIdentifier: "AccountVC")
            present(vc, animated: true, completion: nil)
            return false
        }
        return true
    }
    

    // In a storyboard-based application, you will often want to do a little preparation before navigation
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
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}


extension SecondVC: UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QANoAnswerCell", for: indexPath) as! QANoAnswerCell
        cell.model = data[indexPath.row]
        return cell
    }
}
