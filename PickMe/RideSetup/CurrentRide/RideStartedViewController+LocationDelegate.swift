//
//  RideStartedViewController+LocationDelegate.swift
//  PickMe
//
//  Created by Ivica Petrsoric on 02/04/2018.
//  Copyright © 2018 Ivica Petrsoric. All rights reserved.
//

import CoreLocation
import MapKit

extension RideStartedViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        for newLocation in locations {
            let howRecent = newLocation.timestamp.timeIntervalSinceNow
            guard abs(howRecent) < pauseTimeOfGPSUpdate else { continue }
            
            if let lastLocation = locationList.last {
                let delta = newLocation.distance(from: lastLocation)
                distance = distance + Measurement(value: delta, unit: UnitLength.meters)
                let coordinates = [lastLocation.coordinate, newLocation.coordinate]
                let polyLine = MKPolyline(coordinates: coordinates, count: 2)
                rideStartedView.addPolylineToMap(line: polyLine)
                
                let region = MKCoordinateRegionMakeWithDistance(newLocation.coordinate, 500, 500)
                rideStartedView.addRegionToMap(region: region)
            }
            
            locationList.append(newLocation)
            updateGPSposition(location: newLocation)
        }
    }
    
    func updateGPSposition(location: CLLocation) {
        var newLocationData = CurrentRideLocations(bookingId: currentRideId,
                                                   status: "",
                                                   sendOnServer: false,
                                                   latitude: location.coordinate.latitude,
                                                   longitude: location.coordinate.longitude,
                                                   timestamp: Date(),
                                                   distance: "\(FormatDisplay.distance(distance))")
        service.sendGPS(data: newLocationData) { (statusCompletion: Bool) in
            newLocationData.sendOnServer = statusCompletion
            CoreDataManager.shared.createRideLocationDetails(forLocationData: newLocationData)
        }
    }
}
