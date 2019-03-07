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
import SwiftKeychainWrapper

class MainViewController: UIViewController, UIScrollViewDelegate, UITabBarControllerDelegate {
    
    private let headerViewCutaway: Float = 40.0
    private var databaseHandle: DatabaseHandle!
    @IBOutlet weak var ApptTrkrLogoView: UIImageView!
    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var headerBackgroundView: UIView!
    
    @IBOutlet weak var customHeaderView: CustomHeaderView!
    
    var providers: [ServiceProvider] = []
    var providerKeys: [String] = []
    let ref = Database.database().reference()
    var indexTracker: Int?
    var passedUID: String?
    var userDefaults = UserDefaults()
    let searchController = UISearchController(searchResultsController: nil)
    var unFilteredPros: [ServiceProvider] = []
    var providerImage = UIImage()

    override func viewWillAppear(_ animated: Bool) {
        let userRef = ref.child("users").child(passedUID!)
        userRef.child("service-provider").observe(.value, with: { snapshot in
            var newProviders: [ServiceProvider] = []
            var newProviderKeys: [String] = []

            for child in snapshot.children {
                 if let snapshot = child as? DataSnapshot,
                    let svcProvider = ServiceProvider(snapshot: snapshot) {
                    newProviders.append(svcProvider)
                    newProviderKeys.append(snapshot.key)
                }
            }
            self.unFilteredPros = newProviders
            self.providers = newProviders
            self.providerKeys = newProviderKeys
            self.mainTableView.reloadData()
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AppReviewManager.checkAndAskForReview()

        if let uid = KeychainWrapper.standard.string(forKey: "uid") {
            passedUID = uid
        }
        
        tabBarController?.delegate = self
        
        mainTableView.register(MainCell.self, forCellReuseIdentifier: "Cell")

        mainTableView.allowsSelection = false
        mainTableView.contentInset = UIEdgeInsets(top: ApptTrkrLogoView.bounds.height, left: 0, bottom: 0, right: 0)
        view.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1.0)
        floatButton(target: self, action: #selector(handleLogout), forEvent: .touchUpInside)
        
        configureNavBar()
        configureSearchBar()
    }
    
    //MARK: -Configure UI
    
    func configureNavBar() {
        let navBar = self.navigationController?.navigationBar
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleAddProvider))
        navigationItem.rightBarButtonItem?.tintColor = UIColor.ATColors.lightBlue
    
        navBar?.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name:"Lato-Medium", size: 20)!, .foregroundColor: UIColor.darkGray]
        navigationItem.title = "Providers"
    }
    
    func configureSearchBar() {
        providers = unFilteredPros
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        navigationItem.titleView = searchController.searchBar
        searchController.hidesNavigationBarDuringPresentation = false
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let tabBarIndex = tabBarController.selectedIndex
        
        if tabBarIndex == 0 {
            self.mainTableView.setContentOffset(CGPoint(x: 0, y: -200), animated: true)
        }
    }
    
    //MARK: -Handler methods
    
    @objc func handleAddProvider(_ sender: UIBarButtonItem) {
        let storyboard: UIStoryboard = UIStoryboard(name:"Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "NewProviderSheet")
        viewController.modalPresentationStyle = .popover
        let popover: UIPopoverPresentationController = viewController.popoverPresentationController!
        popover.delegate = self
        present(viewController, animated: true, completion:nil)
    }
    
    //log out of Firebase with correct provider
    @objc func handleLogout() {
        let auth = Auth.auth()
        let providerData = auth.currentUser?.providerData

        for data in providerData! {
           let signInVC = storyboard?.instantiateViewController(withIdentifier: "SignInViewController")
            switch data.providerID {
            case "google.com":
                GIDSignIn.sharedInstance()?.signOut()
                //print("signing out google user")
                do {
                    try auth.signOut()
                   // print("signing google user out of FB")
                    if let vc = signInVC {
                        present(vc, animated: true, completion: nil)
                    }
                } catch let signOutError as NSError {
                    //print ("Error signing out google user: \(signOutError)")
                }
                break
            case "password":
                do {
                    try auth.signOut()
                    //print("signing password user out of FB")
                    AuthenticationManager.sharedInstance.loggedIn = false
                    if let vc = signInVC {
                        present(vc, animated: true, completion: nil)
                    }
                } catch let signOutError as NSError {
                    //print ("Error signing out password user: \(signOutError)")
                }
                break
            default:
                showAlert(title: "Oops!", message: "There was an error logging out", buttonString: "Ok")
            }
        }
    }
}


//MARK: -Tableview DataSource and Delegate
extension MainViewController: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let y = 300 - (scrollView.contentOffset.y + 300)
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
        let urlString = provider.imageURL
        if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                if let error = error {
                    //print(error)
                    return
                } else {
                    DispatchQueue.main.async {
                        if let downloadedImage = UIImage(data: data!) {
                            imageCache.setObject(downloadedImage, forKey: urlString as AnyObject)
                        }
                    }
                }
            }).resume()
        }
        cell.providerNameLabel.text = provider.name
        cell.providerTypeLabel.text = provider.type
        cell.apptTapAction = {
            //print(indexPath.row)
            self.indexTracker = indexPath.row
           // self.apptBtnAction()
            self.buttonSegues(buttonType: "Appt")
        }
        cell.providerTapAction = {
            //print(indexPath.row)
            self.indexTracker = indexPath.row
            self.buttonSegues(buttonType: "Provider")
        }
        cell.apptBtn.addTarget(cell, action: #selector(cell.apptButtonTap), for: .touchUpInside)
        cell.providerBtn.addTarget(cell, action: #selector(cell.providerButtonTap), for: .touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let currentKey = providerKeys[indexPath.row]
            let currentProvider = providers[indexPath.row]
            let userRef = ref.child("users").child(passedUID!)
            let providerRef = userRef.child("service-provider")
            let imageURL = currentProvider.imageURL
            let apptRef = userRef.child("appointment")
            self.providers.remove(at: indexPath.row)

            providerRef.child("\(currentKey)").removeValue { (error, ref) in
                if error != nil {
                    self.showAlert(title: "Oops!", message: "There was an error deleting the current provider", buttonString: "Ok")
                    //print("error at \(currentKey)")
                    return
                }
                
                //deletes any image in storage associated with provider
                if imageURL != "" {
                    let storageRef = Storage.storage().reference(forURL: imageURL)
                    storageRef.delete(completion: { (error) in
                        if error != nil {
                        } else {
                        }
                    })
                }
                
                //deletes all appts associated with provider
                apptRef.observe(.value , with: { snapshot in
                    for child in snapshot.children {
                        if let snapshot = child as? DataSnapshot,
                            let appt = Appointment(snapshot: snapshot) {
                            let apptKey = snapshot.key
                            if appt.providerKey == currentKey {
                                apptRef.child(apptKey).removeValue()
                            }
                        }
                    }
                })

                tableView.reloadData()
            }
        }
    }
    
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
}

extension MainViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if searchController.searchBar.text! == "" {
            providers = unFilteredPros
        } else if let searchStr = searchController.searchBar.text?.lowercased() {
            providers = unFilteredPros.filter({ (($0.name.description.lowercased().contains(searchStr)) || ($0.type.description.lowercased().contains(searchStr)))
                //how to include more search options in same function
            })
        }
        
        self.mainTableView.reloadData()
    }
}
