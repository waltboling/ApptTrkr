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
import Firebase

class SignInViewController: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate {
    
    
    @IBOutlet weak var emailTextField: UITextField!

    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailLoginBtn: UIButton!
    @IBOutlet weak var emailSignUpBtn: UIButton!
    
    var customWhite = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1.0)
    var customBlue = UIColor(red: 0.39, green: 0.49, blue: 0.575, alpha: 1.0)
    var customRed = UIColor(red: 0.64, green: 0.1176, blue: 0.13, alpha: 0.8)
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    //let authViewController = AppDelegate.authUI.authViewController()
    var userUID = ""
    var userEmail = ""
    var hasError = false
    var ref: DatabaseReference!
    var userDefaults = UserDefaults()
    
    override func viewWillAppear(_ animated: Bool) {
        emailTextField.text = ""
        passwordTextField.text = ""
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //FirebaseApp.configure()
        buildABottomBorder(textField: emailTextField)
        buildABottomBorder(textField: passwordTextField)
        layoutBtns(button: emailSignUpBtn)
        layoutBtns(button: emailLoginBtn)
        
        // lboling begin
        //let authUI = appDelegate.authUI
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
    
    
    //Google Sign In
   
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
            
            if let result = authResult {
                self.userUID = result.user.uid
                self.userEmail = result.user.email ?? ""
                print("user UID is \(self.userUID)")
                self.userDefaults.setValue(self.userUID, forKey: "uid")
                print("Succcessfully logged into Firebase with Google", user.userID)
                self.performSegue(withIdentifier: "toMainVC", sender: self)
            }
        }
    }

    //Email Sign-In
    
    private var usersHandle: DatabaseHandle!
    
    @IBAction func emailLoginTapped(_ sender: Any) {
        didLogIn()
    }
    
    @IBAction func emailSignUpTapped(_ sender: Any) {
        //ref = Database.database().reference()
        didSignUp()
        
    }
    
   /* override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toMainVC" {
            let barVC = segue.destination as! UITabBarController
            let navCon = barVC.viewControllers?[0] as! UINavigationController
            let destinationVC = navCon.topViewController as! MainViewController
            destinationVC.passedUID = userUID
            destinationVC.passedUserEmail = userEmail
        }
    }*/
    
    func didLogIn() {
        guard let email = emailTextField.text, let password = passwordTextField.text, email.count > 0, password.count > 0 else {
            self.showAlert(title: "Error logging in", message: "Enter an email and a password.", buttonString: "Ok")
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if let error = error {
                if error._code == AuthErrorCode.userNotFound.rawValue {
                    self.showAlert(title: "Error logging in", message: "There are no users with the specified account. Sign up to continue", buttonString: "Ok")
                } else if error._code == AuthErrorCode.wrongPassword.rawValue {
                    self.showAlert(title: "Error logging in", message: "Password does not match that of provided email", buttonString: "Ok")
                } else {
                    self.showAlert(title: "Error", message: "\(error.localizedDescription)", buttonString: "Ok")
                }
                print(error.localizedDescription)
                return
            }
            
            if let user = user {
                AuthenticationManager.sharedInstance.didLogIn(user: user.user)
                self.ref = Database.database().reference()
                self.setUserName(user: user.user, name: email)
                self.userUID = user.user.uid
                self.userEmail = user.user.email!
                print("user UID is \(self.userUID)")
                self.userDefaults.setValue(self.userUID, forKey: "uid")
                //self.performSegue(withIdentifier: "toMainVC", sender: nil)
            }
        }
    }
    
    func didSignUp() {
        guard let email = emailTextField.text,
            let password = passwordTextField.text,
            email.count > 0,
            password.count > 0
            else {
                self.showAlert(title: "Error signing in", message: "Enter an email and a password.", buttonString: "Ok")
                hasError = true
                return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if let error = error {
                if error._code == AuthErrorCode.invalidEmail.rawValue {
                    self.showAlert(title: "Invalid email", message: "Enter a valid email.", buttonString: "Ok")
                } else if error._code == AuthErrorCode.emailAlreadyInUse.rawValue {
                    self.showAlert(title: "Error", message: "Email already in use.", buttonString: "Ok")
                } else {
                    self.showAlert(title: "Error", message: "\(error.localizedDescription)", buttonString: "Ok")
                }
                print(error.localizedDescription)
                self.hasError = true
                return
            }
            
            if let user = user {
                self.ref = Database.database().reference()
                self.setUserName(user: user.user, name: email)
                self.userUID = user.user.uid
                self.userEmail = user.user.email!
                print("user UID is \(self.userUID)")
                
                let usersReference = self.ref.child("users").child(self.userUID)
                
                let userInfo = [
                    "userEmail": self.userEmail,
                    "uid": self.userUID
                ]
                self.userDefaults.setValue(self.userUID, forKey: "uid")
                
                usersReference.setValue(userInfo, withCompletionBlock: {
                    (err, ref) in
                    
                    if err != nil {
                        //need to handle this more and display to user
                        print(err)
                        self.hasError = true
                        return
                    }
                    print("Successfully saved user \(email) into list")
                })
            }
        }
        
  
        
        //moved code above without manual errorhandling
        /*if (!hasError){
            let usersReference = ref.child("users").childByAutoId()
            
            let userInfo = [
                "userEmail": email,
                "uid": userUID
            ]
            
            usersReference.setValue(userInfo, withCompletionBlock: {
                (err, ref) in
                
                if err != nil {
                    //need to handle this more and display to user
                    print(err)
                    self.hasError = true
                    return
                }
                print("Successfully saved user \(email) into list")
            })
        }*/
    }
    
    
    //probably dont need most of this
    func setUserName(user: User, name: String) {
        let changeRequest = user.createProfileChangeRequest()
        changeRequest.displayName = name
        
        changeRequest.commitChanges(){ (error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            AuthenticationManager.sharedInstance.didLogIn(user: user)
            self.performSegue(withIdentifier: "toMainVC", sender: nil)
        }
    }
}


