//
//  ProviderViewController.swift
//  ApptTrkr
//
//  Created by Jon Boling on 12/17/18.
//  Copyright © 2018 Walt Boling. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class ProviderViewController: UIViewController {
   
    //MARK: -IBOutlets
    @IBOutlet weak var providerTableView: UITableView!
    @IBOutlet weak var providerThumbnail: UIImageView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var providerNameLabel: UILabel!
    @IBOutlet weak var providerTypeLabel: UILabel!
    @IBOutlet weak var backgroundColorView: UIView!
    
    var currentProvider: ServiceProvider?
    var editBtnText = "Edit"
    var canEdit = false
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
    var textViewPlaceholder = "enter text..."
    let ref = Database.database().reference()
    var providerDict: [String: Any] = [:]
    
    override func viewWillAppear(_ animated: Bool) {
        if let thumbnailURL = currentProvider?.imageURL {
            providerThumbnail.loadImageUsingCacheWithURLString(urlString: thumbnailURL)
        } else {
            providerThumbnail.image = UIImage(named: "ATPlaceholderImage")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        
        setProviderValues()
        configureHeader()
        
        providerTableView.allowsSelection = false
        providerTableView.contentInset = UIEdgeInsets(top: backgroundImageView.bounds.height, left: 0, bottom: 0, right: 0)
        providerTableView.register(ProviderBaseCell.self, forCellReuseIdentifier: "ProviderBaseCell")
        providerTableView.register(ProviderPhoneCell.self, forCellReuseIdentifier: "ProviderPhoneCell")
    
        view.addGestureRecognizer(tap)
    }
    
    func setProviderValues() {
        providerName = currentProvider?.name
        providerType = currentProvider?.type
        website = currentProvider?.website
        email = currentProvider?.email
        phone = currentProvider?.phoneNumber
        fax = currentProvider?.fax
        address = currentProvider?.address
        notes = currentProvider?.notes
    }
    
    //MARK: -Configure UI
    func configureNavBar() {
        let navBar = navigationController?.navigationBar
        navBar?.tintColor = UIColor.darkGray
        navBar?.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name:"Lato-Medium", size: 18)!, .foregroundColor: UIColor.darkGray]
        navigationItem.title = "Provider Info"

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: editBtnText, style: .plain, target: self, action: #selector(handleEdit))
        navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name:"Lato-Medium", size: 17)!, .foregroundColor: UIColor.ATColors.lightRed], for: .normal)
    }
    
    func configureHeader() {
        providerThumbnail.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleThumbnailSelector)))
        providerThumbnail.isUserInteractionEnabled = true
        providerThumbnail.layer.cornerRadius = providerThumbnail.frame.height / 2

        
        providerNameLabel.text = providerName
        providerNameLabel.font = UIFont(name: "Lato-Regular", size: 20)
        providerTypeLabel.text = providerType
        providerTypeLabel.font = UIFont(name: "Lato-Medium", size: 18)
    }
    
    
    //MARK: -Handlers and Helpers
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func handleEdit() {
        if canEdit == false { // goes into edit mode
            canEdit = true
            navigationItem.rightBarButtonItem?.title = "Done"
            providerTableView.reloadData()
        } else {
            canEdit = false // exits edit mode / text is read only
            navigationItem.rightBarButtonItem?.title = "Edit"
            updateProvider()
            providerTableView.reloadData()
        }
    }
    
    func updateProvider() {
        //let userUID = userDefaults.value(forKey: "uid") as! String
        let userUID = KeychainWrapper.standard.string(forKey: "uid")
        let userRef = ref.child("users").child(userUID ?? "")
        let providerRef = userRef.child("service-provider").child(currentKey!)
        for i in 0...5 {
            if let cell = providerTableView.cellForRow(at: IndexPath(row: i, section: 0)) as? ProviderBaseCell{
                if !(cell.infoView.text.testForEmpty()) && cell.infoView.text != textViewPlaceholder {
                    switch i {
                    case 0:
                        website = cell.infoView.text
                        providerDict["website"] = website
                    case 1:
                        continue
                    case 2:
                        email = cell.infoView.text
                        providerDict["email"] = email
                    case 3:
                        address = cell.infoView.text
                        providerDict["address"] = address
                    case 4:
                        continue
                    case 5:
                        notes = cell.infoView.text
                        providerDict["notes"] = notes
                    default:
                        self.showAlert(title: "Error updating providers", message: "Try again later", buttonString: "Ok")
                    }
                }
            }
        }
        
        //handles phone and fax cells separately
        let phoneCell = providerTableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? ProviderPhoneCell
        let faxCell = providerTableView.cellForRow(at: IndexPath(row: 4, section: 0)) as? ProviderPhoneCell
        if !(phoneCell?.infoField.text.testForEmpty())! {
            phone = phoneCell?.infoField.text
            providerDict["phone"] = phone
        }
    
        if !(faxCell?.infoField.text.testForEmpty())! {
            fax = faxCell?.infoField.text
            providerDict["fax"] = fax
        }
        
        providerRef.updateChildValues(providerDict, withCompletionBlock: {
            (err, ref) in
            
            if err != nil {
                //print(error)
                return
            }
        })
    }
}

extension ProviderViewController: UITableViewDataSource, UITableViewDelegate {
    //stretchy header
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let y = 300 - (scrollView.contentOffset.y + 300)
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
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var baseCell = ProviderBaseCell()
        var phoneCell = ProviderPhoneCell()
        if indexPath.row != 1 && indexPath.row != 4 {
            baseCell = tableView.dequeueReusableCell(withIdentifier: "ProviderBaseCell", for: indexPath) as! ProviderBaseCell
        } else {
            phoneCell = tableView.dequeueReusableCell(withIdentifier: "ProviderPhoneCell") as! ProviderPhoneCell
        }
        phoneCell.infoField.delegate = self
        baseCell.infoView.delegate = self
        baseCell.infoView.isEditable = canEdit
        baseCell.infoView.dataDetectorTypes = .all
        
