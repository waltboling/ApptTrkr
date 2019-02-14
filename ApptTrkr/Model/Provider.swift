//
//  Provider.swift
//  ApptTrkr
//
//  Created by Jon Boling on 12/20/18.
//  Copyright © 2018 Walt Boling. All rights reserved.
//

import Foundation

class serviceProvider {
    var name: String
    var type: String
    var website: String
    var phoneNumber: String
    var email: String
    var address: String
    var fax: String
    var notes: String

    init(name: String, type: String, website: String, phoneNumber: String, email: String, address: String, fax: String, notes: String) {
        self.name = name
        self.type = type
        self.website = website
        self.phoneNumber = phoneNumber
        self.email = email
        self.address = address
        self.fax = fax
        self.notes = notes
    }
}
