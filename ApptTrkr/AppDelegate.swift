//
//  AppDelegate.swift
//  ApptTrkr
//
//  Created by Jon Boling on 12/17/18.
//  Copyright © 2018 Walt Boling. All rights reserved.
//

import UIKit
import CoreData
import GoogleSignIn
import Firebase
import FirebaseUI


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, FUIAuthDelegate, GIDSignInDelegate {

    var window: UIWindow?
    let providers: [FUIAuthProvider] = [
        FUIGoogleAuth()
        ]
    
    var authUI : FUIAuth?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        
        authUI = FUIAuth.defaultAuthUI()
        authUI!.delegate = self
        
        self.authUI!.providers = providers
        
        let db = Database.database()
        db.isPersistenceEnabled = true
        
        //Google Sign in:
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        
        //setting rootVC and onboarding on user's first launch
        window = UIWindow(frame: UIScreen.main.bounds)
        let mainSB = UIStoryboard(name: "Main", bundle: nil)
        var initialVC = mainSB.instantiateViewController(withIdentifier: "Onboarding")
        let userDefaults = UserDefaults.standard
        
        if userDefaults.bool(forKey: "onboardingComplete") {
            if Auth.auth().currentUser != nil {
                initialVC = (mainSB.instantiateViewController(withIdentifier: "MainTBC") as? UITabBarController)!
            } else {
                initialVC = mainSB.instantiateViewController(withIdentifier: "SignInViewController")
            }
        }
        
        window?.rootViewController = initialVC
        window?.makeKeyAndVisible()
        
        AppReviewManager.incrementAppOpenedCount()
        
        return true
    }
    
    //Google sign in methods:
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance().handle(url as URL?,
                                                 sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
                                                 annotation: options[UIApplication.OpenURLOptionsKey.annotation])
    }
    
    //the following GID delegate methods are handled between here and the SignInVC
    //doesnt seem that the didSignInFor: code is hitting here but is in SignInVC
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        if let error = error {
            //print("Failed to log into Google", error)
            return
        }
        //print("Successfully logged into Google", user)
    
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)

        Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
            if let error = error {
                //print("Failed to create a Firebase user with Google account: ", error)
                return
            }
            // User is signed in
            //print("Successfully logged into Firebase with Google", user.userID)
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
 }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        GIDSignIn.sharedInstance()?.signOut()
        //print("did try to sign out user")
    }


}

