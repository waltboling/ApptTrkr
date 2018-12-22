//
//  CustomHeaderView.swift
//  ApptTrkr
//
//  Created by Jon Boling on 12/21/18.
//  Copyright © 2018 Walt Boling. All rights reserved.
//

import UIKit

class CustomHeaderView: UIView {

    @IBOutlet weak var imageView: UIImageView!
    
    var image: UIImage? {
        didSet {
            if let image = image {
                imageView.image = image
            } else {
                imageView.image = nil
            }
        }
    }
}
