//
//  MasterCalViewController.swift
//  ApptTrkr
//
//  Created by Jon Boling on 12/17/18.
//  Copyright © 2018 Walt Boling. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class MasterCalViewController: UIViewController {
    
    var months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    var year = 2019
    var appointments: [Appointment] = []
    let ref = Database.database().reference()
    let userDefaults = UserDefaults()
    let floatingScrollBtn: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 55, height: 55))
        button.setImage(UIImage(named: "downArrow"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 15.0, left: 12.0, bottom: 12.0, right: 12.0)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.customizeFGImage(color: UIColor.ATColors.lightBlue)
        button.backgroundColor = UIColor.ATColors.white
        button.layer.zPosition = 1
        button.layer.cornerRadius = button.bounds.height / 2
        button.layer.shadowColor = UIColor.darkGray.cgColor
        button.layer.shadowOpacity = 0.9
        button.layer.shadowOffset = CGSize(width: 0, height: 3.0)
        button.layer.shadowRadius = 5
        button.layer.masksToBounds = false
        button.isHidden = true
        
        return button
    }()
    
    let yearInputField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont(name: "Hiragino Sans W3", size: 25)
        textField.textColor = UIColor.ATColors.lightRed
        textField.keyboardType = .numberPad
        textField.textAlignment = .center
        textField.addDoneCancelToolbar()

        return textField
    }()

    //MARK: -IBOutlets
    @IBOutlet weak var calendarTableView: UITableView!
    @IBOutlet weak var leftArrowButton: UIButton!
    @IBOutlet weak var rightArrowButton: UIButton!
    @IBOutlet weak var yearLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        queryAppts()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        calendarTableView.register(CalendarHeaderCell.self, forCellReuseIdentifier: "calendarHeaderCell")
        calendarTableView.register(CalendarCell.self, forCellReuseIdentifier: "calendarCell")
        calendarTableView.allowsSelection = false

        addTapToResign(view: self.view)
        addTapToResign(view: calendarTableView)
        
        configureFloatingBtn()
        configureYearControl()
        configureNavBar()
    }
    
    
    //MARK: -IBActions
    @IBAction func leftArrowWasTapped(_ sender: Any) {
        yearDown()
    }
    
    @IBAction func rightArrowWasTapped(_ sender: Any) {
        yearUp()
    }
    
    //MARK: -Configure UI
    func configureNavBar() {
        let navBar = navigationController?.navigationBar
        navBar?.tintColor = UIColor.darkGray
        navBar?.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name:"Lato-Medium", size: 20)!, .foregroundColor: UIColor.darkGray]
        navigationItem.title = "Master Calendar"
        navigationItem.rightBarButtonItem = nil
    }
    
    func configureYearControl() {
        yearInputField.delegate = self
        yearLabel.text = String(year)
        yearLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleYearTap)))
        yearLabel.textColor = UIColor.ATColors.lightRed
        yearLabel.isUserInteractionEnabled = true
        rightArrowButton.customizeBGImage(color: UIColor.darkGray)
        leftArrowButton.customizeBGImage(color: UIColor.darkGray)
    }
    
    func instantiateYearInputField() {
        view.addSubview(yearInputField)
        yearInputField.topAnchor.constraint(equalTo: yearLabel.topAnchor).isActive = true
        yearInputField.bottomAnchor.constraint(equalTo: yearLabel.bottomAnchor).isActive = true
        yearInputField.leadingAnchor.constraint(equalTo: yearLabel.leadingAnchor).isActive = true
        yearInputField.trailingAnchor.constraint(equalTo: yearLabel.trailingAnchor).isActive = true
        yearLabel.isHidden = true
        yearLabel.isEnabled = false
        rightArrowButton.isEnabled = false
        leftArrowButton.isEnabled = false
    }
    
    func configureFloatingBtn() {
        floatingScrollBtn.addTarget(self, action: #selector(scrollToBottom), for: .touchUpInside)
        view.addSubview(floatingScrollBtn)
        floatingScrollBtn.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -130).isActive = true
        floatingScrollBtn.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -40).isActive = true
        floatingScrollBtn.heightAnchor.constraint(equalToConstant: 55).isActive = true
        floatingScrollBtn.widthAnchor.constraint(equalTo: floatingScrollBtn.heightAnchor).isActive = true
        
    }
    
    func configureYearSwipe() {
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeLeft))
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeRight))
        swipeLeft.direction = .left
        swipeRight.direction = .right
        view.gestureRecognizers = [swipeLeft, swipeRight]

    }
    
    //MARK: Handlers and Helpers
    @objc func handleYearTap() {
        instantiateYearInputField()
        yearInputField.becomeFirstResponder()
    }

    @objc func scrollToBottom() {
        calendarTableView.scrollRectToVisible(CGRect(x: 0, y: calendarTableView.contentSize.height - calendarTableView.frame.height, width: calendarTableView.frame.size.width, height: calendarTableView.frame.size.height ), animated: true)
    }
    
    @objc func handleSwipeLeft() {
        yearUp()
    }
    
    @objc func handleSwipeRight() {
        yearDown()
    }
    
    func yearUp() {
        year += 1
        yearLabel.text = String(year)
        queryAppts()
    }
    
    func yearDown() {
        year -= 1
        yearLabel.text = String(year)
        queryAppts()
    }
    
    func getSubString(dateStr: String) -> Int {
        let startIdx = dateStr.index(dateStr.startIndex, offsetBy: 4)
        let endIdx = dateStr.index(dateStr.endIndex, offsetBy: -2)
        let range = startIdx..<endIdx
        let subStr = dateStr[range]
        let convertedSubStr = Int(subStr)
        return convertedSubStr!
    }
    
    func stringToDate(dateString: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        dateFormatter.dateFormat = "yyyyMMdd"
        let dateFromString = dateFormatter.date(from: dateString)
        return dateFromString!
    }
    
    func dateToString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
    
    func lockDateAndReload(textField: UITextField) {
        textField.resignFirstResponder()
    }
    
    func addTapToResign(view: UIView) {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapResign))
        view.addGestureRecognizer(tap)
    }
    
    @objc func handleTapResign() {
        lockDateAndReload(textField: yearInputField)
    }
    
    func queryAppts(){
        appointments.removeAll()
        let yearStart = String(year) + "0101"
        let yearEnd = String(year) + "1231"
        //let currentUID = userDefaults.value(forKey: "uid") as! String
        let currentUID = KeychainWrapper.standard.string(forKey: "uid")
        let userRef = ref.child("users").child(currentUID ?? "")
        userRef.child("appointment").queryOrdered(byChild: "date").queryStarting(atValue: yearStart).queryEnding(atValue: yearEnd).observe(.value, with: { snapshot in
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                    let appt = Appointment(snapshot: snapshot) {
                    self.appointments.append(appt)
                }
            }
            
            self.calendarTableView.reloadData()
            if self.calendarTableView.contentSize.height > self.calendarTableView.frame.size.height {
                self.floatingScrollBtn.isHidden = false
            } else {
                self.floatingScrollBtn.isHidden = true
            }
        })
    }
}

