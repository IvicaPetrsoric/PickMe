//
//  RideStartedViewController.swift
//  PickMe
//
//  Created by Ivica Petrsoric on 28/03/2018.
//  Copyright © 2018 Ivica Petrsoric. All rights reserved.
//

import UIKit
import MapKit

class RideStartedViewController: UIViewController {
    
    enum RideStatus: String {
        case startRide
        case pickedUp
        case stopOver
        case continueRide
        case endRide
    }
   
    var service = Server()
    var rideStartedView = RideStartedView()
    
    let locationManager = LocationManager.shared
    var distance = Measurement(value: 0, unit: UnitLength.meters)
    var locationList: [CLLocation] = []
    let pauseTimeOfGPSUpdate: TimeInterval = 8
    
    var currentRideId = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .darkBlue
        navigationItem.title = "Status: Driving".localized
        
        setupRideView()
        startRide()
    }
    
    private func setupRideView() {
        rideStartedView.delegate = self
        rideStartedView.frameWidth = view.frame.width
        rideStartedView.showView()
        
        view.addSubview(rideStartedView)
        rideStartedView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    private func startRide() {
        distance = Measurement(value: 0, unit: UnitLength.meters)
        locationList.removeAll()
        startLocationUpdates()
        updateWorkflowAction(byStatus: .startRide)
    }
        
    private func startLocationUpdates() {
        locationManager.delegate = self
        locationManager.activityType = .automotiveNavigation
        locationManager.distanceFilter = 10
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.startUpdatingLocation()
        
        if let startLocation = locationManager.location?.coordinate {
            let viewRegion = MKCoordinateRegionMakeWithDistance(startLocation, 500, 500)
            rideStartedView.addRegionToMap(region: viewRegion)
        }
    }
    
    func updateWorkflowAction(byStatus: RideStatus) {
        guard let lastLocation = locationList.last?.coordinate else { return }
        let actionData = CurrentRideLocations(bookingId: currentRideId,
                                              status: RideStatus.pickedUp.rawValue,
                                              sendOnServer: false,
                                              latitude: lastLocation.latitude,
                                              longitude: lastLocation.longitude,
                                              timestamp: Date(),
                                              distance: "")
        
        service.sendWorlflowAction(data: actionData)
    }
    
    func dropPinZoomIn(placemark: MKPlacemark){
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = "Passanger".localized
        
        let newLocationData = CurrentRideLocations(bookingId: currentRideId,
                                                   status: RideStatus.pickedUp.rawValue,
                                                   sendOnServer: false,
                                                   latitude: placemark.coordinate.latitude,
                                                   longitude: placemark.coordinate.longitude,
                                                   timestamp: Date(),
                                                   distance: "\(FormatDisplay.distance(distance))")
        CoreDataManager.shared.createRideLocationDetails(forLocationData: newLocationData)
        
        rideStartedView.addAnnotation(annotation: annotation)
    }

}



