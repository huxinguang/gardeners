//
//  AppDelegate.swift
//  FlowerLover
//
//  Created by xinguang hu on 2020/2/18.
//  Copyright © 2020 xjy. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import LeanCloud
import QCloudCore
import QCloudCOSXML


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        sleep(1)
        
        setUpKeyboard()
        setupCOSXMLShareService()
        LCApplication.logLevel = .all
        do {
            try LCApplication.default.set(
                id: "GBVJ0pSIdII85dSMrIb65R8F-MdYXbMMI",
                key: "qFljwIpKrRnx5Ch7wfa1foF9"
            )
        } catch {
            fatalError("\(error)")
        }
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.white
        let sb = UIStoryboard(name: "Main", bundle: Bundle.main)
        let tabbarVc = sb.instantiateViewController(withIdentifier: "TabbarVC")
        window?.rootViewController = tabbarVc
        window?.makeKeyAndVisible()
        
        return true
    }
    
    private func setUpKeyboard(){
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = false
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
    }
    
    private func setupCOSXMLShareService(){
        let configuration = QCloudServiceConfiguration.init()
        configuration.appID = Constant.Thirdparty.qCloudAppID
        configuration.signatureProvider = self
        let endpoint = QCloudCOSXMLEndPoint.init()
        endpoint.regionName = Constant.Thirdparty.qCloudRegion
        configuration.endpoint = endpoint
        QCloudCOSXMLService.registerDefaultCOSXML(with: configuration)
        QCloudCOSTransferMangerService.registerDefaultCOSTransferManger(with: configuration)
    }

    private func sessionLogin (){
        if let token = UserDefaults.standard.object(forKey: "sessionToken") as? String{
            _ = LCUser.logIn(sessionToken: token) { (result) in
                switch result {
                case .success(object: let user):
                    // 登录成功
                    print(user)
                case .failure(error: let error):
                    // session token 无效
                    print(error)
                }
            }
        }
        
    }
    


}

extension AppDelegate : QCloudSignatureProvider{
    
    func signature(with fileds: QCloudSignatureFields!, request: QCloudBizHTTPRequest!, urlRequest urlRequst: NSMutableURLRequest!, compelete continueBlock: QCloudHTTPAuthentationContinueBlock!) {
        
        let credential = QCloudCredential.init()
        credential.secretID = Constant.Thirdparty.qCloudSecretID
        credential.secretKey = Constant.Thirdparty.qCloudSecretKey
        let creator = QCloudAuthentationV5Creator.init(credential: credential)
        let signature = creator?.signature(forData: urlRequst)
        continueBlock(signature,nil)
    }
    
}

