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
        
    }
    
    static func time(date: Date, format: String) -> String {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = format
        return dateFormater.string(from: date)
    }

//    static func time(_ seconds: Int) -> String {
//        let formatter = DateComponentsFormatter()
//        formatter.allowedUnits = [.hour, .minute, .second]
//        formatter.unitsStyle = .positional
//        formatter.zeroFormattingBehavior = .pad
//        return formatter.string(from: TimeInterval(seconds))!
//    }

}
