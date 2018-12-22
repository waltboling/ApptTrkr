//
//  MainViewController.swift
//  ApptTrkr
//
//  Created by Jon Boling on 12/17/18.
//  Copyright © 2018 Walt Boling. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UIScrollViewDelegate {
    
    private let headerViewCutaway: Float = 40.0
    @IBOutlet weak var ApptTrkrLogoView: UIImageView!
    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var headerBackgroundView: UIView!
    
    @IBOutlet weak var customHeaderView: CustomHeaderView!
    
    var mockArray = ["one", "two", "three", "four"]
    //var imageView = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        mainTableView.contentInset = UIEdgeInsets(top: ApptTrkrLogoView.bounds.height, left: 0, bottom: 0, right: 0)
        //mainTableView.contentOffset = CGPoint(x: 0, y: -ApptTrkrLogoView.frame.height)
     
        
        view.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1.0)
        
        
        
        mainTableView.register(MainCell.self, forCellReuseIdentifier: "Cell")
        /*imageView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 200)
        imageView.image = UIImage.init(named: "ApptTrkrLogo")
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        view.addSubview(imageView)
        
        ApptTrkrLogoView.isHidden = true*/

        // Do any additional setup after loading the view.
    }
    
}

extension MainViewController: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let y = 300 - (scrollView.contentOffset.y + 300)
        //let y = scrollView.contentOffset.y * -1
        let height = min(max(y, 60), 500)
        ApptTrkrLogoView.frame = CGRect(x: 0, y: 82, width: UIScreen.main.bounds.size.width, height: height)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}

extension MainViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MainCell
        cell.providerNameLabel.text = "Provider Name"
        //cell.providerTypeLabel.textColor = UIColor.darkGray
        cell.providerTypeLabel.text = "Provider Type"
        //cell.providerTypeLabel.textColor = UIColor.lightGray
        cell.providerBtn.addTarget(self, action: #selector(providerBtnAction), for: .touchUpInside)
        cell.apptBtn.addTarget(self, action: #selector(apptBtnAction), for: .touchUpInside)
        return cell
    }
    
    
    @objc func providerBtnAction() {
        buttonSegues(buttonType: "Provider")
    }
    
    @objc func apptBtnAction() {
        buttonSegues(buttonType: "Appt")
    }
    func buttonSegues(buttonType: String) {
        switch buttonType {
        case "Provider":
            performSegue(withIdentifier: "toProviderDetail", sender: self)
        case "Appt":
            performSegue(withIdentifier: "toApptDetail", sender: self)
        default:
            print("something went wrong with the button segue")
        }
    }
}
