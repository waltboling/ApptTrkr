//
//  ApptViewController.swift
//  ApptTrkr
//
//  Created by Jon Boling on 12/17/18.
//  Copyright © 2018 Walt Boling. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

protocol PassProviderDelegate {
    func setProvider(provider: ServiceProvider?)
    func setKey(providerKey: String?)
}

class ApptViewController: UIViewController {

    //MARK: -IBOutlets
    @IBOutlet weak var providerThumbnail: UIImageView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var apptTableView: UITableView!
    @IBOutlet weak var providerNameLabel: UILabel!
    @IBOutlet weak var providerTypeLabel: UILabel!
    @IBOutlet weak var headerView: UIView!
    
    var currentProvider: ServiceProvider?
    var currentProviderKey: String?
    var delegate: PassProviderDelegate?
    let ref = Database.database().reference()
    var appointments: [Appointment] = []
    var indexTracker = 0
    let userDefaults = UserDefaults()
    var appointmentKeys: [String] = []
    var currentUID = ""
    
    override func viewWillAppear(_ animated: Bool) {
        //currentUID = userDefaults.value(forKey: "uid") as! String
        if let uid = KeychainWrapper.standard.string(forKey: "uid") {
            currentUID = uid
        }
        
        let userRef = ref.child("users").child(currentUID)
        let query = userRef.child("appointment").queryOrdered(byChild: "date")

        query.observe(.value, with: { snapshot in
            var newAppointments: [Appointment] = []
            var apptKeys: [String] = []
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                    let appt = Appointment(snapshot: snapshot) {
                    if appt.providerKey == self.currentProviderKey {
                        let key = snapshot.key
                        newAppointments.append(appt)
                        apptKeys.append(key)
                    }
                }
            }
            
            self.appointments = newAppointments
            self.appointmentKeys = apptKeys
            self.apptTableView.reloadData()
        })
        
