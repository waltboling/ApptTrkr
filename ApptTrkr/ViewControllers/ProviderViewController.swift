//
//  ProviderViewController.swift
//  ApptTrkr
//
//  Created by Jon Boling on 12/17/18.
//  Copyright © 2018 Walt Boling. All rights reserved.
//

import UIKit

class ProviderViewController: UIViewController {
   
    
    @IBOutlet weak var providerTableView: UITableView!
    
    @IBOutlet weak var providerThumbnail: UIImageView!
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    @IBOutlet weak var providerNameLabel: UILabel!
    
    @IBOutlet weak var providerTypeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        providerTableView.contentInset = UIEdgeInsets(top: backgroundImageView.bounds.height, left: 0, bottom: 0, right: 0)
        
        providerTableView.register(ProviderCell.self, forCellReuseIdentifier: "providerCell")
        providerTableView.register(ProviderNotesCell.self, forCellReuseIdentifier: "providerNotesCell")
        
            providerThumbnail.layer.cornerRadius = providerThumbnail.frame.height / 2

        // Do any additional setup after loading the view.
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

extension ProviderViewController: UITableViewDataSource, UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let y = 300 - (scrollView.contentOffset.y + 300)
        //let y = scrollView.contentOffset.y * -1
        let backgroundHeight = min(max(y, 60), 500)
        let thumbnailY = 150 - (scrollView.contentOffset.y + 150)
        let thumbnailHeight = min(max(thumbnailY, 50), 150)
        let width = UIScreen.main.bounds.size.width
        backgroundImageView.frame = CGRect(x: 0, y: 82, width: width, height: backgroundHeight)
        providerThumbnail.frame = CGRect(x: backgroundImageView.frame.width / 2 - providerThumbnail.frame.width * 0.5, y: backgroundImageView.frame.height / 2 - 33, width: thumbnailHeight, height: thumbnailHeight)
        providerThumbnail.layer.cornerRadius = providerThumbnail.bounds.height / 2
        
        let nameHeight = providerNameLabel.frame.height
        let nameWidth = providerNameLabel.frame.width
        let typeHeight = providerTypeLabel.frame.height
        let typeWidth = providerTypeLabel.frame.width
        let offsetHeight = (backgroundImageView.frame.height / 2) + providerThumbnail.frame.height - 25
        
        providerNameLabel.frame = CGRect(x: UIScreen.main.bounds.midX - (providerNameLabel.frame.width * 0.5), y: offsetHeight, width: nameWidth, height: nameHeight)
        providerTypeLabel.frame = CGRect(x: UIScreen.main.bounds.midX - (providerTypeLabel.frame.width * 0.5), y: offsetHeight  + providerTypeLabel.frame.height + 5, width: typeWidth, height: typeHeight)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
            case 0:
                return 5
            case 1:
                return 1
            default:
                print("something is wrong with number of rows")
                return 0
        }
    }
    
    //here just need to create switch on cell, casting all but notes cell as a providerCell. will need to make slightly diff cell for that one
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
            case 0:
                let baseCell = tableView.dequeueReusableCell(withIdentifier: "providerCell", for: indexPath) as! ProviderCell
                switch indexPath.row {
                    case 0:
                        baseCell.headingLabel.text = "Website"
                        baseCell.infoField.placeholder = "enter website..."
                        baseCell.cellIcon.setBackgroundImage(UIImage(named: "webIcon"), for: .normal)
                        return baseCell
                    
                    case 1:
                        baseCell.headingLabel.text = "Phone Number"
                        baseCell.infoField.placeholder = "enter phone number..."
                        baseCell.cellIcon.setBackgroundImage(UIImage(named: "phoneIcon"), for: .normal)
                        return baseCell
                    
                    case 2:
                        baseCell.headingLabel.text = "Email"
                        baseCell.infoField.placeholder = "enter email..."
                        baseCell.cellIcon.setBackgroundImage(UIImage(named: "emailIcon"), for: .normal)
                        return baseCell
                    
                    case 3:
                        baseCell.headingLabel.text = "Address"
                        baseCell.infoField.placeholder = "enter address..."
                        baseCell.cellIcon.setBackgroundImage(UIImage(named: "addressIcon"), for: .normal)
                        return baseCell
                    
                    case 4:
                        baseCell.headingLabel.text = "Fax"
                        baseCell.infoField.placeholder = "enter fax..."
                        baseCell.cellIcon.setBackgroundImage(UIImage(named: "faxIcon"), for: .normal)
                        return baseCell
                    
                    default:
                        fatalError("There was a problem loading base cells")
                }
            case 1:
                let notesCell = tableView.dequeueReusableCell(withIdentifier: "providerNotesCell", for: indexPath) as! ProviderNotesCell
                switch indexPath.row {
                    case 0:
                        notesCell.headingLabel.text = "Notes"
                        //make textview extension for placeholder text
                        notesCell.cellIcon.setBackgroundImage(UIImage(named: "notesIcon"), for: .normal)
                        return notesCell
                    default:
                        fatalError("failed to load notes cell")
                }
            default:
                fatalError("failed to load cells")
        }
    }
}
