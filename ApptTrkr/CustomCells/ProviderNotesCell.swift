//
//  ProviderNotesCell.swift
//  ApptTrkr
//
//  Created by Jon Boling on 12/20/18.
//  Copyright © 2018 Walt Boling. All rights reserved.
//

import UIKit

class ProviderNotesCell: UITableViewCell {

    var headingLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Lato-Medium", size: 15)
        label.textColor = UIColor(red: 0.64, green: 0.1176, blue: 0.13, alpha: 1.0)
        return label
    }()
    
    var infoView: UITextView = {
        var textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont(name: "Lato-Medium", size: 17)
        textView.textColor = UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1.0)
        return textView
    }()
    
    var cellIcon: UIButton = {
        var icon = UIButton()
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.contentMode = .scaleAspectFit
        return icon
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.addSubview(infoView)
        self.addSubview(cellIcon)
        self.addSubview(headingLabel)
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
        
        headingLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 30).isActive = true
        //headingLabel.bottomAnchor.constraint(equalTo: infoView.topAnchor, constant: -5).isActive = true
        
        infoView.topAnchor.constraint(equalTo: headingLabel.bottomAnchor, constant: 5).isActive = true
        infoView.leftAnchor.constraint(equalTo: headingLabel.leftAnchor, constant: -3).isActive = true
        infoView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -spacingConstantLg).isActive = true
        infoView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -2).isActive = true
        //infoView.heightAnchor.constraint(equalTo: self.heightAnchor, constant: -5).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
