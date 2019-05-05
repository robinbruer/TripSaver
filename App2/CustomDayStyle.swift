//
//  CustomDayStyle.swift
//  App2
//
//  Created by Robin on 01/05/2019.
//  Copyright © 2019 Robin. All rights reserved.
//

import Foundation
import MapboxNavigation

class CustomDayStyle: DayStyle {
    
    required init() {
        super.init()
        
        // Use a custom map style.
        mapStyleURL = URL(string: "mapbox://styles/mapbox/satellite-streets-v9")!
        
        // Specify that the style should be used during the day.
        styleType = .day
    }
    
    override func apply() {
        super.apply()
        
        // Begin styling the UI
        BottomBannerView.appearance().backgroundColor = .orange
    }
}