extension MasterCalViewController: UITableViewDelegate, UITableViewDataSource {
   
    func numberOfSections(in tableView: UITableView) -> Int {
        return months.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView.frame.height > 300 {
            return tableView.frame.height / CGFloat(months.count)
        } else {
            return tableView.frame.height / 3
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = tableView.dequeueReusableCell(withIdentifier:"calendarHeaderCell") as! CalendarHeaderCell
        headerCell.headerLabel.text = months[section]
        
        return headerCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var dates: [Appointment] = []
        dates.removeAll()
        
        for appt in appointments {
            if getSubString(dateStr: appt.date) == section + 1 {
                dates.append(appt)
            }
        }
        
        return dates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "calendarCell", for: indexPath) as! CalendarCell
        let section = indexPath.section
        
        cell.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1.0)
        cell.layer.cornerRadius = 15
        
        var foundDates = 0
        for (index, appDate) in appointments.enumerated() {
            if getSubString(dateStr: appDate.date) == section + 1 {
                if (foundDates == indexPath.row) {
                    let appt = appointments[index]
                    let toDate = stringToDate(dateString: appt.date)
                    let formattedDateStr = dateToString(date: toDate)
                    cell.dateLabel.text = formattedDateStr
                    cell.appointmentTitle.text = appt.title
                    cell.providerName.text = "\(appt.providerName) | \(appt.type)"
                    break
                }
                else {
                    foundDates += 1
                }
            }
        }
        
        return cell
    }
}

extension MasterCalViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == yearInputField {
            textField.text = ""
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == yearInputField {
            if textField.text!.count == 4 {
                year = Int(textField.text!)!
                yearLabel.text = String(year)
                lockDateAndReload(textField: textField)
                queryAppts()
                yearLabel.isHidden = false
                textField.removeFromSuperview()
                rightArrowButton.isEnabled = true
                leftArrowButton.isEnabled = true
                yearLabel.isEnabled = true
            } else {
                textField.removeFromSuperview()
                yearLabel.isHidden = false
                yearLabel.isEnabled = true
                rightArrowButton.isEnabled = true
                leftArrowButton.isEnabled = true
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        lockDateAndReload(textField: textField)
        return true
    }
}
