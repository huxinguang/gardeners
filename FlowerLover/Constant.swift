//
//  YbsConstant.swift
//  ItemFinder
//
//  Created by xinguang hu on 2019/8/8.
//  Copyright © 2019 huxinguang. All rights reserved.
//

import UIKit

enum Env: String {
    case debug
    case testFlight
    case appStore
}

struct Constant {
    
    static let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    static let build = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String
    
    // This is private because the use of 'appConfiguration' is preferred.
    private static let isTestFlight = Bundle.main.appStoreReceiptURL?.lastPathComponent == "sandboxReceipt"

    static var isDebug: Bool {
        #if DEBUG
        return true
        #else
        return false
        #endif
    }

    static var env: Env {
        if isDebug {
            return .debug
        } else if isTestFlight {
            return .testFlight
        } else {
            return .appStore
        }
    }
    
    struct Thirdparty {
        //umeng
        static let umengAppKey = "5dd244f2570df366a0000460"
        //wechat
        static let wechatAppId = "wx210a7f52fe066572"
        static let wechatAppSecret = "89c8e7d4b4ba5d63111d1df7ba079344"
        static let wechatUniversalLink = "https://admin.balamoney.com/starwelfare/"
        // qq
        static let qqAppId = "101722175"
        static let qqAppKey = "5d6ebdd38b506d39c6c6baa7344a4828"
        static let qqUniversalLink = "https://admin.balamoney.com/qq_conn/101722175"
        // tencent cos
        static let qCloudAppID = "1259131898"
        static let qCloudRegion = "ap-beijing"
        static let qCloudSecretID = "AKID2sSnzypHbfU3MSltFNFsHQP9fy1pPfhX"
        static let qCloudSecretKey = "kHYZNwFI8i28zbx3tb7OQDk24qRowoRp"
        static let qCloudBucket = "aso-cos-1259131898"
 
    }
    
    struct Response {
        static let success = "0000"
        static let code = "code"
        static let data = "data"
        static let message = "message"
        static let tokenExpired = "5555"
    }
    
    struct ReuseId {
        static let cell = "flowerlover.identifier.cell"
        static let header = "flowerlover.identifier.header"
        static let footer = "flowerlover.identifier.footer"
    }
    
    struct UserDefaults {
        static let userToken = "flowerlover.preference.key.name.userToken"
        static let userId = "flowerlover.preference.key.name.userId"
        static let tipHidden = "flowerlover.preference.key.name.tipHidden"
    }
    
    struct Folders {
        static let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        static let temporary = NSTemporaryDirectory()
    }
    
    
}
