//
//  CustomNightStyle.swift
//  App2
//
//  Created by Robin on 01/05/2019.
//  Copyright © 2019 Robin. All rights reserved.
//

import Foundation
import MapboxNavigation

class CustomNightStyle: NightStyle {
    
    required init() {
        super.init()
        
        // Specify that the style should be used at night.
        styleType = .night
    }
    
    override func apply() {
        super.apply()
        
        // Begin styling the UI
        BottomBannerView.appearance().backgroundColor = .purple
    }
}
