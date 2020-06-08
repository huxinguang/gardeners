//
//  PostEditVC.swift
//  FlowerLover
//
//  Created by xinguang hu on 2020/2/29.
//  Copyright © 2020 xjy. All rights reserved.
//

import UIKit
import KMPlaceholderTextView
import TZImagePickerController
import LeanCloud
import QCloudCOSXML
import QCloudCore

typealias RefreshBlockOne = ()->Void

class PostEditVC: UIViewController {
    @IBOutlet weak var textView: KMPlaceholderTextView!
    @IBOutlet weak var collectionView: UICollectionView!
    var refreshBlock: RefreshBlockOne!
    
    lazy var items = [UIImage]()
    lazy var urls = [String]()
    private let addImage = UIImage(named: "fl_pic_add")
    private var uploadFailed = false
    lazy var selectedAssets = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.tintColor = Styles.Color.themeColor
        items.append(addImage!)

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onCancel(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onPost(_ sender: UIButton) {
        if textView.text?.count ?? 0 <= 0 || items.count <= 1{
            MBProgressHUD.showTipMessageInView(message: "Content required", hideDelay: 1.5)
            return
        }
        uploadImages()
    }
    
    private func showImagePicker(){
        let vc = TZImagePickerController(maxImagesCount: 10, delegate: self)
        vc?.selectedAssets = selectedAssets
        vc?.navLeftBarButtonSettingBlock = { leftBtn in
            leftBtn?.setImage(UIImage(named: "fl_picker_back"), for: .normal)
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
        present(vc!, animated: true, completion: nil)
    }
    
    private func uploadImages(){
        let queue = DispatchQueue(label: "image_upload_queue",attributes: .concurrent)
        let group = DispatchGroup()
        urls.removeAll()
        for _ in 0..<items.count-1{
            urls.append("image_url_placeholder")
        }
        
        MBProgressHUD.showActivityMessageInView(message: "")
        for i in 0..<items.count-1 {
            group.enter()
            queue.async(group: group, qos: .default, flags: []) {
                let put = QCloudCOSXMLUploadObjectRequest<AnyObject>()
                let data = self.items[i].jpegData(compressionQuality: 0.3)
                let time = Date().timeIntervalSince1970*1000
                let obj = String.init(format: "ios/%ld_%d.jpg", Int64(time),i)
                put.object = obj
                put.bucket = Constant.Thirdparty.qCloudBucket
                put.body = data as AnyObject
                put.setFinish {[weak self] (outputObject, error) in
                    guard let strongSelf = self else{return}
                    if error != nil{
                        strongSelf.uploadFailed = true
                    }else{
                        strongSelf.urls[i] = outputObject!.location
                    }
                    group.leave()
                }
                QCloudCOSTransferMangerService.defaultCOSTransferManager().uploadObject(put)
            }
        }
        
        group.notify(queue: DispatchQueue.main) { [weak self] in
            guard let strongSelf = self else{return}
            if !strongSelf.uploadFailed{
                strongSelf.saveArticle()
            }else{
                MBProgressHUD.hideHUD()
                MBProgressHUD.showTipMessageInView(message: "Uploading failed", hideDelay: 1.5)
            }
        }
    }
    
    private func saveArticle(){
        
        let currentUser = LCApplication.default.currentUser
        let circle = LCObject(className: "Post")
        // 注意：保存关联对象的同时，被关联的对象也会随之被保存到云端。
        do {
            try circle.set("content", value: textView.text!)
            try circle.set("user", value: currentUser)
            try circle.set("status", value: 0)
            var cps = [LCObject]()
            for i in 0..<items.count-1 {
                let img = items[i]
                let cp = LCObject(className: "Picture")
                try cp.set("width", value: Double(img.size.width))
                try cp.set("height", value: Double(img.size.height))
                try cp.set("url", value: urls[i])
                cps.append(cp)
            }
            try circle.set("pics", value: cps)
            
        } catch  {
            print(error)
        }
        
        circle.save {[weak self] (result) in
            switch result{
            case .success:
                MBProgressHUD.hideHUD()
                guard let strongSelf = self else {return}
                strongSelf.dismiss(animated: true) {
                    MBProgressHUD.showTipMessageInWindow(message: "Posted", hideDelay: 1.5)
                    NotificationCenter.default.post(name: NSNotification.Name.App.RefreshPosts, object: nil)
                }
            case .failure(error: let error):
                print(error)
                MBProgressHUD.hideHUD()
                
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

extension PostEditVC: UICollectionViewDelegate,UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EditPicCell", for: indexPath) as! EditPicCell
        //        cell.imgView.kf.setImage(with: URL.init(string: self.items[indexPath.item].pic_url!))
        cell.imageView.image = items[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == self.items.count-1 {
            showImagePicker()
        }else{
            
        }
    }
    
}

extension PostEditVC : TZImagePickerControllerDelegate{
    
    func imagePickerController(_ picker: TZImagePickerController!, didFinishPickingPhotos photos: [UIImage]!, sourceAssets assets: [Any]!, isSelectOriginalPhoto: Bool) {
        selectedAssets.removeAllObjects()
        selectedAssets.addObjects(from: assets)
        items.removeAll()
        items.append(contentsOf: photos)
        items.append(addImage!)
        collectionView.reloadData()
        collectionView.scrollToItem(at: IndexPath(item: items.count-1, section: 0), at: .right, animated: true)
    }
    
    
    
    
}