        if let thumbnailURL = currentProvider?.imageURL {
            providerThumbnail.loadImageUsingCacheWithURLString(urlString: thumbnailURL)
        } else {
            providerThumbnail.image = UIImage(named: "ATPlaceholderImage")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavBar()
        configureHeader()
        
        apptTableView.allowsSelection = false
        apptTableView.register(ApptTableViewCell.self, forCellReuseIdentifier: "apptCell")
        apptTableView.contentInset = UIEdgeInsets(top: backgroundImageView.bounds.height, left: 0, bottom: 0, right: 0)
        
        providerNameLabel.text = currentProvider?.name
        providerTypeLabel.text = currentProvider?.type
    }
    
    
    //MARK: -Configure UI
    func configureNavBar() {
        let navBar = navigationController?.navigationBar
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleAddAppt))
        navigationItem.rightBarButtonItem?.tintColor = UIColor.ATColors.lightRed
        
        navBar?.tintColor = UIColor.darkGray
        navBar?.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name:"Lato-Medium", size: 18)!, .foregroundColor: UIColor.darkGray]
        navigationItem.title = "\(currentProvider!.name) Appts"
    }
    
    func configureHeader() {
        let headerColor = UIColor.ATColors.lightBlue.withAlphaComponent(0.9)
        headerView.backgroundColor = headerColor
        providerThumbnail.isUserInteractionEnabled = true
        providerThumbnail.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleThumbnailSelector)))
        providerThumbnail.layer.cornerRadius = providerThumbnail.frame.height / 2
    }
    
    //MARK: -Handlers and Helpers
    @objc func handleAddAppt(_ sender: UIBarButtonItem) {
        let storyboard: UIStoryboard = UIStoryboard(name:"Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "NewApptSheet") as! NewApptSheetVC
        delegate = viewController
        viewController.modalPresentationStyle = .overCurrentContext
        viewController.modalTransitionStyle = .crossDissolve
        if delegate != nil {
            delegate?.setProvider(provider: currentProvider)
            delegate?.setKey(providerKey: currentProviderKey)
            present(viewController, animated: true, completion:nil)
        } else {
            //print("error with appointment delegate")
            return
        }
    }
    
    func handleNote() {
        let storyboard: UIStoryboard = UIStoryboard(name:"Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "noteView") as! NoteViewController
        viewController.modalPresentationStyle = .overCurrentContext
        viewController.modalTransitionStyle = .crossDissolve
        let appointment = appointments[indexTracker]
        if appointment.notes != "" {
            viewController.passedNote = appointment.notes
            //print(indexTracker)
            present(viewController, animated: true, completion: nil)
        } else {
            
            return
        }
    }
    
    @objc func handleThumbnailSelector() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    func stringToDate(dateString: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        dateFormatter.dateFormat = "yyyyMMdd"
        let dateFromString = dateFormatter.date(from: dateString)
        return dateFromString!
    }
    
    func dateToString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
}

extension ApptViewController: UITableViewDataSource, UITableViewDelegate {
    //Stretchy Header
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let y = 300 - (scrollView.contentOffset.y + 300)
        let backgroundHeight = min(max(y, 60), 500)
        let thumbnailY = 150 - (scrollView.contentOffset.y + 150)
        let thumbnailHeight = min(max(thumbnailY, 50), 150)
        let width = UIScreen.main.bounds.size.width
        
        let nameHeight = providerNameLabel.frame.height
        let nameWidth = providerNameLabel.frame.width
        let typeHeight = providerTypeLabel.frame.height
        let typeWidth = providerTypeLabel.frame.width
        let offsetHeight = (backgroundImageView.frame.height / 2) + providerThumbnail.frame.height  + 10
        
        backgroundImageView.frame = CGRect(x: 0, y: 82, width: width, height: backgroundHeight)
        headerView.frame = CGRect(x: 0, y: 82, width: width, height: backgroundHeight)
        providerThumbnail.frame = CGRect(x: backgroundImageView.frame.width / 2 - providerThumbnail.frame.width * 0.5, y: backgroundImageView.frame.height / 2, width: thumbnailHeight, height: thumbnailHeight)
        providerThumbnail.layer.cornerRadius = providerThumbnail.bounds.height / 2
        
        providerNameLabel.frame = CGRect(x: UIScreen.main.bounds.midX - (providerNameLabel.frame.width * 0.5), y: offsetHeight, width: nameWidth, height: nameHeight)
        providerTypeLabel.frame = CGRect(x: UIScreen.main.bounds.midX - (providerTypeLabel.frame.width * 0.5), y: offsetHeight  + providerTypeLabel.frame.height + 5, width: typeWidth, height: typeHeight)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appointments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "apptCell", for: indexPath) as! ApptTableViewCell
        let appt = appointments[indexPath.row]
        let formattedDate = stringToDate(dateString: appt.date)
        let formattedStr = dateToString(date: formattedDate)
        cell.apptTitle.text = appt.title
        cell.dateLabel.text = formattedStr
        if appt.notes == "" {
            cell.noteBtn.customizeFGImage(color: .gray)
            cell.noteBtn.isEnabled = false
        } else {
            cell.noteBtn.isEnabled = true
        }
        cell.noteBtn.addTarget(cell, action: #selector(cell.noteBtnTap), for: .touchUpInside)
        cell.noteTapAction = {
            self.indexTracker = indexPath.row
            self.handleNote()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let userRef = ref.child("users").child(currentUID)
            let apptRef = userRef.child("appointment")
            let apptKey = appointmentKeys[indexPath.row]
            self.appointments.remove(at: indexPath.row)
            
            apptRef.child("\(apptKey)").removeValue { (error, ref) in
                if error != nil {
                    self.showAlert(title: "Oops!", message: "There was an error deleting the current provider", buttonString: "Ok")
                    //print("error at \(apptKey)")
                    return
                }
                
                tableView.reloadData()
            }
        }
    }
}


extension ApptViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        
    return .fullScreen
    }
}

extension ApptViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
                            //print(error)
                            return
                        }
                        
                        storageRef.downloadURL(completion: { (url, error) in
                            if error != nil {
                                //print("Failed to download url:", error!)
                                return
                            } else {
                                if let url = url {
                                    let urlString = url.absoluteString
                                    providerDBRef.child("\(self.currentProviderKey!)").updateChildValues(["imageURL" : urlString])
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
