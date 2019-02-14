//
//  NewApptSheetVC.swift
//  ApptTrkr
//
//  Created by Jon Boling on 1/15/19.
//  Copyright © 2019 Walt Boling. All rights reserved.
//

import UIKit
import Firebase


class NewApptSheetVC: UIViewController, UITextFieldDelegate, UITextViewDelegate {

    @IBOutlet weak var formView: UIView!
    @IBOutlet weak var apptTitleTextField: UITextField!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var apptDateTextField: FormattedTextField!
    @IBOutlet weak var doneBtn: UIBarButtonItem!
    @IBOutlet weak var cancelBtn: UIBarButtonItem!
    
    var textViewPlaceholder = "Add notes here..."
    let ref = Database.database().reference()
    var passedProvider: ServiceProvider?
    //let appointmentVC = ApptViewController()
    var passedKey: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        notesTextView.delegate = self
        //appointmentVC.delegate = self
        //print(passedProvider?.name)
        formView.layer.cornerRadius = 3
        notesTextView.textColor = UIColor.gray
        notesTextView.text = textViewPlaceholder
        apptDateTextField.formatting = TextFieldFormatting.date
        
       
        // Do any additional setup after loading the view.
    }
    
 
    
    @IBAction func doneBtnTapped(_ sender: Any) {
        if !testForEmpty(textfield: apptTitleTextField) && !testForEmpty(textfield: apptDateTextField) {
            let appt = Appointment(title: apptTitleTextField.text ?? "", type: passedProvider?.type ?? "", date: apptDateTextField.text, providerKey: passedKey!, providerName: passedProvider?.name ?? "", notes: notesTextView.text ?? "")
            let childRef = ref.child("appointment").childByAutoId()
            let strToDate = stringToDate(dateString: appt.date)
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
        } else {
            showAlert(title: "Try Again!", message: "Please enter a title and date for the appointment to continue", buttonString: "Ok")
        }
        
    }
    
    //Firebase doesn't store dates, so will need to think of solutions in which the data can be manipulated back and forth well btn string and date
    func stringToDate(dateString: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        //let dateString = textField.finalStringWithoutFormatting
        dateFormatter.dateFormat = "MMddyyyy"
        let dateFromString = dateFormatter.date(from: dateString)
        return dateFromString! // need some error handling in case date is nil or invalid. ask leah :)
        
    }
    
    func dateToTimeStamp(date: Date) -> Timestamp {
       let convertedDate = Timestamp.init(date: date)
        return convertedDate
    }
    
    func dateToString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
    
    @IBAction func cancelBtnTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func testForEmpty(textfield: UITextField) -> Bool {
        let stringToTest = textfield.text?.trimmingCharacters(in: .whitespaces)
        if stringToTest?.isEmpty == true {
            return true
        } else {
            return false
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            if (touch.view == self.view) {
                self.dismiss(animated: true, completion: nil)
            }
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