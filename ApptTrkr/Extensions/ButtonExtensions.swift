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
    func customizeBGImage(color: UIColor) {
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

    func customizeFGImage(color: UIColor) {
        let image = self.imageView?.image
        let tintedImage = image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        self.setImage(tintedImage, for: .normal)
        self.tintColor = color
        self.contentMode = .scaleAspectFit
    }
}

extension UIImageView {
    func recolorImage(color: UIColor) {
        let image = self.image
        let tintedImage = image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        self.image = tintedImage
        self.tintColor = color
        self.contentMode = .scaleAspectFit
    }
}
