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
import SwiftKeychainWrapper

class SignInViewController: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate {
    
    var customWhite = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1.0)
    var customBlue = UIColor(red: 0.39, green: 0.49, blue: 0.575, alpha: 1.0)
    var customRed = UIColor(red: 0.64, green: 0.1176, blue: 0.13, alpha: 0.8)
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var userUID = ""
    var userEmail = ""
    var hasError = false
    var ref: DatabaseReference!
    var userDefaults = UserDefaults()
    var resetText: String?
    var progressWheel: UIActivityIndicatorView?
    
    //MARK: -IBOutlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailLoginBtn: UIButton!
    @IBOutlet weak var emailSignUpBtn: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        if let username = KeychainWrapper.standard.string(forKey: "userEmail") {
            emailTextField.text = username
            passwordTextField.text = ""
        } else {
            emailTextField.text = ""
            passwordTextField.text = ""
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
                
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        
        buildABottomBorder(textField: emailTextField)
        buildABottomBorder(textField: passwordTextField)
        layoutBtns(button: emailSignUpBtn)
        layoutBtns(button: emailLoginBtn)
        
        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        
        view.addGestureRecognizer(tap)
    }
    
    func startSpinner() {
        DispatchQueue.main.async {
            self.progressWheel = self.showSpinner(view: self.view)
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    //MARK: -Build and Layout UI
    
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
    
    //MARK: -Sign in methods
    
    //Google Sign In
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        // ...
        startSpinner()
        if error != nil {
            //print("Failed to log into Google", error)
            DispatchQueue.main.async {
                self.progressWheel?.dismissSpinner()
            }
            return
        }
        
        //print("Successfully logged into Google", user)
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        
        Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
            DispatchQueue.main.async {
                self.progressWheel?.dismissSpinner()
            }
            
            if let error = error {
                //print("Failed to create a Firebase user with Google account: ", error)
                return
            }
            
            if let result = authResult {
                let mainTBC = self.storyboard?.instantiateViewController(withIdentifier: "MainTBC") as? UITabBarController
                self.userUID = result.user.uid
                self.userEmail = result.user.email ?? ""
                //print("user UID is \(self.userUID)")
                //self.userDefaults.setValue(self.userUID, forKey: "uid")
                KeychainWrapper.standard.set(self.userUID, forKey: "uid")
                //print("Succcessfully logged into Firebase with Google", user.userID)

                if let tabBarController = mainTBC {
                    self.present(tabBarController, animated: true, completion: nil)
                }
            }
        }
    }

    //Email Sign-In
    
    @IBAction func emailLoginTapped(_ sender: Any) {
        didLogIn()
    }
    
    @IBAction func emailSignUpTapped(_ sender: Any) {
        didSignUp()
    }
    
    @IBAction func forgotPassBtnTapped(_ sender: Any) {
        sendPasswordReset()
    }
    
    //MARK: -Handler methods
    
    func sendPasswordReset() {
        let alertController = UIAlertController(title: "Reset Password?", message: "An email will be sent to the account given with further instructions", preferredStyle: .alert)
        let sendAction = UIAlertAction(title: "Send", style: .default, handler: { (alert) in
            self.handlePasswordReset()
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (alert) in
            alertController.dismiss(animated: true, completion: nil)
            
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(sendAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func didLogIn() {
        startSpinner()
        guard let email = emailTextField.text, let password = passwordTextField.text, email.count > 0, password.count > 0 else {
            self.showAlert(title: "Error logging in", message: "Enter an email and a password to continue.", buttonString: "Ok")
            DispatchQueue.main.async {
                self.progressWheel?.dismissSpinner()
            }
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            DispatchQueue.main.async {
                self.progressWheel?.dismissSpinner()
            }
            if let error = error {
                if error._code == AuthErrorCode.userNotFound.rawValue {
                    self.showAlert(title: "Error logging in", message: "There are no users with the specified account. Sign up to continue", buttonString: "Ok")
                } else if error._code == AuthErrorCode.wrongPassword.rawValue {
                    self.showAlert(title: "Error logging in", message: "Password does not match that of provided email", buttonString: "Ok")
                } else {
                    self.showAlert(title: "Error", message: "\(error.localizedDescription)", buttonString: "Ok")
                }
                //print(error.localizedDescription)
                
                return
            }
            
            if let user = user {
                AuthenticationManager.sharedInstance.didLogIn(user: user.user)
                self.ref = Database.database().reference()
                self.setUserName(user: user.user, name: email)
                self.userUID = user.user.uid
                self.userEmail = user.user.email!
                KeychainWrapper.standard.set(self.userUID, forKey: "uid")
                KeychainWrapper.standard.set(self.userEmail, forKey: "userEmail")
            }
        }
    }
    
    func didSignUp() {
        startSpinner()
        guard let email = emailTextField.text,
            let password = passwordTextField.text,
            email.count > 0,
            password.count > 0
            else {
                self.showAlert(title: "Error signing in", message: "Enter an email and a password to continue.", buttonString: "Ok")
                DispatchQueue.main.async {
                    self.progressWheel?.dismissSpinner()
                }
                return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            DispatchQueue.main.async {
                self.progressWheel?.dismissSpinner()
            }
            if let error = error {
                if error._code == AuthErrorCode.invalidEmail.rawValue {
                    self.showAlert(title: "Invalid email", message: "Enter a valid email.", buttonString: "Ok")
                } else if error._code == AuthErrorCode.emailAlreadyInUse.rawValue {
                    self.showAlert(title: "Error", message: "Email already in use.", buttonString: "Ok")
                } else {
                    self.showAlert(title: "Error", message: "\(error.localizedDescription)", buttonString: "Ok")
                }
                //print(error.localizedDescription)
                return
            }
            
            if let user = user {
                self.ref = Database.database().reference()
                self.setUserName(user: user.user, name: email)
                self.userUID = user.user.uid
                self.userEmail = user.user.email!
                //print("user UID is \(self.userUID)")
//                KeychainWrapper.standard.set(self.userEmail, forKey: "ATUsername")
//                KeychainWrapper.standard.set(password, forKey: "ATPassword")
                //self.userDefaults.setValue(self.userEmail, forKey: "userEmail")
                KeychainWrapper.standard.set(self.userEmail, forKey: "userEmail")

                let usersReference = self.ref.child("users").child(self.userUID)
                let userInfo = [
                    "userEmail": self.userEmail,
                    "uid": self.userUID
                ]
               // self.userDefaults.setValue(self.userUID, forKey: "uid")//maybe replace with keychain store/retrieve
                KeychainWrapper.standard.set(self.userUID, forKey: "uid")
                
                usersReference.setValue(userInfo, withCompletionBlock: {
                    (err, ref) in
                    if err != nil {
                        //print(err)
                        self.showAlert(title: "Error logging in user", message: "Try again later", buttonString: "Ok")
                        return
                    }
                    //print("Successfully saved user \(email) into list")
                })
            }
        }
    }
    
    //probably dont need most of this
    func setUserName(user: User, name: String) {
        let mainTBC = storyboard?.instantiateViewController(withIdentifier: "MainTBC") as? UITabBarController
        AuthenticationManager.sharedInstance.didLogIn(user: user)
        if let tabBarController = mainTBC {
            self.present(tabBarController, animated: true, completion: nil)
            
            //checking to see if changerequest is needed...
            /*let changeRequest = user.createProfileChangeRequest()
             changeRequest.displayName = name
             changeRequest.commitChanges() { (error) in
             if let error = error {
             print(error.localizedDescription)
             return
             }
    
             AuthenticationManager.sharedInstance.didLogIn(user: user)
             if let tabBarController = mainTBC {
             self.present(tabBarController, animated: true, completion: nil)
             }*/
        }
    }
    
    func handlePasswordReset() {
        guard let email = self.emailTextField.text,
            email.count > 5 else {
                self.showAlert(title: "Enter Email", message: "Please enter a valid email in the email field to receive password reset instructions", buttonString: "Ok")
                return
        }
        
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if error != nil {
                self.showAlert(title: "Reset Error", message: "User not found. Please enter an existing user email or sign up to continue", buttonString: "Ok")
            } else {
                self.showAlert(title: "Email Sent!", message: "An email has been sent to \(email) with instructions for reseting your password", buttonString: "Ok")
            }
        }
    }
}


