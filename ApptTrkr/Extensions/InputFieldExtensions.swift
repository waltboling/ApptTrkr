//
//  InputFieldExtensions.swift
//  ApptTrkr
//
//  Created by Jon Boling on 1/18/19.
//  Copyright © 2019 Walt Boling. All rights reserved.
//

//import Foundation
import UIKit

extension UITextField {
    
    func addDoneCancelToolbar(onDone: (target: Any, action: Selector)? = nil, onCancel: (target: Any, action: Selector)? = nil) {
        let onCancel = onCancel ?? (target: self, action: #selector(didCancelInput))
        let onDone = onDone ?? (target: self, action: #selector(didEnterInput))
        let toolbar: UIToolbar = UIToolbar()
        
        toolbar.barStyle = .default
        let cancelBtn = UIBarButtonItem(title: "Cancel", style: .plain, target: onCancel.target, action: onCancel.action)
        cancelBtn.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name:"Lato-Bold", size: 18)!, .foregroundColor: UIColor.ATColors.lightRed], for: .normal)
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneBtn = UIBarButtonItem(title: "Done", style: .done, target: onDone.target, action: onDone.action)
        doneBtn.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name:"Lato-Bold", size: 18)!, .foregroundColor: UIColor.ATColors.midBlue], for: .normal)
        toolbar.items = [cancelBtn, flexSpace, doneBtn]
        toolbar.sizeToFit()
        
        self.inputAccessoryView = toolbar
    }
    
    // Default actions:
    @objc func didEnterInput() {
        self.resignFirstResponder()
        
    }
    
    @objc func didCancelInput() {
        self.resignFirstResponder()
    }
}

extension UITextView {
    func addDoneCancelToolbar(onDone: (target: Any, action: Selector)? = nil, onCancel: (target: Any, action: Selector)? = nil) {
        let onCancel = onCancel ?? (target: self, action: #selector(didCancelInput))
        let onDone = onDone ?? (target: self, action: #selector(didEnterInput))
        let toolbar: UIToolbar = UIToolbar()
        
        toolbar.barStyle = .default
        let cancelBtn = UIBarButtonItem(title: "Cancel", style: .plain, target: onCancel.target, action: onCancel.action)
        cancelBtn.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name:"Lato-Bold", size: 18)!, .foregroundColor: UIColor.ATColors.lightRed], for: .normal)
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneBtn = UIBarButtonItem(title: "Done", style: .done, target: onDone.target, action: onDone.action)
        doneBtn.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name:"Lato-Bold", size: 18)!, .foregroundColor: UIColor.ATColors.midBlue], for: .normal)
        toolbar.items = [cancelBtn, flexSpace, doneBtn]
        toolbar.sizeToFit()
        
        self.inputAccessoryView = toolbar
    }
    
    // Default actions:
    @objc func didEnterInput() {
        self.resignFirstResponder()
    }
    
    @objc func didCancelInput() {
        self.resignFirstResponder()
    }
    
    /*func makePhoneNumberTextView() -> FormattedTextView {
        let frmtdTextView = self as! FormattedTextView
        frmtdTextView.formatting = .phoneNumber
        return frmtdTextView
    }*/
    
}

extension String {
    public func toPhoneNumber() -> String {
        return self.replacingOccurrences(of: "(\\d{3})(\\d{3})(\\d+)", with: "($1) $2-$3", options: .regularExpression, range: nil)
    }
    
    public func testForEmpty() -> Bool {
        let stringToTest = self.trimmingCharacters(in: .whitespaces)
        if stringToTest.isEmpty == true {
            return true
        } else {
            return false
        }
    }
    
    var htmlToAttributedString: NSAttributedString? {
        do {
            return try NSAttributedString(data: Data(utf8), options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            print(error)
            return nil
        }
    }
    
    var unicodes: [UInt32] { return unicodeScalars.map{$0.value} }
}
