//
//  ApptViewController.swift
//  ApptTrkr
//
//  Created by Jon Boling on 12/17/18.
//  Copyright © 2018 Walt Boling. All rights reserved.
//

import UIKit
import Firebase

protocol PassProviderDelegate {
    func setProvider(provider: ServiceProvider?)
    func setKey(providerKey: String?)
}

class ApptViewController: UIViewController {

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
    
    override func viewWillAppear(_ animated: Bool) {
        let currentUID = userDefaults.value(forKey: "uid") as! String
        let userRef = ref.child("users").child(currentUID)
        let query = userRef.child("appointment").queryOrdered(byChild: "date")
        // query orders dates properly. need to add button to reverse them - just use array method reverse() 
        query.observe(.value, with: { snapshot in
            var newAppointments: [Appointment] = []
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                    let appt = Appointment(snapshot: snapshot) {
                    if appt.providerKey == self.currentProviderKey {
                        newAppointments.append(appt)
                    }
                    
                }
            }
            self.appointments = newAppointments
            self.apptTableView.reloadData()
        })
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
            providerThumbnail.image = UIImage(named: "doctorStockImg")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let headerColor = UIColor.ATColors.lightBlue.withAlphaComponent(0.9)
        headerView.backgroundColor = headerColor
        
        apptTableView.allowsSelection = false
        providerThumbnail.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleThumbnailSelector)))
        providerThumbnail.isUserInteractionEnabled = true
        
        apptTableView.register(ApptTableViewCell.self, forCellReuseIdentifier: "apptCell")
        print(currentProviderKey!)
        providerThumbnail.layer.cornerRadius = providerThumbnail.frame.height / 2
        apptTableView.contentInset = UIEdgeInsets(top: backgroundImageView.bounds.height, left: 0, bottom: 0, right: 0)

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleAddAppt))
        navigationItem.rightBarButtonItem?.tintColor = UIColor.ATColors.lightRed
        
        let navBar = navigationController?.navigationBar
        navBar?.tintColor = UIColor.darkGray
        navBar?.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name:"Lato-Medium", size: 18)!, .foregroundColor: UIColor.darkGray]
        navigationItem.title = "\(currentProvider!.name) Appts"
        
        providerNameLabel.text = currentProvider?.name
        providerTypeLabel.text = currentProvider?.type
        
        // Do any additional setup after loading the view.
    }
    
    
    @objc func handleAddAppt(_ sender: UIBarButtonItem) {
        let storyboard: UIStoryboard = UIStoryboard(name:"Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "NewApptSheet") as! NewApptSheetVC
        delegate = viewController
        viewController.modalPresentationStyle = .overCurrentContext
        viewController.modalTransitionStyle = .crossDissolve
        /*let popover: UIPopoverPresentationController = viewController.popoverPresentationController!
        popover.barButtonItem = sender
        popover.delegate = self*/
        if delegate != nil {
            delegate?.setProvider(provider: currentProvider)
            delegate?.setKey(providerKey: currentProviderKey)
            present(viewController, animated: true, completion:nil)
        } else {
            print("error with appointment delegate")
            return
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

extension ApptViewController: UITableViewDataSource, UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let y = 300 - (scrollView.contentOffset.y + 300)
        //let y = scrollView.contentOffset.y * -1
        let backgroundHeight = min(max(y, 60), 500)
        let thumbnailY = 150 - (scrollView.contentOffset.y + 150)
        let thumbnailHeight = min(max(thumbnailY, 50), 150)
        let width = UIScreen.main.bounds.size.width
        backgroundImageView.frame = CGRect(x: 0, y: 82, width: width, height: backgroundHeight)
        headerView.frame = CGRect(x: 0, y: 82, width: width, height: backgroundHeight)
        providerThumbnail.frame = CGRect(x: backgroundImageView.frame.width / 2 - providerThumbnail.frame.width * 0.5, y: backgroundImageView.frame.height / 2, width: thumbnailHeight, height: thumbnailHeight)
        providerThumbnail.layer.cornerRadius = providerThumbnail.bounds.height / 2
        
        let nameHeight = providerNameLabel.frame.height
        let nameWidth = providerNameLabel.frame.width
        let typeHeight = providerTypeLabel.frame.height
        let typeWidth = providerTypeLabel.frame.width
        let offsetHeight = (backgroundImageView.frame.height / 2) + providerThumbnail.frame.height  + 10
        
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
        //cell.apptTitle.textColor = UIColor.ATColors.darkRed
        //cell.textLabel?.textColor = UIColor.ATColors.red
        cell.dateLabel.text = formattedStr
        //cell.detailTextLabel?.textColor = UIColor(red: 0.39, green: 0.49, blue: 0.575, alpha: 1.0)
        //cell.dateLabel.textColor = UIColor.ATColors.darkBlue
        if appt.notes == "" {
            //cell.noteBtn.isHidden = true
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
    
    //need to do more here
    func handleNote() {
        let storyboard: UIStoryboard = UIStoryboard(name:"Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "noteView") as! NoteViewController
        //delegate = viewController as? PassProviderDelegate
        viewController.modalPresentationStyle = .overCurrentContext
        viewController.modalTransitionStyle = .crossDissolve
        let appointment = appointments[indexTracker]
        if appointment.notes != "" {
            viewController.passedNote = appointment.notes
            print(indexTracker)
            present(viewController, animated: true, completion: nil)
        } else {
            return
        }
        
    }
    
    
    //the following 2 methods work but are very clunky for doing what i'm doing here. need to rethink
    func stringToDate(dateString: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        //let dateString = label.text
        dateFormatter.dateFormat = "yyyyMMdd"
        let dateFromString = dateFormatter.date(from: dateString)
        return dateFromString! // need some error handling in case date is nil. ask leah :)
        
    }
    func dateToString(date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MM/dd/yyyy"
    let dateString = dateFormatter.string(from: date)
        return dateString
    }
    
}


extension ApptViewController: UIPopoverPresentationControllerDelegate {
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

extension ApptViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
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
                                    providerDBRef.child("\(self.currentProviderKey!)").updateChildValues(["imageURL" : urlString])
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
