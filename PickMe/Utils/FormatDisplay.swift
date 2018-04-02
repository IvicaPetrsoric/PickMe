//
//  FormatDisplay.swift
//  PickMe
//
//  Created by Ivica Petrsoric on 29/03/2018.
//  Copyright © 2018 Ivica Petrsoric. All rights reserved.
//

import Foundation

struct FormatDisplay {
    static func distance(_ distance: Double) -> String {
        let distanceMeasurement = Measurement(value: distance, unit: UnitLength.meters)
        return FormatDisplay.distance(distanceMeasurement)
    }

    static func distance(_ distance: Measurement<UnitLength>) -> String {
        let formatter = MeasurementFormatter()
        return formatter.string(from: distance)
    }
    
    enum DateFormat: String {
        case HHmm = "HH:mm"
        case MMddyyyy = "MM.dd.yyyy"
    }
    
    static func time(date: Date, format: String) -> String {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = format
        return dateFormater.string(from: date)
    }



}
