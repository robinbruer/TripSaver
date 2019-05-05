//
//  SavedTrip.swift
//  App2
//
//  Created by Robin on 26/04/2019.
//  Copyright © 2019 Robin. All rights reserved.
//

import UIKit
import MapboxGeocoder

class SavedTrip {
    
    var destination: String
    var titel: String
    var image: Data
  
    init(destination: String, titel: String, image: Data) {
        self.destination = destination
        self.titel = titel
        self.image = image
    }
    
    init(data: Dictionary<String, String>, imageData: Dictionary<String, Data>) {
        if let destination = data["destination"], let titel = data["titel"], let image = imageData["image"]{
            self.destination = destination
            self.titel = titel
            self.image = image
        }else {
            self.destination = ""
            self.titel = ""
            self.image = Data()
        }
    }
    
    func tripDictionary() -> Dictionary<String, String>{
        return ["destination": self.destination, "titel": self.titel]
    }
    
    func tripImgDict() -> Dictionary<String, Data>{
        return ["image": self.image]
    }
    
}
