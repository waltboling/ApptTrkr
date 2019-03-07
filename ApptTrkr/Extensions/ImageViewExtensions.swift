//
//  ImageViewExtensions.swift
//  ApptTrkr
//
//  Created by Jon Boling on 2/22/19.
//  Copyright © 2019 Walt Boling. All rights reserved.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    func loadImageUsingCacheWithURLString(urlString: String) {
        
        self.image = UIImage(named: "ATPlaceholderImage")
        //check if image is cached 
        if let cachedImage = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = cachedImage
            return
        }
        
        //otherwise download image and cache it
        if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                if let error = error {
                    print(error)
                    return
                } else {
                    DispatchQueue.main.async {
                        if let downloadedImage = UIImage(data: data!) {
                            imageCache.setObject(downloadedImage, forKey: urlString as AnyObject)
                            
                            self.image = downloadedImage
                        }
                    }
                }
            }).resume()
        }
    }
}
