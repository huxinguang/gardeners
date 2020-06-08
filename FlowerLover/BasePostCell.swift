//
//  BasePostCell.swift
//  FlowerLover
//
//  Created by xinguang hu on 2020/2/25.
//  Copyright © 2020 xjy. All rights reserved.
//

import UIKit
import SnapKit
import DynamicColor
import LeanCloud
import Kingfisher
import SwiftDate
import SKPhotoBrowser

class BasePostCell: UITableViewCell {
    var avatarButton: UIButton!
    var levelIcon: UIImageView!
    var nameLabel: UILabel!
    var timeLabel: UILabel!
    var contentLabel: UILabel!
    var placeholderView: UIView!
    var placeholderHeightConstraint: Constraint!
    var likeButton: UIButton!
    var commentButton: UIButton!
    var moreButton: UIButton!
    lazy var imageViews = [UIImageView]()
    fileprivate var model: LCObject!
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override class var requiresConstraintBasedLayout: Bool{
        return true
    }
    
    func setupUI() {
        avatarButton = UIButton(type: .custom)
        var image = UIImage(named: "fl_default_icon")
        avatarButton.setImage(image, for: .normal)
        contentView.addSubview(avatarButton)
        avatarButton.snp.makeConstraints { (make) in
            make.top.leading.equalToSuperview().offset(10)
            make.size.equalTo(image!.size)
        }
        
        levelIcon = UIImageView()
        image = UIImage(named: "fl_lv1")
        levelIcon.image = image
        contentView.addSubview(levelIcon)
        levelIcon.snp.makeConstraints { (make) in
            make.top.equalTo(avatarButton)
            make.leading.equalTo(avatarButton.snp.trailing).offset(10)
            make.size.equalTo(image!.size)
        }
        
        nameLabel = UILabel()
        nameLabel.text = "jacky"
        nameLabel.textColor = .black
        nameLabel.font = UIFont.systemFont(ofSize: 14, weight: .light)
        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(levelIcon.snp.trailing).offset(5)
            make.centerY.equalTo(levelIcon)
            make.trailing.equalToSuperview().offset(-10)
        }
        
