//
//  MainCell.swift
//  ApptTrkr
//
//  Created by Jon Boling on 12/17/18.
//  Copyright © 2018 Walt Boling. All rights reserved.
//

import UIKit

class MainCell: UITableViewCell {

    var providerBtn: UIButton = {
        var button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(UIImage(named: "providerInfoIcon"), for: .normal)
        return button
    }()
    
    var apptBtn: UIButton = {
        var button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(UIImage(named: "apptListIcon"), for: .normal)
        //button.addTarget(button, action: #selector(buttonAction), for: .touchUpInside)
        return button
    }()
    
    var providerNameLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Lato-Medium", size: 18)
        label.textColor = UIColor.ATColors.darkRed
        label.text = "Provider Name"
        return label
    }()
    
    var providerTypeLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Lato-Regular", size: 17)
        label.textColor = UIColor.lightGray
        label.text = "Provider Type"
        return label
    }()
    
    var providerTapAction: (() -> Void)? = nil
    var apptTapAction: (() -> Void)? = nil
    
    @objc func providerButtonTap() {
        if let tapAction = providerTapAction {
            providerTapAction!()
        }
    }
    
    @objc func apptButtonTap() {
        if let tapAction = apptTapAction {
            apptTapAction!()
        }
    }
    
    /*@objc func buttonAction() {
        tapAction?(self)
    }*/
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addSubview(providerBtn)
        self.addSubview(apptBtn)
        self.addSubview(providerNameLabel)
        self.addSubview(providerTypeLabel)
        //apptBtn.addTarget(apptBtn, action: #selector(buttonAction), for: .touchUpInside)
        //self.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1.0)
    }
    
    override func layoutSubviews() {
        //let spacingConstantSmall: CGFloat = 15.0
        let spacingConstantMed: CGFloat = 25.0
        
        apptBtn.customizeBGImage(color: UIColor.ATColors.midBlue)
        providerBtn.customizeBGImage(color: UIColor.ATColors.midBlue)
        
        //layoutButtons(image: UIImage(named: "calendarIcon")!, button: apptBtn)
        //layoutButtons(image: UIImage(named: "providerIcon")!, button: providerBtn)
        
        apptBtn.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8).isActive = true
        apptBtn.topAnchor.constraint(equalTo: self.topAnchor, constant: spacingConstantMed + 4).isActive = true
        apptBtn.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -(spacingConstantMed + 4)).isActive = true
        apptBtn.widthAnchor.constraint(equalTo: self.heightAnchor, constant: -20).isActive = true
        
        providerBtn.rightAnchor.constraint(equalTo: apptBtn.leftAnchor, constant: 0).isActive = true
        providerBtn.topAnchor.constraint(equalTo: self.topAnchor, constant: spacingConstantMed + 4).isActive = true
        providerBtn.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -(spacingConstantMed + 4)).isActive = true
        providerBtn.widthAnchor.constraint(equalTo: self.heightAnchor, constant: -20).isActive = true
        
        providerNameLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: spacingConstantMed).isActive = true
        providerNameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: spacingConstantMed + 5).isActive = true
        providerNameLabel.heightAnchor.constraint(equalToConstant: 21).isActive = true
        providerNameLabel.rightAnchor.constraint(equalTo: providerBtn.leftAnchor, constant: spacingConstantMed).isActive = true
        
        providerTypeLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: spacingConstantMed).isActive = true
        providerTypeLabel.topAnchor.constraint(equalTo: providerNameLabel.bottomAnchor, constant: 2).isActive = true
        providerTypeLabel.rightAnchor.constraint(equalTo: providerBtn.leftAnchor, constant: spacingConstantMed).isActive = true
        providerTypeLabel.heightAnchor.constraint(equalToConstant: 22).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layoutButtons(image: UIImage, button: UIButton) {
        
        //custom tint for button image
        let tintedImage = image.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        button.setBackgroundImage(tintedImage, for: .normal)
        button.tintColor = UIColor(red: 0.0117, green: 0.18, blue: 0.204, alpha: 1.0)
        
        //layout button
        button.contentMode = .scaleAspectFill
        button.layoutIfNeeded()
        button.subviews.first?.contentMode = .scaleAspectFit
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
