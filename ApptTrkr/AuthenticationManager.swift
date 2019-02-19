//
//  AuthenticationManager.swift
//  ApptTrkr
//
//  Created by Jon Boling on 1/10/19.
//  Copyright © 2019 Walt Boling. All rights reserved.
//

import Foundation
import Firebase

class AuthenticationManager: NSObject {
    static let sharedInstance = AuthenticationManager()
    
    var loggedIn = false
    var userName: String?
    var userId: String?
    
    func didLogIn(user: User) {
        AuthenticationManager.sharedInstance.userName = user.displayName
        AuthenticationManager.sharedInstance.loggedIn = true
        AuthenticationManager.sharedInstance.userId = user.uid
    }
}
