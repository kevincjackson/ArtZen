//
//  Formatting.swift
//  ArtZen
//
//  Created by Kevin Jackson on 6/17/19.
//  Copyright © 2019 Kevin Jackson. All rights reserved.
//

import Foundation


extension Float {
    
    var percentageViewed: String {
        let formattedFloat = String(format: "%3.1f", self * 100)
        return "\(formattedFloat)% viewed"
    }
}
