//
//  PolicyViewController.swift
//  ApptTrkr
//
//  Created by Jon Boling on 2/28/19.
//  Copyright © 2019 Walt Boling. All rights reserved.
//

import UIKit

class PolicyViewController: UIViewController {
    
    var spinner = UIActivityIndicatorView()

    //MARK: -IBOutlets
    @IBOutlet weak var viewInAppBtn: UIButton!
    @IBOutlet weak var policyTextView: UITextView!
    @IBOutlet weak var viewOnWeb: UIButton!
    
    //MARK: -IBActions
    @IBAction func viewInAppTapped(_ sender: Any) {
        if policyTextView.isHidden == true {
            policyTextView.isHidden = false
            viewInAppBtn.setTitle("Hide Policy", for: .normal)
            DispatchQueue.main.async {
                self.spinner = self.showSpinner(view: self.view)
            }
            getPrivacyPolicy()
          
        } else {
            policyTextView.isHidden = true
            viewInAppBtn.setTitle("Show in App", for: .normal)
        }
      
    }
    
    @IBAction func viewOnWebTapped(_ sender: Any) {
        openPrivacyURL()
    }
    
    @IBAction func agreeBtnTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        policyTextView.isHidden = true
        viewInAppBtn.setTitle("View in App", for: .normal)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        policyTextView.isEditable = false
        configureBtns(button: viewOnWeb)
        configureBtns(button: viewInAppBtn)
    }
    
    //MARK: -Helper/Handler methods
    func configureBtns(button: UIButton) {
        button.layer.borderColor = UIColor.ATColors.white.cgColor
        button.layer.borderWidth = 0.5
        button.layer.cornerRadius = 5
        button.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
  
    func openPrivacyURL() {
        if let url = URL(string: "https://www.iubenda.com/privacy-policy/72345407") {
            UIApplication.shared.open(url)
        }
    }
    
    func getPrivacyPolicy() {
        if let url = URL(string: "https://www.iubenda.com/api/privacy-policy/72345407") {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                DispatchQueue.main.async(execute:  {
                    self.spinner.dismissSpinner()
                    guard let data = data else {
                        let message = error?.localizedDescription ?? "Something went wrong"
                        self.showAlert(title: "Sorry", message: message, buttonString: "OK")
                        return
                    }
                    
                    self.presentPolicy(policyData: data)
                })
            }
            task.resume()
        }
    }
    
    func presentPolicy(policyData: Data) {
        do {
            let json = try JSONSerialization.jsonObject(with: policyData, options: []) as! [String: AnyObject]
            if let content = json["content"] as? String {
                // to read html here
                policyTextView.text = content.htmlToAttributedString?.string ?? "Could not load contents. Try to view on web instead"
            } else {
                showAlert(title: "Unable to get data from URL", message: "", buttonString: "OK")
            }
        } catch {
            showAlert(title: "Unable to get data from URL", message: "", buttonString: "OK")
        }
    }
}
