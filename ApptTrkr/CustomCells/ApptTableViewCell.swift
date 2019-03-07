//
//  ApptTableViewCell.swift
//  ApptTrkr
//
//  Created by Jon Boling on 2/12/19.
//  Copyright © 2019 Walt Boling. All rights reserved.
//

import UIKit

class ApptTableViewCell: UITableViewCell {

    var apptTitle: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Lato-Medium", size: 18)
        label.textColor = UIColor.ATColors.darkRed
        return label
    }()

    var dateLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Lato-Medium", size: 20)
        label.textColor = UIColor.ATColors.midBlue
        return label
        
    }()
    
    var noteBtn: UIButton = {
        var button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.imageView?.image = UIImage(named: "notesIcon")
        button.customizeFGImage(color: UIColor.ATColors.lightBlue)
        button.clipsToBounds = true
        button.contentMode = .scaleAspectFill
        return button
    }()
    
    var noteTapAction: (() -> Void)? = nil
    
    @objc func noteBtnTap() {
        if let tapAction = noteTapAction {
            noteTapAction!()
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    
        self.addSubview(apptTitle)
        self.addSubview(dateLabel)
        self.addSubview(noteBtn)
    }
    
    override func layoutSubviews() {
        apptTitle.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        apptTitle.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        
        dateLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        dateLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
        
        noteBtn.topAnchor.constraint(equalTo: self.topAnchor, constant: 34).isActive = true
        noteBtn.leftAnchor.constraint(equalTo: apptTitle.leftAnchor, constant: 10).isActive = true
        noteBtn.bottomAnchor.constraint(lessThanOrEqualTo: self.bottomAnchor, constant: -5).isActive = true
        noteBtn.heightAnchor.constraint(equalTo: noteBtn.widthAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
