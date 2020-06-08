//
//  Notification.swift
//  StarWelfare
//
//  Created by xinguang hu on 2020/1/9.
//  Copyright © 2020 weiyou. All rights reserved.
//

import Foundation

extension Notification.Name{
    struct App {
        static let RefreshPosts = Notification.Name(rawValue: "flowerlover.notification.name.RefreshPosts")
        static let RefreshQuestions = Notification.Name(rawValue: "flowerlover.notification.name.RefreshQuestions")
        static let RefreshComments = Notification.Name(rawValue: "flowerlover.notification.name.RefreshComments")
        static let RefreshAnswers = Notification.Name(rawValue: "flowerlover.notification.name.RefreshAnswers")
        static let UpdateUser = Notification.Name(rawValue: "flowerlover.notification.name.UpdateUser")
        static let UserDidSignIn = Notification.Name(rawValue: "flowerlover.notification.name.UserDidSignIn")
       
    }
}
