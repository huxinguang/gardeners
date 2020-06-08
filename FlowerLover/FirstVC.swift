//
//  FirstVC.swift
//  FlowerLover
//
//  Created by xinguang hu on 2020/2/24.
//  Copyright © 2020 xjy. All rights reserved.
//

import UIKit
import LeanCloud

let postCellOneID = "PostCellOne"
let postCellTwoID = "PostCellTwo"
let postCellThreeVerticalID = "PostCellThreeVertical"
let postCellThreeHorizontalID = "PostCellThreeHorizontal"
let postCellFourVerticalID = "PostCellFourVertical"
let postCellFourHorizontalID = "PostCellFourHorizontal"

class FirstVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    private var refreshCtrl : UIRefreshControl!
    lazy var data = [LCObject]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        tableView.register(PostCellOne.self, forCellReuseIdentifier: postCellOneID)
        tableView.register(PostCellTwo.self, forCellReuseIdentifier: postCellTwoID)
        tableView.register(PostCellThreeVertical.self, forCellReuseIdentifier: postCellThreeVerticalID)
        tableView.register(PostCellThreeHorizontal.self, forCellReuseIdentifier: postCellThreeHorizontalID)
        tableView.register(PostCellFourVertical.self, forCellReuseIdentifier: postCellFourVerticalID)
        tableView.register(PostCellFourHorizontal.self, forCellReuseIdentifier: postCellFourHorizontalID)
        tableView.tableFooterView = UIView()
        
        refreshCtrl = UIRefreshControl()
        refreshCtrl.tintColor = Styles.Color.themeColor
        refreshCtrl.addTarget(self, action: #selector(fetchData), for: .valueChanged)
        tableView.addSubview(refreshCtrl)
        
        NotificationCenter.default.addObserver(self, selector: #selector(fetchData), name: NSNotification.Name.App.RefreshPosts, object: nil)
        MBProgressHUD.showActivityMessageInView(message: "")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
    }
    
    @objc
    private func fetchData(){
        let query = LCQuery(className: "Post")
        query.whereKey("createdAt", .descending)
        query.whereKey("user", .included)
        query.whereKey("pics", .included)
        query.whereKey("status", .equalTo(0))
        if let user = LCApplication.default.currentUser {
            let shield_users = user.get("shield_users") as? LCArray ?? []
            query.whereKey("user", .notContainedIn(shield_users))
            let shield_posts = user.get("shield_posts") as? LCArray ?? []
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
        if identifier == "ShowPostEditVC" && LCApplication.default.currentUser == nil{
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
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    

}

extension FirstVC: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: BasePostCell?
        let post = data[indexPath.row]
        let pics = post.get("pics") as! LCArray
        let firstPic = pics[0] as! LCObject
        let width = firstPic.get("width")?.intValue
        let height = firstPic.get("height")?.intValue
        
        if pics.count == 1 {
            cell = tableView.dequeueReusableCell(withIdentifier: postCellOneID) as? PostCellOne
            if cell == nil {
                cell = PostCellOne(style: .default, reuseIdentifier: postCellOneID)
            }
        }else if pics.count == 2{
            cell = tableView.dequeueReusableCell(withIdentifier: postCellTwoID) as? PostCellTwo
            if cell == nil {
                cell = PostCellTwo(style: .default, reuseIdentifier: postCellTwoID)
            }
        }else if pics.count == 3{
            if width! > height!{
                cell = tableView.dequeueReusableCell(withIdentifier: postCellThreeHorizontalID) as? PostCellThreeHorizontal
                if cell == nil {
                    cell = PostCellThreeHorizontal(style: .default, reuseIdentifier: postCellThreeHorizontalID)
                }
            }else{
                cell = tableView.dequeueReusableCell(withIdentifier: postCellThreeVerticalID) as? PostCellThreeVertical
                if cell == nil {
                    cell = PostCellThreeVertical(style: .default, reuseIdentifier: postCellThreeVerticalID)
                }
            }
        }else if pics.count >= 4{
            if width! > height!{
                cell = tableView.dequeueReusableCell(withIdentifier: postCellFourHorizontalID) as? PostCellFourHorizontal
                if cell == nil {
                    cell = PostCellFourHorizontal(style: .default, reuseIdentifier: postCellFourHorizontalID)
                }
            }else{
                cell = tableView.dequeueReusableCell(withIdentifier: postCellFourVerticalID) as? PostCellFourVertical
                if cell == nil {
                    cell = PostCellFourVertical(style: .default, reuseIdentifier: postCellFourVerticalID)
                }
            }
        }
        
        cell?.update(with: post)

        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "PostCommentVC") as! PostCommentVC
        vc.post = data[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    

}
