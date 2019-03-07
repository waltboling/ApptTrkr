//
//  CalendarHeaderCell.swift
//  ApptTrkr
//
//  Created by Jon Boling on 12/20/18.
//  Copyright © 2018 Walt Boling. All rights reserved.
//

import UIKit

class CalendarHeaderCell: UITableViewCell {
    var headerLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = UIColor.white
        return label
    }()
    
    var headerBackground: UIImageView = {
        var imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "abstractBlur")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.alpha = 0.4
        imageView.layer.cornerRadius = 5
        return imageView
    }()
    
    var overlayView: UIView = {
        var overlay = UIView()
        overlay.translatesAutoresizingMaskIntoConstraints = false
        overlay.backgroundColor = UIColor.white
        overlay.alpha = 1
        return overlay
    }()
    
    var colorOverlay: UIView = {
        var overlay = UIView()
        overlay.translatesAutoresizingMaskIntoConstraints = false
        overlay.backgroundColor = UIColor(red: 0.912, green: 0.37, blue: 0.317, alpha: 1.0)
        overlay.alpha = 0.9
        overlay.layer.cornerRadius = 5
        return overlay
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
       
        self.addSubview(overlayView)
        self.addSubview(headerBackground)
        self.addSubview(colorOverlay)
        self.addSubview(headerLabel)
    }
    
    override func layoutSubviews() {
        let headerOffset: CGFloat = 0
        
        headerLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        headerLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        headerBackground.leftAnchor.constraint(equalTo: self.leftAnchor, constant: headerOffset).isActive = true
        headerBackground.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        headerBackground.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -headerOffset).isActive = true
        headerBackground.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        overlayView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        overlayView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        overlayView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        overlayView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        
        colorOverlay.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        colorOverlay.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -headerOffset).isActive = true
        colorOverlay.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        colorOverlay.leftAnchor.constraint(equalTo: self.leftAnchor, constant: headerOffset).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