        timeLabel = UILabel()
        timeLabel.textColor = .lightGray
        timeLabel.font = UIFont.systemFont(ofSize: 13, weight: .light)
        contentView.addSubview(timeLabel)
        timeLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(levelIcon)
            make.bottom.equalTo(avatarButton)
        }
        
        contentLabel = UILabel()
        contentLabel.numberOfLines = 10
        contentLabel.textColor = UIColor(hexString: "999999")
        contentLabel.font = UIFont.systemFont(ofSize: 15, weight: .light)
        contentView.addSubview(contentLabel)
        contentLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(avatarButton)
            make.top.equalTo(avatarButton.snp.bottom).offset(20)
            make.trailing.equalToSuperview().offset(-10)
        }
        
        placeholderView = UIView()
        contentView.addSubview(placeholderView)
        placeholderView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(contentLabel.snp.bottom).offset(10)
            placeholderHeightConstraint = make.height.equalTo(0).priority(.required).constraint
        }
        
        likeButton = UIButton(type: .custom)
        image = UIImage(named: "fl_like_n")
        likeButton.setImage(image, for: .normal)
        likeButton.setImage(UIImage(named: "fl_like_s"), for: .selected)
        likeButton.setTitle("like", for: .normal)
        likeButton.setTitleColor(UIColor(hexString: "999999"), for: .normal)
        likeButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .light)
        likeButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -10)
        likeButton.isUserInteractionEnabled = false
        contentView.addSubview(likeButton)
        likeButton.snp.makeConstraints { (make) in
            make.top.equalTo(placeholderView.snp.bottom).offset(15)
            make.leading.equalToSuperview().offset(20)
            make.bottom.equalToSuperview().offset(-15)
        }
        
        commentButton = UIButton(type: .custom)
        image = UIImage(named: "fl_comment")
        commentButton.setImage(image, for: .normal)
        commentButton.setTitle("comment", for: .normal)
        commentButton.setTitleColor(UIColor(hexString: "999999"), for: .normal)
        commentButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .light)
        commentButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -10)
        commentButton.isUserInteractionEnabled = false
        contentView.addSubview(commentButton)
        commentButton.snp.makeConstraints { (make) in
            make.leading.equalTo(likeButton.snp.trailing).offset(40)
            make.centerY.equalTo(likeButton)
        }
        
        moreButton = UIButton(type: .custom)
        image = UIImage(named: "fl_more")
        moreButton.setImage(image, for: .normal)
        contentView.addSubview(moreButton)
        moreButton.addTarget(self, action: #selector(onMoreClick), for: .touchUpInside)
        moreButton.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().offset(-20)
            make.centerY.equalTo(commentButton)
        }
        
    }
    
    func update(with model: LCObject) {
        self.model = model
        let user = model.get("user") as! LCObject
        nameLabel.text = user.get("nickname")?.stringValue
        let avatar = user.get("avatar")?.stringValue ?? ""
        avatarButton.kf.setImage(with: URL(string: avatar), for: .normal, placeholder: UIImage(named: "fl_default_icon"))

        let date = model.get("createdAt")?.dateValue
        timeLabel.text = date?.toRelative(style: RelativeFormatter.defaultStyle(), locale: Locales.english)
        contentLabel.text = model.get("content")?.stringValue
        likeButton.setTitle("\(model.get("like_count")?.intValue ?? 0)", for: .normal)
        commentButton.setTitle("\(model.get("comment_count")?.intValue ?? 0)", for: .normal)
        
        
        let pics = model.get("pics") as! LCArray
        if pics.count == 1 {
            let pic = pics[0] as! LCObject
            let width = pic.get("width")?.floatValue
            let height = pic.get("height")?.floatValue
            let picH = UIScreen.main.bounds.size.width * CGFloat(height!)/CGFloat(width!)
            placeholderHeightConstraint.update(offset: picH)
        }else{
            placeholderHeightConstraint.update(offset: UIScreen.main.bounds.size.width)
            
        }
        
        for i in 0..<imageViews.count {
            let imageView = imageViews[i]
            let url = (pics[i] as! LCObject).get("url")?.stringValue
            imageView.kf.setImage(with: URL(string: url!))
        }
    }
    
    @objc func onImageTapped(gesture: UITapGestureRecognizer) {
        var images = [SKPhoto]()
        let pics = model.get("pics") as! LCArray
        for item in pics {
            let pic = item as! LCObject
            let url = pic.get("url")?.stringValue
            let photo = SKPhoto.photoWithImageURL(url!)
            photo.shouldCachePhotoURLImage = false
            images.append(photo)
        }
        let browser = SKPhotoBrowser(photos: images)
        browser.initializePageIndex(gesture.view!.tag)
        UIViewController.currentViewController().present(browser, animated: true, completion: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @objc
    func onMoreClick() {
        
        let alertVC = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
        let action1 = UIAlertAction.init(title: "Shield post", style: .default) { (action) in
            self.shieldPost()
        }
        let action2 = UIAlertAction.init(title: "Shield user", style: .default) { (action) in
            self.shieldUser()
        }
        let action3 = UIAlertAction.init(title: "Report", style: .default) { (action) in
            self.report()
        }
        let action4 = UIAlertAction.init(title: "Cancel", style: .cancel) { (action) in
        }
        alertVC.addAction(action1)
        alertVC.addAction(action2)
        alertVC.addAction(action3)
        alertVC.addAction(action4)
        UIViewController.currentViewController().present(alertVC, animated: true, completion: nil)
    }
    
    private func shieldPost(){
        if let user = LCApplication.default.currentUser{
            let shield_user = model.get("user") as! LCObject
            if shield_user.objectId == user.objectId {
                MBProgressHUD.showTipMessageInView(message: "Don't shield yourself", hideDelay: 1.5)
                return
            }
            do{
                try user.append("shield_posts", element: model.objectId!, unique: true)
            }catch{
                print(error)
            }
            _ = user.save { (result) in
                switch result{
                case .success:
                    NotificationCenter.default.post(name: NSNotification.Name.App.RefreshPosts, object: nil)
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
    
    private func shieldUser(){
        if let user = LCApplication.default.currentUser{
            let shield_user = model.get("user") as! LCObject
            if shield_user.objectId == user.objectId {
                MBProgressHUD.showTipMessageInView(message: "Don't shield yourself", hideDelay: 1.5)
                return
            }
            do{
                try user.append("shield_users", element: shield_user, unique: true)
            }catch{
                print(error)
            }
            _ = user.save {(result) in
                switch result{
                case .success:
                    NotificationCenter.default.post(name: NSNotification.Name.App.RefreshPosts, object: nil)
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
    
    private func report(){
        let report = LCObject(className: "Report")
        do {
            try report.set("post", value: model)
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


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
