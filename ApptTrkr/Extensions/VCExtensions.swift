//
//  VCExtensions.swift
//  ApptTrkr
//
//  Created by Jon Boling on 1/10/19.
//  Copyright © 2019 Walt Boling. All rights reserved.
//

import UIKit

var progressWheel: UIActivityIndicatorView?

extension UIViewController {
    
    //will change this some later
    func floatButton(target: Any?, action: Selector, forEvent: UIControl.Event) {
        let floatingBtn: UIButton = {
            let button = UIButton(frame: CGRect(x: 0, y: 0, width: 35, height: 35))
            button.setBackgroundImage(UIImage(named: "logoutIconWhite"), for: .normal)
            button.translatesAutoresizingMaskIntoConstraints = false
            //button.backgroundColor = UIColor.darkGray
            button.layer.zPosition = 1
            //button.layer.cornerRadius = button.bounds.height / 2
            //button.layer.shadowColor = UIColor.darkGray.cgColor
           // button.layer.shadowOffset = CGSize(width: 1.0, height: 5.0)
            button.layer.masksToBounds = true
            return button
        }()
        floatingBtn.addTarget(target, action: action, for: forEvent)
        floatingBtn.customizeBGImage(color: UIColor.white)
        self.view.addSubview(floatingBtn)
        
        floatingBtn.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 110).isActive = true
        floatingBtn.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        floatingBtn.heightAnchor.constraint(equalToConstant: 35).isActive = true
        floatingBtn.widthAnchor.constraint(equalTo: floatingBtn.heightAnchor).isActive = true
        
    }
    
    func showAlert(title: String, message: String, buttonString: String) {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: buttonString, style: .default, handler: nil)
            
            alertController.addAction(okAction)
        
            DispatchQueue.main.async {
                self.present(alertController, animated: true, completion: nil)
            }
        }
    
    func showSpinner(view: UIView) -> UIActivityIndicatorView {
        let spinner = UIActivityIndicatorView()
        spinner.hidesWhenStopped = true
        spinner.style = .whiteLarge
        spinner.center = view.center
        view.addSubview(spinner)
        spinner.startAnimating()
        
        return spinner
    }
}

extension UIActivityIndicatorView {
    func dismissSpinner() {
        self.stopAnimating()
        self.removeFromSuperview()
    }
}
