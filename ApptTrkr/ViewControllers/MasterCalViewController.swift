//
//  MasterCalViewController.swift
//  ApptTrkr
//
//  Created by Jon Boling on 12/17/18.
//  Copyright © 2018 Walt Boling. All rights reserved.
//

import UIKit

class MasterCalViewController: UIViewController {
    var months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    var overlayColors = [UIColor.SeasonalColors.january, UIColor.SeasonalColors.february, UIColor.SeasonalColors.march, UIColor.SeasonalColors.april, UIColor.SeasonalColors.may, UIColor.SeasonalColors.june, UIColor.SeasonalColors.july, UIColor.SeasonalColors.august, UIColor.SeasonalColors.september, UIColor.SeasonalColors.october, UIColor.SeasonalColors.november, UIColor.SeasonalColors.december]
    var year = 2018

    @IBOutlet weak var calendarTableView: UITableView!
    @IBOutlet weak var leftArrowButton: UIButton!
    @IBOutlet weak var rightArrowButton: UIButton!
    @IBOutlet weak var yearLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //overlayColors = [season.january]
            yearLabel.text = String(year)
        rightArrowButton.customize(color: UIColor.darkGray)
        leftArrowButton.customize(color: UIColor.darkGray)
        calendarTableView.register(CalendarHeaderCell.self, forCellReuseIdentifier: "calendarHeaderCell")
        calendarTableView.register(CalendarCell.self, forCellReuseIdentifier: "calendarCell")
        
        
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func leftArrowWasTapped(_ sender: Any) {
        year -= 1
        yearLabel.text = String(year)
    }
    
    @IBAction func rightArrowWasTapped(_ sender: Any) {
        year += 1
        yearLabel.text = String(year)
        
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

extension MasterCalViewController: UITableViewDelegate, UITableViewDataSource {
   
    func numberOfSections(in tableView: UITableView) -> Int {
        return months.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = tableView.dequeueReusableCell(withIdentifier:"calendarHeaderCell") as! CalendarHeaderCell
        headerCell.headerLabel.text = months[section]
        headerCell.colorOverlay.backgroundColor = overlayColors[section]
        return headerCell
    }
    
    /*func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return months[section]
    }*/
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "calendarCell", for: indexPath) as! CalendarCell
        cell.dateLabel.text = "MM/DD/YYYY"
        cell.appointmentTitle.text = "Appointment Title"
        cell.providerName.text = "Provider Name"
        return cell
    }
    
    
    
}
