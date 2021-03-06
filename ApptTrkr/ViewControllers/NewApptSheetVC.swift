//
//  NewApptSheetVC.swift
//  ApptTrkr
//
//  Created by Jon Boling on 1/15/19.
//  Copyright © 2019 Walt Boling. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class NewApptSheetVC: UIViewController {

    //MARK: -IBOutlets
    @IBOutlet weak var formView: UIView!
    @IBOutlet weak var apptTitleTextField: UITextField! 
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var apptDateTextField: FormattedTextField! {
        didSet {
            apptDateTextField.addDoneCancelToolbar()
        }
    }
    @IBOutlet weak var doneBtn: UIBarButtonItem!
    @IBOutlet weak var cancelBtn: UIBarButtonItem!
    
    var textViewPlaceholder = "Add notes here..."
    let ref = Database.database().reference()
    var passedProvider: ServiceProvider?
    var passedKey: String?
    var currentUID: String!
    let userDefaults = UserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureInputFields()
    }
    
    //MARK: -IBActions
    @IBAction func cancelBtnTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func doneBtnTapped(_ sender: Any) {
       saveAppointment()
    }
    
    func configureInputFields() {
        notesTextView.delegate = self
        apptTitleTextField.delegate = self
        apptDateTextField.delegate = self
        
        formView.layer.cornerRadius = 3
        notesTextView.textColor = UIColor.gray
        notesTextView.text = textViewPlaceholder
        apptDateTextField.formatting = TextFieldFormatting.date
    }
    
    func saveAppointment() {
        //let currentUID = userDefaults.value(forKey: "uid") as! String
        let currentUID = KeychainWrapper.standard.string(forKey: "uid")
        if !(apptTitleTextField.text?.testForEmpty())! && !apptDateTextField.text.testForEmpty() {
            var note = ""
            if !notesTextView.text.testForEmpty() && notesTextView.text != self.textViewPlaceholder {
                note = notesTextView.text
            }
            let appt = Appointment(title: apptTitleTextField.text ?? "", type: passedProvider?.type ?? "", date: apptDateTextField.text, providerKey: passedKey!, providerName: passedProvider?.name ?? "", notes: note)
            let userRef = ref.child("users").child(currentUID ?? "")
            let childRef = userRef.child("appointment").childByAutoId()
            if let strToDate = stringToDate(dateString: appt.date) {
                let formattedDateString = dateToString(date: strToDate)
                let appointment: [String: Any]
                appointment = [
                    "title": appt.title,
                    "type": appt.type,
                    "date": formattedDateString,
                    "providerKey": appt.providerKey,
                    "providerName": appt.providerName,
                    "notes": appt.notes
                ]
                childRef.setValue(appointment)
                dismiss(animated: true, completion: nil)
            }
        } else {
            showAlert(title: "Try Again!", message: "Please enter a title and valid date for the appointment to continue", buttonString: "Ok")
        }
    }
    
    
    //MARK: -Helpers and Handlers
    func stringToDate(dateString: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.dateFormat = "MMddyyyy"
        if let dateFromString = dateFormatter.date(from: dateString) {
            return dateFromString
        } else {
            showAlert(title: "Invalid date", message: "Enter a valid date in the correct format to continue", buttonString: "Ok")
            return nil
        }
    }
    
    func dateToString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        let dateString = dateFormatter.string(from: date)
        return dateString
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            if (touch.view == self.view) {
                saveAppointment()
            }
        }
    }
}

extension NewApptSheetVC: UITextViewDelegate, UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == apptDateTextField {
            textField.resignFirstResponder()
            notesTextView.becomeFirstResponder()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case apptTitleTextField:
            textField.resignFirstResponder()
            apptDateTextField.becomeFirstResponder()
            return true
        case apptDateTextField:
            textField.resignFirstResponder()
            notesTextView.becomeFirstResponder()
            return true
        default:
            textField.resignFirstResponder()
            return true
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        notesTextView.layer.borderColor = UIColor.lightGray.cgColor
        notesTextView.layer.borderWidth = 1.0
        if notesTextView.text == textViewPlaceholder {
            notesTextView.text = ""
            notesTextView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        notesTextView.layer.borderColor = UIColor.clear.cgColor
        if notesTextView.text.isEmpty {
            notesTextView.text = textViewPlaceholder
            notesTextView.textColor = UIColor.gray
        }
    }
}

extension NewApptSheetVC: PassProviderDelegate {
    func setKey(providerKey: String?) {
        passedKey = providerKey
    }
    
    func setProvider(provider: ServiceProvider?) {
        passedProvider = provider
    }
}
