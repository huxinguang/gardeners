//
//  PostCommentVC.swift
//  FlowerLover
//
//  Created by xinguang hu on 2020/3/1.
//  Copyright © 2020 xjy. All rights reserved.
//

import UIKit
import LeanCloud

class PostCommentVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var collectButton: UIButton!
    
    
    var post: LCObject!
    lazy var data = [LCObject]()
    private var refreshCtrl : UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        
        let like_count = post.get("like_count")?.intValue ?? 0
        likeButton.setImage(UIImage.init(named: "fl_detail_like_n"), for: .normal)
        likeButton.setImage(UIImage.init(named: "fl_detail_like_s"), for: .selected)
        likeButton.setTitleColor(UIColor(hexString: "8A8A8A"), for: .normal)
        likeButton.setTitleColor(Styles.Color.themeColor, for: .selected)
        likeButton.setTitle(like_count > 0 ? "\(like_count)" : "Like", for: .normal)
        likeButton.setTitle(like_count > 0 ? "\(like_count)" : "Like", for: .selected)
        
        
        collectButton.setImage(UIImage.init(named: "fl_detail_collect_n"), for: .normal)
        collectButton.setImage(UIImage.init(named: "fl_detail_collect_s"), for: .selected)
        collectButton.setTitleColor(UIColor(hexString: "8A8A8A"), for: .normal)
        collectButton.setTitleColor(Styles.Color.themeColor, for: .selected)
        collectButton.setTitle("Collect", for: .normal)
        collectButton.setTitle("Collected", for: .selected)
        
        let comment_count = post.get("comment_count")?.intValue ?? 0
        commentButton.setTitle(comment_count > 0 ? "\(comment_count)" : "Comment", for: .normal)
        commentButton.setTitle(comment_count > 0 ? "\(comment_count)" : "Comment", for: .selected)
        
        refreshCtrl = UIRefreshControl()
        refreshCtrl.tintColor = Styles.Color.themeColor
        refreshCtrl.addTarget(self, action: #selector(fetchData), for: .valueChanged)
        tableView.addSubview(refreshCtrl)
        
        NotificationCenter.default.addObserver(self, selector: #selector(fetchData), name: NSNotification.Name.App.RefreshComments, object: nil)
    
        MBProgressHUD.showActivityMessageInView(message: "")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
        judgeIfLiked()
        judgeIfCollected()
    }
    
    @objc
    private func fetchData(){
        let query = LCQuery(className: "Comment")
        query.whereKey("post", .equalTo(post))
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
                strongSelf.commentButton.setTitle(data.count > 0 ? "\(data.count)" : "Comment", for: .normal)
                
                break
            case .failure(error: let error):
                print(error)

            }
        }
    }
    
    private func judgeIfLiked(){
        if let user = LCApplication.default.currentUser{
            if let ids = user.get("likes") as? LCArray{
                likeButton.isSelected = ids.contains { (post_id) -> Bool in
                    if case post_id.stringValue = post.objectId?.stringValue {
                        return true
                    }else{
                        return false
                    }
                }
                
            }else{
                likeButton.isSelected = false
            }
        }else{
            likeButton.isSelected = false
        }
    }
    
    private func judgeIfCollected(){
        if let user = LCApplication.default.currentUser{
            if let ids = user.get("collects") as? LCArray{
                collectButton.isSelected = ids.contains { (post_id) -> Bool in
                    if case post_id.stringValue = post.objectId?.stringValue {
                        return true
                    }else{
                        return false
                    }
                }
                
            }else{
                collectButton.isSelected = false
            }
        }else{
            collectButton.isSelected = false
        }
    }

    
    @IBAction func onLike(_ sender: UIButton) {
        if let user = LCApplication.default.currentUser{
            if likeButton.isSelected {
                do{
                    try user.remove("likes", element: post.objectId!)
                    try post.increase("like_count", by: -1)
                }catch{
                    print(error)
                }
            }else{
                do{
                    try user.append("likes", element: post.objectId!, unique: true)
                    try post.increase("like_count", by: 1)
                }catch{
                    print(error)
                }
            }
            
            _ = post.save()
            
            _ = user.save {[weak self] (result) in
                guard let strongSelf = self else{return}
                switch result{
                case .success:
                    strongSelf.likeButton.isSelected = !strongSelf.likeButton.isSelected
                    let like_count = strongSelf.post.get("like_count")?.intValue ?? 0
                    strongSelf.likeButton.setTitle("\(like_count)", for: .normal)
                    strongSelf.likeButton.setTitle("\(like_count)", for: .selected)
                    
                case .failure(error: let error):
                    print(error)
                }
            }
            
        }else{
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let vc = storyboard.instantiateViewController(withIdentifier: "AccountVC")
            present(vc, animated: true, completion: nil)
        }
    }
    
    @IBAction func onCollect(_ sender: UIButton) {
        if let user = LCApplication.default.currentUser{
            if collectButton.isSelected {
                do{
                    try user.remove("collects", element: post.objectId!)
                }catch{
                    print(error)
                }
            }else{
                do{
                    try user.append("collects", element: post.objectId!, unique: true)
                }catch{
                    print(error)
                }
            }
            
            _ = user.save {[weak self] (result) in
                guard let strongSelf = self else{return}
                switch result{
                case .success:
                    strongSelf.collectButton.isSelected = !strongSelf.collectButton.isSelected
                case .failure(error: let error):
                    print(error)
                }
            }
            
        }else{
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let vc = storyboard.instantiateViewController(withIdentifier: "AccountVC")
            present(vc, animated: true, completion: nil)
        }
    }
    
    
    // MARK: - Navigation
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "PostCommentEdit" && LCApplication.default.currentUser == nil{
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let vc = storyboard.instantiateViewController(withIdentifier: "AccountVC")
            present(vc, animated: true, completion: nil)
            return false
        }
        return true
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PostCommentEdit" {
            let vc = segue.destination as! TextEditVC
            vc.contentType = .post_comment
            vc.post = post
        }
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    

}

extension PostCommentVC: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCommentCell", for: indexPath) as! PostCommentCell
        cell.model = data[indexPath.row]
        return cell
    }
}

