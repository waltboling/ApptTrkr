//
//  ProviderViewController.swift
//  ApptTrkr
//
//  Created by Jon Boling on 12/17/18.
//  Copyright © 2018 Walt Boling. All rights reserved.
//

import UIKit
import Firebase

class ProviderViewController: UIViewController {
   
    
    @IBOutlet weak var providerTableView: UITableView!
    
    @IBOutlet weak var providerThumbnail: UIImageView!
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    @IBOutlet weak var providerNameLabel: UILabel!
    
    @IBOutlet weak var providerTypeLabel: UILabel!
    
    @IBOutlet weak var backgroundColorView: UIView!
    
    var currentProvider: ServiceProvider?
    var editBtnText = "Edit"
    var canEdit = false
    //var serviceProvider: ServiceProvider?
    var appointment: Appointment?
    var providerName: String?
    var providerType: String?
    var website: String?
    var email: String?
    var phone: String?
    var fax: String?
    var address: String?
    var notes: String?
    var currentKey: String?
    let userDefaults = UserDefaults()
    
    override func viewWillAppear(_ animated: Bool) {
        //providerThumbnail.isHidden = true
        if let thumbnailURL = currentProvider?.imageURL {
            if let url = URL(string: thumbnailURL) {
                URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                    if let error = error {
                        print(error)
                        return
                    } else {
                        DispatchQueue.main.async { //wish this was faster loading
                            //self.providerThumbnail.isHidden = false
                            self.providerThumbnail.image = UIImage(data: data!)
                        }
                    }
                }).resume()
            }
        } else {
            providerThumbnail.image = UIImage(named: "ATPlaceholderImage")
        }
        //could also add a local cache to hold onto images once downloaded if performance needs this (NSCache)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        providerName = currentProvider?.name
        providerType = currentProvider?.type
        website = currentProvider?.website
        email = currentProvider?.email
        phone = currentProvider?.phoneNumber
        fax = currentProvider?.fax
        address = currentProvider?.address
        notes = currentProvider?.notes
        //providerThumbnail.isHidden = false
        
        /*if currentProvider?.imageURL == "" {
            providerThumbnail.image = UIImage(named: "doctorStockImg")
        }*/
        providerThumbnail.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleThumbnailSelector)))
        providerThumbnail.isUserInteractionEnabled = true
        
        providerTableView.allowsSelection = false
        
        providerNameLabel.text = providerName
        providerNameLabel.font = UIFont(name: "Lato-Regular", size: 20)
        providerTypeLabel.text = providerType
        providerTypeLabel.font = UIFont(name: "Lato-Medium", size: 18)
      
        let navBar = navigationController?.navigationBar
        navBar?.tintColor = UIColor.darkGray
        navBar?.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name:"Lato-Medium", size: 18)!, .foregroundColor: UIColor.darkGray]
        navigationItem.title = "Provider Info"

        providerTableView.contentInset = UIEdgeInsets(top: backgroundImageView.bounds.height, left: 0, bottom: 0, right: 0)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: editBtnText, style: .plain, target: self, action: #selector(handleEdit))
        navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name:"Lato-Medium", size: 17)!, .foregroundColor: UIColor.ATColors.lightRed], for: .normal)
        
        providerTableView.register(ProviderNotesCell.self, forCellReuseIdentifier: "providerNotesCell")
        
            providerThumbnail.layer.cornerRadius = providerThumbnail.frame.height / 2

        // Do any additional setup after loading the view.
    }
    
   
    
    
    //need to check and see if this does anything; if not, how to make it
    func detectDataTypes(textfield: UITextField) {
        let input = textfield.text
        let dataDetector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.allSystemTypes.rawValue)
        let matches = dataDetector.matches(in: input!, options: [], range: NSRange(location: 0, length: input!.utf16.count))
        
        for match in matches {
            guard let range = Range(match.range, in: input!) else { continue }
            let specialDataType = input![range]
            print(specialDataType)
        }
    }
    @objc func handleEdit() {
        if canEdit == false {
            navigationItem.rightBarButtonItem?.title = "Done"
            canEdit = true
            providerTableView.reloadData()
        } else {
            navigationItem.rightBarButtonItem?.title = "Edit"
            canEdit = false
            providerTableView.reloadData()
        }
        
        
        }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ProviderViewController: UITableViewDataSource, UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let y = 300 - (scrollView.contentOffset.y + 300)
        //let y = scrollView.contentOffset.y * -1
        let backgroundHeight = min(max(y, 60), 500)
        let thumbnailY = 150 - (scrollView.contentOffset.y + 150)
        let thumbnailHeight = min(max(thumbnailY, 50), 150)
        let width = UIScreen.main.bounds.size.width
        backgroundImageView.frame = CGRect(x: 0, y: 85, width: width, height: backgroundHeight)
        backgroundColorView.frame = CGRect(x: 0, y: 85, width: width, height: backgroundHeight)
        providerThumbnail.frame = CGRect(x: backgroundImageView.frame.width / 2 - providerThumbnail.frame.width * 0.5, y: backgroundImageView.frame.height / 2 - 33, width: thumbnailHeight, height: thumbnailHeight)
        providerThumbnail.layer.cornerRadius = providerThumbnail.bounds.height / 2
        
        let nameHeight = providerNameLabel.frame.height
        let nameWidth = providerNameLabel.frame.width
        let typeHeight = providerTypeLabel.frame.height
        let typeWidth = providerTypeLabel.frame.width
        let offsetHeight = (backgroundImageView.frame.height / 2) + providerThumbnail.frame.height - 25
        
        providerNameLabel.frame = CGRect(x: UIScreen.main.bounds.midX - (providerNameLabel.frame.width * 0.5), y: offsetHeight, width: nameWidth, height: nameHeight)
        providerTypeLabel.frame = CGRect(x: UIScreen.main.bounds.midX - (providerTypeLabel.frame.width * 0.5), y: offsetHeight  + providerTypeLabel.frame.height + 5, width: typeWidth, height: typeHeight)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
            case 0:
                return 5
            case 1:
                return 1
            default:
                print("something is wrong with number of rows")
                return 0
        }
    }
    
    //here just need to create switch on cell, casting all but notes cell as a providerCell. will need to make slightly diff cell for that one
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
            case 0:
                let baseCell = tableView.dequeueReusableCell(withIdentifier: "providerNotesCell", for: indexPath) as! ProviderNotesCell
                //detectDataTypes(textfield: baseCell.infoView) // works but only after toggling edit switch. needs to work on load
                baseCell.infoView.isEditable = canEdit
                baseCell.infoView.dataDetectorTypes = .all
                switch indexPath.row {
                case 0:
                    baseCell.headingLabel.text = "Website"
                    if canEdit == true {
                        //baseCell.infoView.placeholder = "enter website..."
                    } else {
                        baseCell.infoView.text = website
                        baseCell.infoView.textContentType = UITextContentType.URL
                    }
                    baseCell.cellIcon.setBackgroundImage(UIImage(named: "webIcon"), for: .normal)
                    return baseCell
                    
                case 1:
                    baseCell.headingLabel.text = "Phone Number"
                    if canEdit == true {
                        //baseCell.infoView.placeholder = "enter phone number..."
                    } else {
                        let formattedNumber = phone?.toPhoneNumber()
                        baseCell.infoView.text = formattedNumber
                        baseCell.infoView.textContentType = UITextContentType.telephoneNumber
                        
                    }
                    baseCell.cellIcon.setBackgroundImage(UIImage(named: "phoneIcon"), for: .normal)
                    return baseCell
                    
                case 2:
                    baseCell.headingLabel.text = "Email"
                    if canEdit == true {
                        //baseCell.infoView.placeholder = "enter email..."
                    } else {
                        baseCell.infoView.text = email
                    }
                    baseCell.cellIcon.setBackgroundImage(UIImage(named: "emailIcon"), for: .normal)
                    return baseCell
                    
                case 3:
                    baseCell.headingLabel.text = "Address"
                    if canEdit == true {
                        //baseCell.infoView.placeholder = "enter address..."
                    } else {
                        baseCell.infoView.text = address
                    }
                    baseCell.cellIcon.setBackgroundImage(UIImage(named: "addressIcon"), for: .normal)
                    return baseCell
                    
                case 4:
                    let formattedNumber = fax?.toPhoneNumber()
                    baseCell.headingLabel.text = "Fax"
                    if canEdit == true {
                        //baseCell.infoView.placeholder = "enter fax..."
                    } else {
                        baseCell.infoView.text = formattedNumber
                    }
                    baseCell.cellIcon.setBackgroundImage(UIImage(named: "faxIcon"), for: .normal)
                    return baseCell
                    
                default:
                    fatalError("There was a problem loading base cells")
                }
            case 1:
                let notesCell = tableView.dequeueReusableCell(withIdentifier: "providerNotesCell", for: indexPath) as! ProviderNotesCell
                notesCell.infoView.isEditable = canEdit
                switch indexPath.row {
                case 0:
                    notesCell.headingLabel.text = "Notes"
                    //make textview extension for placeholder text
                    notesCell.cellIcon.setBackgroundImage(UIImage(named: "notesIcon"), for: .normal)
                    notesCell.infoView.text = notes
                    notesCell.infoView.dataDetectorTypes = .all
                    return notesCell
                default:
                    fatalError("failed to load notes cell")
                }
            default:
                fatalError("failed to load cells")
            }
    }
}

