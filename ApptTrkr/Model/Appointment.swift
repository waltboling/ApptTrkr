//
//  Appointment.swift
//  ApptTrkr
//
//  Created by Jon Boling on 12/20/18.
//  Copyright © 2018 Walt Boling. All rights reserved.
//

import Foundation
import Firebase

class Appointment {
    var title: String
    var type: String
    // var date: Date // Firebase doesnt store dates, so i changed it to string for time being
    var date: String
    //var provider: ServiceProvider // switched to store key only. will see if this works
    var providerKey: String
    var providerName: String
    var notes: String
    
    init(title: String, type: String, date: String, providerKey: String, providerName: String, notes: String){
        self.title = title
        self.type = type
        self.date = date
        self.providerKey = providerKey
        self.providerName = providerName
        self.notes = notes
    }
    
    init?(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String:AnyObject],
            let title = value["title"] as? String,
            let type = value["type"] as? String,
            let date = value["date"] as? String,
            let providerKey = value["providerKey"] as? String,
            let providerName = value["providerName"] as? String,
            let notes = value["notes"] as? String
            else {
                return nil
        }
        
        self.title = title
        self.type = type
        self.date = date
        self.providerKey = providerKey
        self.providerName = providerName
        self.notes = notes
    }
    
}
