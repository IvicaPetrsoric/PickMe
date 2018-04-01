//
//  RideHistoryViewController.swift
//  PickMe
//
//  Created by Ivica Petrsoric on 30/03/2018.
//  Copyright © 2018 Ivica Petrsoric. All rights reserved.
//

import UIKit

class RideHistoryViewController: UITableViewController {
    
    var rides = [Ride]()
    
    var cellId = "cellId"
    
    private var service = Server()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .darkBlue
        
        navigationItem.title = "Ride Historys".localized
        
        tableView.backgroundColor = .darkBlue
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.register(RideHistoryCell.self, forCellReuseIdentifier: cellId)
        
        rides = CoreDataManager.shared.fetchRides()
        
        checkGPSDataSendedToServer()
    }
    
    func checkGPSDataSendedToServer(){
        for ride in rides {
            for rideLocations in ride.locations! {
                let locationData = rideLocations as! Location
                
                if !locationData.sendOnServer {
                    guard let timestamp = locationData.timestamp, let distance = locationData.distance else { return}
                    
                    let newLocationData = CurrentRideLocations(bookingId: Int(locationData.bookingId),
                                                               status: "",
                                                               sendOnServer: false,
                                                               latitude: locationData.latitude,
                                                               longitude: locationData.longitude,
                                                               timestamp: timestamp,
                                                               distance: distance)
                    
                    service.sendGPS(data: newLocationData) { (statusCompletion: Bool) in
                        if statusCompletion {
                            CoreDataManager.shared.updateRideLocationSendOnServer(location: locationData)
                        }
                    }
                }
            }
        }
    }
    
}
