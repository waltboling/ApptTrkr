//
//  MainViewController.swift
//  ApptTrkr
//
//  Created by Jon Boling on 12/17/18.
//  Copyright © 2018 Walt Boling. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class MainViewController: UIViewController, UIScrollViewDelegate {
    
    private let headerViewCutaway: Float = 40.0
    private var databaseHandle: DatabaseHandle!
    @IBOutlet weak var ApptTrkrLogoView: UIImageView!
    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var headerBackgroundView: UIView!
    
    @IBOutlet weak var customHeaderView: CustomHeaderView!
    
    var providers: [ServiceProvider] = []
    var providerKeys: [String] = []
    //var imageView = UIImageView()
    let ref = Database.database().reference()
    var indexTracker: Int?
    
    
    override func viewWillAppear(_ animated: Bool) {
        ref.child("service-provider").observe(.value, with: { snapshot in
            var newProviders: [ServiceProvider] = []
            var newProviderKeys: [String] = []

            for child in snapshot.children {
                 if let snapshot = child as? DataSnapshot,
                    let svcProvider = ServiceProvider(snapshot: snapshot) {
                    newProviders.append(svcProvider)
                    newProviderKeys.append(snapshot.key)
                }
            }
            self.providers = newProviders
            self.providerKeys = newProviderKeys
            self.mainTableView.reloadData()
        })
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainTableView.allowsSelection = false
        mainTableView.contentInset = UIEdgeInsets(top: ApptTrkrLogoView.bounds.height, left: 0, bottom: 0, right: 0)
        //mainTableView.contentOffset = CGPoint(x: 0, y: -ApptTrkrLogoView.frame.height)
     
        
        view.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1.0)
        floatButton(target: self, action: #selector(handleLogout), forEvent: .touchUpInside)
        
        
        mainTableView.register(MainCell.self, forCellReuseIdentifier: "Cell")
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleAddProvider))
        navigationItem.rightBarButtonItem?.tintColor = UIColor.ATColors.lightBlue
        
        
        
        let navBar = self.navigationController?.navigationBar
        //navBar?.barTintColor = UIColor.ATColors.white
        navBar?.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name:"Lato-Medium", size: 20)!, .foregroundColor: UIColor.darkGray]
        navigationItem.title = "Providers"
        
        
    }
    
    @objc func handleAddProvider(_ sender: UIBarButtonItem) {
        let storyboard: UIStoryboard = UIStoryboard(name:"Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "NewProviderSheet")
        viewController.modalPresentationStyle = .popover
        let popover: UIPopoverPresentationController = viewController.popoverPresentationController!
        //popover.barButtonItem = sender
        popover.delegate = self
        present(viewController, animated: true, completion:nil)
    }
    
    @objc func handleLogout() {
        let signInVC = SignInViewController()
        showAlert(title: "Logout", message: "Are you ready to end your session?", buttonString: "Logout")
        print("signing out user")
        GIDSignIn.sharedInstance()?.signOut()
        //do i need to also sign out of Firebase or does GoogleSignIn handle that? (code for Firebase below)
        /*let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            /*AuthenticationManager.sharedInstance.loggedIn = false
            dismiss(animated: true, completion: nil)*/
        } catch let signOutError as NSError {
            print ("Error signing out: \(signOutError)")
        }*/
        
        self.dismiss(animated: true, completion: nil) // seems to work fine

    }
    
}

extension MainViewController: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let y = 300 - (scrollView.contentOffset.y + 300)
        //let y = scrollView.contentOffset.y * -1
        let height = min(max(y, 60), 500)
        ApptTrkrLogoView.frame = CGRect(x: 0, y: 82, width: UIScreen.main.bounds.size.width, height: height)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}

extension MainViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return providers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MainCell
        let provider = providers[indexPath.row]
        
        cell.providerNameLabel.text = provider.name
        //cell.providerTypeLabel.textColor = UIColor.darkGray
        cell.providerTypeLabel.text = provider.type
        //cell.providerTypeLabel.textColor = UIColor.lightGray
        
        //cell.providerBtn.addTarget(self, action: #selector(providerBtnAction), for: .touchUpInside)
    
        /*cell.tapAction = {
            (cell) in print(self.mainTableView.indexPath(for: (cell))!.row)
        }*/
        cell.apptTapAction = {
            print(indexPath.row)
            self.indexTracker = indexPath.row
           // self.apptBtnAction()
            self.buttonSegues(buttonType: "Appt")
        }
        
        cell.providerTapAction = {
            print(indexPath.row)
            self.indexTracker = indexPath.row
            self.buttonSegues(buttonType: "Provider")
        }
        
        cell.apptBtn.addTarget(cell, action: #selector(cell.apptButtonTap), for: .touchUpInside)
        cell.providerBtn.addTarget(cell, action: #selector(cell.providerButtonTap), for: .touchUpInside)
        
        return cell
    }
    
    
    /*@objc func providerBtnAction() {
        buttonSegues(buttonType: "Provider")
    }
    
    @objc func apptBtnAction() {

        buttonSegues(buttonType: "Appt")
    }*/
    
    func buttonSegues(buttonType: String) {
        switch buttonType {
        case "Provider":
            performSegue(withIdentifier: "toProviderDetail", sender: self)
        case "Appt":
            performSegue(withIdentifier: "toApptDetail", sender: self)
        default:
            print("something went wrong with the button segue")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backBarItem = UIBarButtonItem()
        backBarItem.title = ""
        backBarItem.tintColor = UIColor.ATColors.lightRed
        navigationItem.backBarButtonItem = backBarItem
        if segue.identifier == "toApptDetail" {
            if let indexTracker = indexTracker {
                let currentProvider = providers[indexTracker]
                let currentKey = providerKeys[indexTracker]
                let destinationVC = segue.destination as! ApptViewController
                destinationVC.currentProvider = currentProvider
                destinationVC.currentProviderKey = currentKey
            }
        } else if segue.identifier == "toProviderDetail" {
            if let indexTracker = indexTracker {
                let currentProvider = providers[indexTracker]
                let currentKey = providerKeys[indexTracker]
                let destinationVC = segue.destination as! ProviderViewController
                destinationVC.currentProvider = currentProvider
                destinationVC.currentKey = currentKey
            }
        }
    }
}

extension MainViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .fullScreen
    }
    
    /*func presentationController(_ controller: UIPresentationController, viewControllerForAdaptivePresentationStyle style: UIModalPresentationStyle) -> UIViewController? {
        let navigationController = UINavigationController(rootViewController: controller.presentedViewController)
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(MainViewController.dismissViewController))
        navigationController.topViewController?.navigationItem.rightBarButtonItem = doneButton
        return navigationController
        
    }
    
    @objc func dismissViewController() {
        self.dismiss(animated: true, completion: nil)
        //code for reloading tableview data will go somewhere here or in viewWillAppear
    }*/
}
