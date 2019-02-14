//
//  ServiceProvider.swift
//  ApptTrkr
//
//  Created by Jon Boling on 12/20/18.
//  Copyright © 2018 Walt Boling. All rights reserved.
//

import Foundation
import Firebase

class ServiceProvider {
    var name: String
    var type: String
    var website: String
    var phoneNumber: String
    var email: String
    var address: String
    var fax: String
    var notes: String
    var imageURL: String

    init(name: String, type: String, website: String, phoneNumber: String, email: String, address: String, fax: String, notes: String, imageURL: String) {
        self.name = name
        self.type = type
        self.website = website
        self.phoneNumber = phoneNumber
        self.email = email
        self.address = address
        self.fax = fax
        self.notes = notes
        self.imageURL = imageURL
    }
    
    init?(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String: AnyObject],
            let name = value["name"] as? String,
            let type = value["type"] as? String,
            let website = value["website"] as? String,
            let phoneNumber = value["phone"] as? String,
            let email = value["email"] as? String,
            let address = value["address"] as? String,
            let fax = value["fax"] as? String,
            let notes = value["notes"] as? String,
            let imageURL = value["imageURL"] as? String
    
            else {
                return nil
        }
        
        self.name = name
        self.type = type
        self.website = website
        self.phoneNumber = phoneNumber
        self.email = email
        self.address = address
        self.fax = fax
        self.notes = notes
        self.imageURL = imageURL
        
    }
}
