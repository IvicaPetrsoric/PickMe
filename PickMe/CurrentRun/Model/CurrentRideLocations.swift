//
//  CurrentRideLocations.swift
//  PickMe
//
//  Created by Ivica Petrsoric on 29/03/2018.
//  Copyright © 2018 Ivica Petrsoric. All rights reserved.
//

import Foundation

struct CurrentRideLocations {
    
    let bookingId: Int
    let status: String
    var sendOnServer: Bool
    let latitude: Double
    let longitude: Double
    let timestamp: Date
    let distance: String
    
}