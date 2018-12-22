//
//  ApptViewController.swift
//  ApptTrkr
//
//  Created by Jon Boling on 12/17/18.
//  Copyright © 2018 Walt Boling. All rights reserved.
//

import UIKit

class ApptViewController: UIViewController {

    @IBOutlet weak var providerThumbnail: UIImageView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var apptTableView: UITableView!
    @IBOutlet weak var providerNameLabel: UILabel!
    @IBOutlet weak var providerTypeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        providerThumbnail.layer.cornerRadius = providerThumbnail.frame.height / 2
        apptTableView.contentInset = UIEdgeInsets(top: backgroundImageView.bounds.height, left: 0, bottom: 0, right: 0)
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

extension ApptViewController: UITableViewDataSource, UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let y = 300 - (scrollView.contentOffset.y + 300)
        //let y = scrollView.contentOffset.y * -1
        let backgroundHeight = min(max(y, 60), 500)
        let thumbnailY = 150 - (scrollView.contentOffset.y + 150)
        let thumbnailHeight = min(max(thumbnailY, 50), 150)
        let width = UIScreen.main.bounds.size.width
        backgroundImageView.frame = CGRect(x: 0, y: 82, width: width, height: backgroundHeight)
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
        return 80
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "apptCell", for: indexPath)
        cell.textLabel?.text = "Appointment Type"
        cell.textLabel?.textColor = UIColor(red: 0.64, green: 0.1176, blue: 0.13, alpha: 1.0)
        cell.detailTextLabel?.text = "MM/DD/YYYY"
        cell.detailTextLabel?.textColor = UIColor(red: 0.39, green: 0.49, blue: 0.575, alpha: 1.0)
        
        return cell
    }
    
    
}
