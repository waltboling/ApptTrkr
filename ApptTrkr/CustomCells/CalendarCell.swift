//
//  CalendarCell.swift
//  ApptTrkr
//
//  Created by Jon Boling on 12/20/18.
//  Copyright © 2018 Walt Boling. All rights reserved.
//

import UIKit

class CalendarCell: UITableViewCell {

    var providerName: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.ATColors.midBlue
        return label
    }()
    
    var appointmentTitle: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.ATColors.midBlue
        return label
    }()
    
    var dateLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = UIColor.ATColors.midBlue
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addSubview(providerName)
        self.addSubview(appointmentTitle)
        self.addSubview(dateLabel)
    }
    
    override func layoutSubviews() {
        dateLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        dateLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        appointmentTitle.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
        appointmentTitle.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
        appointmentTitle.bottomAnchor.constraint(equalTo: providerName.topAnchor, constant: -5).isActive = true
        
        providerName.rightAnchor.constraint(equalTo: appointmentTitle.rightAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
