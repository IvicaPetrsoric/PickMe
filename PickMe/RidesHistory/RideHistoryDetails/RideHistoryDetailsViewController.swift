//
//  RideHistoryDetailsViewController.swift
//  PickMe
//
//  Created by Ivica Petrsoric on 30/03/2018.
//  Copyright © 2018 Ivica Petrsoric. All rights reserved.
//

import UIKit
import MapKit

class RideHistoryDetailsViewController: UITableViewController {
    
    var ride: Ride?
    
    var cellId = "cellId"
    
    enum RideStatus: String {
        case pickedUp
        case rideOn
    }
    
    lazy var mapView: MKMapView = {
        let map = MKMapView()
        map.delegate = self
        return map
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Ride Details".localized
        
        tableView.backgroundColor = .darkBlue
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.register(RideHistoryDetailsCell.self, forCellReuseIdentifier: cellId)
        
        loadMap()
    }

    private func loadMap() {
        guard let region = mapRegion() else { return }
            
        mapView.setRegion(region, animated: true)
        mapView.add(polyLine())
    }
    
}


