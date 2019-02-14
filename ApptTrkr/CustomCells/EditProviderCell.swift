//
//  EditProviderCell.swift
//  ApptTrkr
//
//  Created by Jon Boling on 2/12/19.
//  Copyright © 2019 Walt Boling. All rights reserved.
//

import UIKit

class EditProviderCell: UITableViewCell {
    
    var headingLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor(red: 0.64, green: 0.1176, blue: 0.13, alpha: 1.0)
        return label
    }()
    
    var infoField: UITextField = {
        var textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont.systemFont(ofSize: 17)
        textField.textColor = UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1.0)
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
        //alt blue -> (color: UIColor(red: 0.38, green: 0.584, blue: 0.847, alpha: 1.0))
        
        cellIcon.topAnchor.constraint(equalTo: self.topAnchor, constant: spacingConstantSmall).isActive = true
        cellIcon.rightAnchor.constraint(equalTo: headingLabel.leftAnchor, constant: -spacingConstantMed).isActive = true
        cellIcon.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: spacingConstantSmall).isActive = true
        cellIcon.leftAnchor.constraint(equalTo: self.leftAnchor, constant: spacingConstantMed).isActive = true
        cellIcon.widthAnchor.constraint(equalTo: self.heightAnchor, constant: -70).isActive = true
        
        headingLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: spacingConstantLg).isActive = true
        headingLabel.bottomAnchor.constraint(equalTo: infoField.topAnchor, constant: -5).isActive = true
        
        infoField.leftAnchor.constraint(equalTo: headingLabel.leftAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
