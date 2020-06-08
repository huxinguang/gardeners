//
//  MinePostVC.swift
//  FlowerLover
//
//  Created by xinguang hu on 2020/3/2.
//  Copyright © 2020 xjy. All rights reserved.
//

import UIKit
import LeanCloud

enum PostType {
    case me_author
    case like
    case collect
}

class MinePostVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    private var refreshCtrl : UIRefreshControl!
    lazy var data = [LCObject]()
    var type: PostType!

    override func viewDidLoad() {
        super.viewDidLoad()

        if type == .me_author {
            title = "Posts"
        }else if type == .like{
            title = "Likes"
        }else{
            title = "Favorites"
        }
        
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
        
        MBProgressHUD.showActivityMessageInView(message: "")
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
    }
    
    @objc
    private func fetchData() {
        if type == .me_author{
            fetchMinePosts()
        }else if type == .like{
            fetchLikePosts()
        }else{
            fetchCollectPosts()
        }
    }
    
    private func fetchMinePosts(){
        let query = LCQuery(className: "Post")
        query.whereKey("user", .equalTo(LCApplication.default.currentUser!))
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
    
    private func fetchLikePosts(){
        let user = LCApplication.default.currentUser
        let likes = user!.get("likes") as? LCArray ?? []
    
        let query = LCQuery(className: "Post")
        query.whereKey("objectId", .containedIn(likes))
        query.whereKey("createdAt", .descending)
        query.whereKey("user", .included)
        query.whereKey("pics", .included)
        query.whereKey("status", .equalTo(0))
        
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

    private func fetchCollectPosts(){
        let user = LCApplication.default.currentUser
        let likes = user!.get("collects") as? LCArray ?? []
        let query = LCQuery(className: "Post")
        query.whereKey("objectId", .containedIn(likes))
        query.whereKey("createdAt", .descending)
        query.whereKey("user", .included)
        query.whereKey("pics", .included)
        query.whereKey("status", .equalTo(0))
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
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }

    

}

extension MinePostVC: UITableViewDataSource, UITableViewDelegate{
    
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
        cell?.moreButton.isHidden = true

        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "PostCommentVC") as! PostCommentVC
        vc.post = data[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    

}

