//
//  ViewController.swift
//  ApptTrkr
//
//  Created by Jon Boling on 12/17/18.
//  Copyright © 2018 Walt Boling. All rights reserved.
//

import UIKit
import GoogleSignIn
import FirebaseUI
//import Firebase

class SignInViewController: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate {
    
    
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailLoginBtn: UIButton!
    @IBOutlet weak var emailSignUpBtn: UIButton!
    
    var customWhite = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1.0)
    var customBlue = UIColor(red: 0.39, green: 0.49, blue: 0.575, alpha: 1.0)
    var customRed = UIColor(red: 0.64, green: 0.1176, blue: 0.13, alpha: 0.8)
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    //let authViewController = AppDelegate.authUI.authViewController()
    //let ref = Database.database().reference()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        //FirebaseApp.configure()
        buildABottomBorder(textField: usernameTextField)
        buildABottomBorder(textField: passwordTextField)
        layoutBtns(button: emailSignUpBtn)
        layoutBtns(button: emailLoginBtn)
        
        // lboling begin
        let authUI = appDelegate.authUI
        //let authUI = FUIAuth.defaultAuthUI()
        //let authViewController = authUI!.authViewController()
        GIDSignIn.sharedInstance()?.delegate = self

        //present(authViewController, animated: true, completion: nil)
        GIDSignIn.sharedInstance().uiDelegate = self
        //GIDSignIn.sharedInstance()?.signIn()
        
        //Uncomment to automatically sign in the user.
        GIDSignIn.sharedInstance().signInSilently()
        
        // TODO(developer) Configure the sign-in button look/feel
        // ...

        //authUI?.delegate = self
        
    }
    
    //building some UI
    
    func buildABottomBorder(textField: UITextField) {
    let border = CALayer()
    let width = CGFloat(1.0)
    border.borderColor = customWhite.cgColor
    border.frame = CGRect(x: 0, y: textField.frame.size.height - width, width: textField.frame.size.width, height: textField.frame.size.height)
    
    border.borderWidth = width
    textField.layer.addSublayer(border)
    textField.layer.masksToBounds = true
    }
    
    func layoutBtns(button: UIButton) {
        button.layer.cornerRadius = 3
        button.backgroundColor = customWhite
        button.tintColor = customRed
        button.setTitleColor(customRed, for: .normal)
    }
    
    //sign in methods
    
    
    //doesnt hit this code - is this still true??? 2/6/19
    func authUI(_ authUI: FUIAuth, didSignInWith user: User?, error: Error?) {
        if let error = error {
            print("error signing in; see VC code", error)
        } else {
           /* let userRef = ref.child("users").childByAutoId()
            let userID = user?.uid
            userRef.child(userID!)*/
            performSegue(withIdentifier: "toMainVC", sender: self)
        }
        
    }
    
   
    @IBAction func userDidSignIn(_ sender: Any) {
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        // ...
        if let error = error {
            print("Failed to log into Google", error)
            return
        }
        
        print("Successfully logged into Google", user)
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        // ...
        Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
            if let error = error {
                print("Failed to create a Firebase user with Google account: ", error)
                return
            }
            // User is signed in
            //let userRef = self.ref.child("users").childByAutoId()
            //let userID = user.userID
            //userRef.child(userID!)
            print("Succcessfully logged into Firebase with Google", user.userID)
            
            self.performSegue(withIdentifier: "toMainVC", sender: self)
            // ...
        }
    }
}


