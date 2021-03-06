//
//  RideSetupViewController+RideViewDelegate.swift
//  PickMe
//
//  Created by Ivica Petrsoric on 02/04/2018.
//  Copyright © 2018 Ivica Petrsoric. All rights reserved.
//

import UIKit

extension RideSetupViewController: RideSetupViewDelegate {
    
    func prepareForRide(startLoc: String, endLoc: String, passangers: String) {
        if startLoc.isEmptyOrWhitespace() {
            showAllert(message: AlertMessage.missingStartLoc.rawValue)
            return
        } else if endLoc.isEmptyOrWhitespace() {
            showAllert(message: AlertMessage.missingEndLoc.rawValue)
            return
        } else if passangers.isEmptyOrWhitespace(){
            showAllert(message: AlertMessage.missingPassngers.rawValue)
            return
        }
        
        let currentRideId = userDefaults.load(key: RideUserDefaults.UserKey.rideID)
        
        let newRide = CurrentRideDetails(bookingId: currentRideId, locStart: startLoc, locEnd: endLoc, passangers: passangers, timeStart: Date())
        CoreDataManager.shared.createRide(currentRideDetails: newRide)
        
        let rideStartedViewController = RideStartedViewController()
        rideStartedViewController.currentRideId = currentRideId
        
        let navController = CustomNavigationController(rootViewController: rideStartedViewController)
        present(navController, animated: true) {
            let newValue = currentRideId + 1
            self.userDefaults.save(value: newValue, key: RideUserDefaults.UserKey.rideID)
        }
    }
    
}
