//
//  QADetailVC.swift
//  FlowerLover
//
//  Created by xinguang hu on 2020/2/28.
//  Copyright © 2020 xjy. All rights reserved.
//

import UIKit
import LeanCloud

class QADetailVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var answerButton: UIButton!
    var question: LCObject!
    lazy var data = [LCObject]()
    private var refreshCtrl : UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        refreshCtrl = UIRefreshControl()
        refreshCtrl.tintColor = Styles.Color.themeColor
        refreshCtrl.addTarget(self, action: #selector(fetchData), for: .valueChanged)
        tableView.addSubview(refreshCtrl)
        
        let answer_count = question.get("answer_count")?.intValue ?? 0
        answerButton.setTitle(answer_count > 0 ? "\(answer_count)" : "Answer", for: .normal)
        
        NotificationCenter.default.addObserver(self, selector: #selector(fetchData), name: NSNotification.Name.App.RefreshAnswers, object: nil)
        MBProgressHUD.showActivityMessageInView(message: "")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
    }
    
    @objc
    private func fetchData(){
        let query = LCQuery(className: "Answer")
        query.whereKey("question", .equalTo(question))
        query.whereKey("user", .included)
        query.whereKey("createdAt", .descending)
        
        _ = query.find {[weak self] result in
            guard let strongSelf = self else{return}
            strongSelf.refreshCtrl.endRefreshing()
            MBProgressHUD.hideHUD()
            switch result {
            case .success(objects: let data):
                print(data)
                strongSelf.data = data
                strongSelf.tableView.reloadData()
                strongSelf.answerButton.setTitle(data.count > 0 ? "\(data.count)" : "Answer", for: .normal)
                
                break
            case .failure(error: let error):
                print(error)

            }
        }
    }
    
    @IBAction func onReport(_ sender: UIButton) {
        let report = LCObject(className: "Report")
        do {
            try report.set("question", value: question)
        } catch  {
            print(error)
        }
        report.save {(result) in
            switch result{
            case .success:
                MBProgressHUD.showTipMessageInView(message: "Thanks for your supervision", hideDelay: 1.5)
            case .failure(error: let error):
                print(error)
            }
        }
    }
    
    @IBAction func onShield(_ sender: UIButton) {
        if let user = LCApplication.default.currentUser{
            let shield_user = question.get("user") as! LCObject
            if shield_user.objectId == user.objectId {
                MBProgressHUD.showTipMessageInView(message: "Don't shield yourself", hideDelay: 1.5)
                return
            }
            do{
                try user.append("shield_questions", element: question.objectId!, unique: true)
            }catch{
                print(error)
            }
            _ = user.save { (result) in
                switch result{
                case .success:
                    self.navigationController?.popViewController(animated: true)
                    NotificationCenter.default.post(name: NSNotification.Name.App.RefreshQuestions, object: nil)
                    break
                case .failure(error: let error):
                    print(error)
                }
            }
        }else{
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let vc = storyboard.instantiateViewController(withIdentifier: "AccountVC")
            UIViewController.currentViewController().present(vc, animated: true, completion: nil)
        }
    }

    // MARK: - Navigation
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "QuestionAnswerEdit" && LCApplication.default.currentUser == nil{
            if LCApplication.default.currentUser == nil {
                let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                let vc = storyboard.instantiateViewController(withIdentifier: "AccountVC")
                present(vc, animated: true, completion: nil)
                return false
            }
        }
        return true
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "QuestionAnswerEdit" {
            let vc = segue.destination as! TextEditVC
            vc.contentType = .question_answer
            vc.question = question
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

}

extension QADetailVC: UITableViewDataSource,UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionCell", for: indexPath) as! QuestionCell
            cell.model = question
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "AnswerCell", for: indexPath) as! AnswerCell
            cell.model = data[indexPath.row]
            return cell
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return section == 0 ? 10 : 0.01
    }
}


