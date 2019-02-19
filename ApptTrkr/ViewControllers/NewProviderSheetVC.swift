//
//  NewProviderSheetVC.swift
//  ApptTrkr
//
//  Created by Jon Boling on 1/14/19.
//  Copyright © 2019 Walt Boling. All rights reserved.
//

import UIKit
import Firebase

class NewProviderSheetVC: UIViewController, UITextViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var providerTypeTextField: UITextField!
    @IBOutlet weak var websiteTextField: UITextField!
    @IBOutlet weak var phoneTextField: FormattedTextField! {
        didSet {
            phoneTextField.addDoneCancelToolbar()
        }
    }
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var faxTextField: FormattedTextField! {
        didSet {
            faxTextField.addDoneCancelToolbar()
        }
    }
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var providerThumbnail: UIButton!
    @IBOutlet weak var cancelBtn: UIBarButtonItem!
    @IBOutlet weak var doneBtn: UIBarButtonItem!
    
    //labels
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    
    @IBOutlet weak var websiteLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var faxLabel: UILabel!
    @IBOutlet weak var notesLabel: UILabel!
    @IBOutlet weak var nameHeaderLabel: UILabel!
    @IBOutlet weak var typeHeaderLabel: UILabel!
    
    @IBOutlet weak var providerNameIcon: UIImageView!
    
    @IBOutlet weak var providerTypeIcon: UIImageView!
    @IBOutlet weak var webIcon: UIImageView!
    @IBOutlet weak var phoneIcon: UIImageView!

    @IBOutlet weak var emailIcon: UIImageView!
    @IBOutlet weak var addressIcon: UIImageView!
    @IBOutlet weak var faxIcon: UIImageView!
    @IBOutlet weak var notesIcon: UIImageView!

    let ref = Database.database().reference()
    let textViewPlaceholder = "Add notes here..."
    var imageURL = ""
    var userDefaults = UserDefaults()
    var currentUID: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        
        configureIcons()
        providerThumbnail.layer.cornerRadius = providerThumbnail.frame.height / 2
        providerThumbnail.addTarget(self, action: #selector(handleThumbnailSelector), for: .touchUpInside)
        
        if let imageView = providerThumbnail.imageView {
            imageView.layer.cornerRadius = imageView.frame.height / 2
        }
        
        view.backgroundColor = UIColor.ATColors.white
        
        configureTextInputs()
        notesTextView.text = textViewPlaceholder
        notesTextView.textColor = UIColor.lightGray
        notesTextView.backgroundColor = UIColor.ATColors.white
        notesTextView.font = UIFont.systemFont(ofSize: 17)
    
        notesTextView.layer.cornerRadius = 3
        
        //nameHeaderLabel.text = nameTextField.text
        //typeHeaderLabel.text = providerTypeTextField.text
        phoneTextField.formatting = .phoneNumber
        faxTextField.formatting = .phoneNumber
        
        view.addGestureRecognizer(tap)
    }
    
    
    @IBAction func cancelBtnTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneBtnTapped(_ sender: Any) {
        currentUID = userDefaults.value(forKey: "uid") as? String
        if !testForEmpty(textfield: (nameTextField)) || !testForEmpty(textfield: providerTypeTextField) {
            var note = ""
            if notesTextView.text != "" || notesTextView.text != self.textViewPlaceholder {
                note = notesTextView.text
            }
            let svcProvider = ServiceProvider(name: nameTextField.text ?? "", type: providerTypeTextField.text ?? "", website: websiteTextField.text ?? "", phoneNumber: phoneTextField.text ?? "", email: emailTextField.text ?? "", address: addressTextField.text ?? "", fax: faxTextField.text ?? "", notes: note, imageURL: imageURL)
            let userRef = ref.child("users").child(currentUID)
            let childRef = userRef.child("service-provider").childByAutoId()
            let provider = [
                "name": svcProvider.name,
                "type": svcProvider.type,
                "address": svcProvider.address,
                "email": svcProvider.email,
                "phone": svcProvider.phoneNumber,
                "fax": svcProvider.fax,
                "website": svcProvider.website,
                "notes": svcProvider.notes,
                "imageURL": svcProvider.imageURL
            ]
            
            childRef.setValue(provider)
            dismiss(animated: true, completion: nil)
        } else {
            showAlert(title: "Try Again!", message: "Please enter a provider name or type to continue", buttonString: "Ok")
        }
        
    }
    
    
    
    func testForEmpty(textfield: UITextField) -> Bool {
        let stringToTest = textfield.text?.trimmingCharacters(in: .whitespaces)
        if stringToTest?.isEmpty == true {
            return true
        } else {
            return false
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func configureTextInputs() {
        nameTextField.delegate = self
        providerTypeTextField.delegate = self
        phoneTextField.delegate = self
        websiteTextField.delegate = self
        emailTextField.delegate = self
        faxTextField.delegate = self
        addressTextField.delegate = self
        notesTextView.delegate = self
    }
    
    func configureIcons() {
        let iconBlue = UIColor.ATColors.midBlue
        providerNameIcon.recolorImage(color: iconBlue)
        providerNameIcon.contentMode = .scaleAspectFill
        providerTypeIcon.recolorImage(color: iconBlue)
        providerTypeIcon.contentMode = .scaleAspectFill
        webIcon.recolorImage(color: iconBlue)
        emailIcon.recolorImage(color: iconBlue)
        phoneIcon.recolorImage(color: iconBlue)
        addressIcon.recolorImage(color: iconBlue)
        faxIcon.recolorImage(color: iconBlue)
        notesIcon.recolorImage(color: iconBlue)
        
    }
    
    func buildABottomBorder(textField: UITextField) {
        let border = CALayer()
        border.name = "border"
        let width = CGFloat(1.3)
        border.borderColor = UIColor.ATColors.lightBlue.cgColor
        border.frame = CGRect(x: 0, y: textField.frame.size.height - width, width: textField.frame.size.width, height: textField.frame.size.height)
        
        border.borderWidth = width
        textField.layer.addSublayer(border)
        textField.layer.masksToBounds = true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        buildABottomBorder(textField: textField)
        switch textField {
        case websiteTextField:
            scrollView.setContentOffset(CGPoint(x: 0, y: 80), animated: true)
        case phoneTextField:
            scrollView.setContentOffset(CGPoint(x: 0, y: 150), animated: true)
        case emailTextField:
            scrollView.setContentOffset(CGPoint(x: 0, y: 250), animated: true)
        case addressTextField:
             scrollView.setContentOffset(CGPoint(x: 0, y: 310), animated: true)
        case faxTextField:
            scrollView.setContentOffset(CGPoint(x: 0, y: 350), animated: true)
        default:
            scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        for layer in textField.layer.sublayers! {
            if layer.name == "border" {
                layer.removeFromSuperlayer()
                break
            }
        }
        
        switch textField {
        case nameTextField: //not quite working to handle empty yet
            if !testForEmpty(textfield: textField){
                nameHeaderLabel.text = nameTextField.text
            }
        case providerTypeTextField:
            if !testForEmpty(textfield: textField) {
                typeHeaderLabel.text = providerTypeTextField.text
            }
        case phoneTextField:
            textField.resignFirstResponder()
            emailTextField.becomeFirstResponder()
        case faxTextField:
            textField.resignFirstResponder()
            notesTextView.becomeFirstResponder()
        default:
            break
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        switch textField {
            case nameTextField:
                providerTypeTextField.becomeFirstResponder()
                return true
            case providerTypeTextField:
                websiteTextField.becomeFirstResponder()
                return true
            case websiteTextField:
                phoneTextField.becomeFirstResponder()
                return true
            case phoneTextField:
                emailTextField.becomeFirstResponder()
                return true
            case emailTextField:
                addressTextField.becomeFirstResponder()
                return true
            case addressTextField:
                faxTextField.becomeFirstResponder()
                return true
            case faxTextField:
                notesTextView.becomeFirstResponder()
                return true
            default:
            return true
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        scrollView.setContentOffset(CGPoint(x: 0, y: 370), animated: true)
        notesTextView.layer.borderColor = UIColor.ATColors.lightBlue.cgColor
        notesTextView.layer.borderWidth = 1.0
        if notesTextView.text == textViewPlaceholder {
            notesTextView.text = ""
            notesTextView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        notesTextView.layer.borderColor = UIColor.clear.cgColor
        if notesTextView.text.isEmpty {
            notesTextView.text = textViewPlaceholder
            notesTextView.textColor = UIColor.gray
        }
        textView.resignFirstResponder()
    }
}

extension NewProviderSheetVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
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
        //let providerDBRef = Database.database().reference().child("service-provider")
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] {
            selectedImageFromPicker = editedImage as? UIImage
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] {
            selectedImageFromPicker = originalImage as? UIImage
        }
        
        DispatchQueue.main.async {
            if let selectedImage = selectedImageFromPicker {
                self.providerThumbnail.setImage(selectedImage, for: .normal)
                if let uploadData = self.providerThumbnail.imageView?.image?.pngData() {
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
                                    /* code for other VCs which update existing value
                                    providerDBRef.child("\(self.currentProviderKey!)").updateChildValues(["imageURL" : urlString])*/
                                    self.imageURL = urlString
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
