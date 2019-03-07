//
//  ProviderPhoneCell.swift
//  ApptTrkr
//
//  Created by Jon Boling on 12/20/18.
//  Copyright © 2018 Walt Boling. All rights reserved.
//

import UIKit

class ProviderPhoneCell: UITableViewCell {
    var headingLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Lato-Medium", size: 15)
        label.textColor = UIColor(red: 0.64, green: 0.1176, blue: 0.13, alpha: 1.0)
        return label
    }()
    
    var infoField: FormattedTextField = {
        var textField = FormattedTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont(name: "Lato-Medium", size: 17)
        textField.textColor = UIColor.ATColors.darkGray
        textField.formatting = .phoneNumber
        textField.keyboardType = .numberPad
        textField.addDoneCancelToolbar()
        return textField
    }()

    var cellIcon: UIButton = {
        var icon = UIButton()
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.contentMode = .scaleAspectFit
        return icon
    }()
    
    var isInfoField = true
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addSubview(headingLabel)
        self.addSubview(infoField)
        self.addSubview(cellIcon)
    }
    
    override func layoutSubviews() {
        let spacingConstantSmall: CGFloat = 8.0
        let spacingConstantMed: CGFloat = 20.0
        let spacingConstantLg: CGFloat = 30.0
        
        cellIcon.customizeBGImage(color: UIColor.ATColors.midBlue)
        
        cellIcon.topAnchor.constraint(equalTo: self.topAnchor, constant: spacingConstantSmall).isActive = true
        cellIcon.rightAnchor.constraint(equalTo: headingLabel.leftAnchor, constant: -spacingConstantMed).isActive = true
        cellIcon.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: spacingConstantSmall).isActive = true
        cellIcon.leftAnchor.constraint(equalTo: self.leftAnchor, constant: spacingConstantMed).isActive = true
        cellIcon.widthAnchor.constraint(equalTo: self.heightAnchor, constant: -70).isActive = true
        
        headingLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: spacingConstantLg).isActive = true
        headingLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 30).isActive = true
        
        infoField.topAnchor.constraint(equalTo: headingLabel.bottomAnchor, constant: 14).isActive = true
        infoField.leftAnchor.constraint(equalTo: headingLabel.leftAnchor, constant: 1).isActive = true
        infoField.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -spacingConstantLg).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
