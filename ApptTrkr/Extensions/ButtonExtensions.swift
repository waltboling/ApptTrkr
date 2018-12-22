//
//  ButtonExtensions.swift
//  ApptTrkr
//
//  Created by Jon Boling on 12/20/18.
//  Copyright © 2018 Walt Boling. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    func customize(color: UIColor) {
        let image = self.backgroundImage(for: .normal)
        //custom tint for button image
        let tintedImage = image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        self.setBackgroundImage(tintedImage, for: .normal)
        self.tintColor = color
        
        //layout button
        self.contentMode = .scaleAspectFill
        self.layoutIfNeeded()
        self.subviews.first?.contentMode = .scaleAspectFit
    }
}