extension ProviderViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @objc func handleThumbnailSelector() {
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var selectedImageFromPicker: UIImage?
        let uniqueStr = UUID().uuidString
        let storageRef = Storage.storage().reference().child("\(uniqueStr).png")
        let currentUID = userDefaults.value(forKey: "uid") as! String
        let userRef = Database.database().reference().child("users").child(currentUID)
        let providerDBRef = userRef.child("service-provider")
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] {
            selectedImageFromPicker = editedImage as? UIImage
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] {
            selectedImageFromPicker = originalImage as? UIImage
        }
        
        DispatchQueue.main.async {
            if let selectedImage = selectedImageFromPicker {
                self.providerThumbnail.image = selectedImage
                if let uploadData = self.providerThumbnail.image!.pngData() {
                    storageRef.putData(uploadData, metadata: nil) { (metadata, error) in
                        if let error = error {
                            print(error)
                            return
                        }
                        //saving img to storage WORKS; sending it to DB does not yet. need to update servprov properties i think
                        storageRef.downloadURL(completion: { (url, error) in
                            if error != nil {
                                print("Failed to download url:", error!)
                                return
                            } else {
                                if let url = url {
                                    let urlString = url.absoluteString
                                    //WORKS! updates url value w/ selected image. now need to write fetch code and also think about default img
                                    providerDBRef.child("\(self.currentKey!)").updateChildValues(["imageURL" : urlString])
                                }
                                //sleep(2)
                            }
                            
                        })
                    }
                    
                }
            }
        }
        
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
       
}
