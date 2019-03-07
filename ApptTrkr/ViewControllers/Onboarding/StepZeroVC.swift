//
//  StepZeroVC.swift
//  ApptTrkr
//
//  Created by Jon Boling on 2/27/19.
//  Copyright © 2019 Walt Boling. All rights reserved.
//

import UIKit

class StepZeroVC: UIViewController {
    
    let userDefaults = UserDefaults.standard
    
    @IBAction func policyBtnTapped(_ sender: Any) {
        let policiesTBC = storyboard?.instantiateViewController(withIdentifier: "PoliciesTBC") as! UITabBarController
        present(policiesTBC, animated: true, completion: nil)
    }
    
    @IBAction func skipBtnTapped(_ sender: Any) {
        performSegue(withIdentifier: "toApp", sender: self)
        userDefaults.set(true, forKey: "onboardingComplete")
    }
}
