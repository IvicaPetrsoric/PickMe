//
//  RideStartedViewController+ViewDelegate.swift
//  PickMe
//
//  Created by Ivica Petrsoric on 02/04/2018.
//  Copyright © 2018 Ivica Petrsoric. All rights reserved.
//

import Foundation
import MapKit

extension RideStartedViewController: RideStartedViewDelegate {
    
    func ridePassangerPicked() {
        navigationItem.title = "Status: New Passanger".localized
        updateWorkflowAction(byStatus: .pickedUp)
    }
    
    func rideStopOver() {
        navigationItem.title = "Status: Stop Over".localized
        updateWorkflowAction(byStatus: .stopOver)
        
        if let pinCoor = locationList.last?.coordinate{
            dropPinZoomIn(placemark: MKPlacemark(coordinate: pinCoor))
        } else if let pinCoor = locationManager.location?.coordinate {
            dropPinZoomIn(placemark: MKPlacemark(coordinate: pinCoor))
        }
    }
    
    func rideContinue() {
        navigationItem.title = "Status: Driving".localized
        updateWorkflowAction(byStatus: .continueRide)
    }
    
    func rideEnd() {
        updateWorkflowAction(byStatus: .stopOver)
        locationManager.stopUpdatingLocation()
        locationManager.allowsBackgroundLocationUpdates = false
        locationManager.pausesLocationUpdatesAutomatically = true
        rideStartedView.delegate = nil
        dismiss(animated: true, completion: nil)
    }
    
}