        if canEdit == true {
            baseCell.infoView.textColor = UIColor.lightGray
            if baseCell.infoView.text.isEmpty {
                baseCell.infoView.text = textViewPlaceholder
            }
            if baseCell.infoView.text == textViewPlaceholder {
                baseCell.infoView.textColor = UIColor.lightGray
            }
        } else {
            baseCell.infoView.textColor = UIColor.ATColors.darkGray
        }
        
        switch indexPath.row {
            case 0:
                baseCell.headingLabel.text = "Website"
                if canEdit == true {
                    baseCell.infoView.autocapitalizationType = .none
                    baseCell.infoView.autocorrectionType = .no
                } else {
                    baseCell.infoView.text = website
                    baseCell.infoView.textContentType = UITextContentType.URL
                }
                
                baseCell.cellIcon.setBackgroundImage(UIImage(named: "webIcon"), for: .normal)
                return baseCell
            
            case 1:
                if canEdit == true {
                    phoneCell.headingLabel.text = "Phone Number"
                    if phone == "" {
                        phoneCell.infoField.placeholder = textViewPlaceholder
                    } else {
                        phoneCell.infoField.placeholder = phone?.toPhoneNumber()
                    }
                    phoneCell.cellIcon.setBackgroundImage(UIImage(named: "phoneIcon"), for: .normal)
                    return phoneCell
                } else {
                    baseCell.infoView.text = phone?.toPhoneNumber()
                    baseCell.headingLabel.text = "Phone Number"
                    baseCell.infoView.textContentType = UITextContentType.telephoneNumber
                    baseCell.cellIcon.setBackgroundImage(UIImage(named: "phoneIcon"), for: .normal)
                    return baseCell
                }
            
            case 2:
                baseCell.headingLabel.text = "Email"
                if canEdit == true {
                    baseCell.infoView.autocorrectionType = .no
                    baseCell.infoView.autocapitalizationType = .none
                } else {
                    baseCell.infoView.text = email
                    baseCell.infoView.tag = 1
                }
                baseCell.cellIcon.setBackgroundImage(UIImage(named: "emailIcon"), for: .normal)
                return baseCell
            
            case 3:
                baseCell.headingLabel.text = "Address"
                if canEdit == true {
                    baseCell.infoView.autocorrectionType = .default
                    baseCell.infoView.autocapitalizationType = .words
                    baseCell.infoView.tag = 1
                } else {
                    baseCell.infoView.text = address
                }
                baseCell.cellIcon.setBackgroundImage(UIImage(named: "addressIcon"), for: .normal)
                return baseCell
            
            case 4:
                if canEdit == true {
                    phoneCell.headingLabel.text = "Fax"
                    phoneCell.infoField.tag = 3
                    if fax == "" {
                        phoneCell.infoField.placeholder = textViewPlaceholder
                    } else {
                        phoneCell.infoField.placeholder = fax?.toPhoneNumber()
                    }
                    phoneCell.cellIcon.setBackgroundImage(UIImage(named: "faxIcon"), for: .normal)
                    return phoneCell
                } else {
                    baseCell.infoView.text = fax?.toPhoneNumber()
                    baseCell.headingLabel.text = "Fax"
                    baseCell.infoView.textContentType = UITextContentType.telephoneNumber
                    baseCell.cellIcon.setBackgroundImage(UIImage(named: "faxIcon"), for: .normal)
                    return baseCell
                }
            case 5:
                baseCell.headingLabel.text = "Notes"
                baseCell.infoView.returnKeyType = .default
                baseCell.cellIcon.setBackgroundImage(UIImage(named: "notesIcon"), for: .normal)
                if canEdit == true {
                    baseCell.infoView.autocorrectionType = .default
                    baseCell.infoView.autocapitalizationType = .sentences
                    baseCell.infoView.tag = 2
                } else {
                    baseCell.infoView.text = notes
                }
                return baseCell
            default:
                fatalError("There was a problem loading base cells")
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
        //let currentUID = userDefaults.value(forKey: "uid") as! String
        let currentUID = KeychainWrapper.standard.string(forKey: "uid")
        let userRef = Database.database().reference().child("users").child(currentUID ?? "")
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
                        if error != nil {
                            return
                        }
                        storageRef.downloadURL(completion: { (url, error) in
                            if error != nil {
                                //print("Failed to download url:", error!)
                                return
                            } else {
                                if let url = url {
                                    let urlString = url.absoluteString
                                    providerDBRef.child("\(self.currentKey!)").updateChildValues(["imageURL" : urlString])
                                }
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

extension ProviderViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == textViewPlaceholder {
            textView.text = ""
            textView.textColor = UIColor.ATColors.darkGray
        }
        if textView.tag == 1 {
            providerTableView.setContentOffset(CGPoint(x: 0, y: 80), animated: true)

        } else if textView.tag == 2 {
           providerTableView.setContentOffset(CGPoint(x: 0, y: 180), animated: true)
        }
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = textViewPlaceholder
            textView.textColor = UIColor.lightGray
        }
        providerTableView.setContentOffset(CGPoint(x: 0, y: -240), animated: true)
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if textView.tag != 2 {
            if (text == "\n") {
                textView.resignFirstResponder()
            }
            return text != "\n"
        }
        else {
            return true
        }
    }
}

extension ProviderViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.tag == 3 {
        providerTableView.setContentOffset(CGPoint(x: 0, y: 180), animated: true)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == 3 {
            providerTableView.setContentOffset(CGPoint(x: 0, y: -240), animated: true)
        }
    }
}
