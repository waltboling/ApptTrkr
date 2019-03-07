//
//  AppReviewManager.swift
//  ApptTrkr
//
//  Created by Jon Boling on 3/7/19.
//  Copyright © 2019 Walt Boling. All rights reserved.
//

import Foundation
import StoreKit

let userDefaults = UserDefaults.standard

struct AppReviewManager {
    
    static func incrementAppOpenedCount() { // called from appdelegate didfinishLaunchingWithOptions:
        guard var appOpenCount = userDefaults.value(forKey: "appOpenCount") as? Int else {
            userDefaults.set(1, forKey: "appOpenCount")
            return
        }
        appOpenCount += 1
        userDefaults.set(appOpenCount, forKey: "appOpenCount")
    }
    
    static func checkAndAskForReview() { // call this whenever appropriate
        // this will not be shown everytime. Apple has some internal logic on how to show this.
        guard let appOpenCount = userDefaults.value(forKey: "appOpenCount") as? Int else {
            userDefaults.set(1, forKey: "appOpenCount")
            return
        }
        
        switch appOpenCount {
        case 10,50:
            AppReviewManager().requestReview()
        case _ where appOpenCount%100 == 0 :
            AppReviewManager().requestReview()
        default:
            print("App run count is : \(appOpenCount)")
            break;
        }
        
    }
    
    fileprivate func requestReview() {
        if #available(iOS 10.3, *) {
            SKStoreReviewController.requestReview()
        } else {
            return
        }
    }
}
