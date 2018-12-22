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
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor(red: 0.64, green: 0.1176, blue: 0.13, alpha: 1.0)
        return label
    }()
    
    var notesView: UITextView = {
        var textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.systemFont(ofSize: 17)
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
        self.addSubview(headingLabel)
        self.addSubview(notesView)
        self.addSubview(cellIcon)
    }
    
    override func layoutSubviews() {
        let spacingConstantSmall: CGFloat = 8.0
        let spacingConstantMed: CGFloat = 20.0
        let spacingConstantLg: CGFloat = 30.0
        
        cellIcon.customize(color: UIColor(red: 0.38, green: 0.584, blue: 0.847, alpha: 1.0))
        
        cellIcon.topAnchor.constraint(equalTo: self.topAnchor, constant: spacingConstantSmall).isActive = true
        cellIcon.rightAnchor.constraint(equalTo: headingLabel.leftAnchor, constant: -spacingConstantMed).isActive = true
        cellIcon.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: spacingConstantSmall).isActive = true
        cellIcon.leftAnchor.constraint(equalTo: self.leftAnchor, constant: spacingConstantMed).isActive = true
        cellIcon.widthAnchor.constraint(equalTo: self.heightAnchor, constant: -70).isActive = true
        
        headingLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: spacingConstantLg).isActive = true
        headingLabel.bottomAnchor.constraint(equalTo: notesView.topAnchor, constant: -5).isActive = true
        
        notesView.leftAnchor.constraint(equalTo: headingLabel.leftAnchor).isActive = true
        notesView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -spacingConstantLg)
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
