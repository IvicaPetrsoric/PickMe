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
    
    lazy var mapView: MKMapView = {
        let map = MKMapView()
        map.delegate = self
        map.showsUserLocation = true
        return map
    }()
    
    let balackBackgroundMask: UIView = {
        let view = UIView()
        view.backgroundColor = .darkBlue
        return view
    }()
    
    let passangerPickedButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Passanger Picked Up".localized, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.backgroundColor = .lightOrange
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(handlepassangerPicked), for: .touchUpInside)
        return button
    }()
    
    let stopOverButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Stop Over".localized, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.backgroundColor = .midBlue
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(handleStopOver), for: .touchUpInside)
        return button
    }()
    
    let endRidePickedButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("End Ride".localized, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.backgroundColor = .lightRed
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(handleEndRide), for: .touchUpInside)
        return button
    }()
    
    let continueRideButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Continue Ride".localized, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.backgroundColor = .lightGreen
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(handleContineRide), for: .touchUpInside)
        return button
    }()
    
    let detailsLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    @objc private func handlepassangerPicked() {
        navigationItem.title = "Status: New Passanger".localized
        stopMonitoringLocation()
        updateWorkflowAction(byStatus: .pickedUp)

        UIView.animate(withDuration: 0.3) {
            self.balackBackgroundMask.alpha = 0.7
            self.passangerPickedButton.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
            self.stopOverButton.transform = CGAffineTransform.identity
            self.endRidePickedButton.transform = CGAffineTransform.identity
        }
    }
    
    @objc private func handleStopOver() {
        navigationItem.title = "Status: Stop Over".localized
        updateWorkflowAction(byStatus: .stopOver)
        
        if let pinCoor = locationList.last?.coordinate{
            dropPinZoomIn(placemark: MKPlacemark(coordinate: pinCoor))
        } else if let pinCoor = locationManager.location?.coordinate {
            dropPinZoomIn(placemark: MKPlacemark(coordinate: pinCoor))
        }

        UIView.animate(withDuration: 0.3) {
            self.stopOverButton.transform = CGAffineTransform(translationX: -self.view.frame.width / 2, y: 0)
            self.endRidePickedButton.transform = CGAffineTransform(translationX: self.view.frame.width / 2, y: 0)
            self.continueRideButton.transform = CGAffineTransform.identity
        }
    }
    
    @objc private func handleContineRide() {
        navigationItem.title = "Status: Driving".localized
        resumeMonitoringLocation()
        updateWorkflowAction(byStatus: .continueRide)

        
        UIView.animate(withDuration: 0.3) {
            self.balackBackgroundMask.alpha = 0
            self.continueRideButton.transform = CGAffineTransform(translationX: 0, y: self.view.frame.width / 5)
            self.passangerPickedButton.transform = CGAffineTransform.identity
        }
    }
    
    private func updateWorkflowAction(byStatus: RideStatus) {
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
    
    
    
    @objc private func handleEndRide() {
        updateWorkflowAction(byStatus: .stopOver)
        locationManager.allowsBackgroundLocationUpdates = false
        locationManager.pausesLocationUpdatesAutomatically = true
        dismiss(animated: true, completion: nil)
    }
    
    private func setupViews() {
        view.addSubview(mapView)
        view.addSubview(balackBackgroundMask)
        
        view.addSubview(passangerPickedButton)
        view.addSubview(stopOverButton)
        view.addSubview(endRidePickedButton)
        view.addSubview(continueRideButton)
        
        view.addSubview(detailsLabel)
        
        balackBackgroundMask.alpha = 0
        
        stopOverButton.transform = CGAffineTransform(translationX: -view.frame.width / 2, y: 0)
        endRidePickedButton.transform = CGAffineTransform(translationX: view.frame.width / 2, y: 0)
        continueRideButton.transform = CGAffineTransform(translationX: 0, y: view.frame.width / 4)
        
        mapView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        balackBackgroundMask.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        passangerPickedButton.anchor(top: nil, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 8, paddingRight: 8, width: 0, height: 44)
        
        stopOverButton.anchor(top: nil, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 8, paddingBottom: 8, paddingRight: 0, width: view.frame.width / 2 - 16, height: 44)
        
        endRidePickedButton.anchor(top: nil, left: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 8, paddingRight: 8, width: view.frame.width / 2 - 16, height: 44)
        
        continueRideButton.anchor(top: nil, left: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 8, paddingRight: 0, width: view.frame.width * 0.75, height: 44)
        continueRideButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        detailsLabel.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 8, paddingLeft: 4, paddingBottom: 0, paddingRight: 0, width: 0, height: 100)
    }
    
    enum RideStatus: String {
        case startRide
        case pickedUp
        case stopOver
        case continueRide
        case endRide
    }
    
    var currentState = RideStatus.startRide
    
    
    private var service = Server()
    
    var newRide: CurrentRideDetails?
//    private var locationsData = [CurrentRideLocations]()
    
    private let locationManager = LocationManager.shared
    private var seconds = 0
    private var timer: Timer?
    private var distance = Measurement(value: 0, unit: UnitLength.meters)
    private var locationList: [CLLocation] = []
    
    private var startTime = Date()
    
    var currentRideId = Int()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .darkBlue
        navigationItem.title = "Status: Driving".localized
        
        setupViews()
        startRide()
    }
        
    private func startRide() {
        mapView.removeOverlays(mapView.overlays)
        startTime = Date()
        seconds = 0
        distance = Measurement(value: 0, unit: UnitLength.meters)
        locationList.removeAll()
        updateDisplay()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.eachSecond()
        }
        startLocationUpdates()
        updateWorkflowAction(byStatus: .startRide)
    }
    
    func stopMonitoringLocation() {
        locationManager.stopUpdatingLocation()
        timer?.invalidate()
        timer = nil
    }
    
    func resumeMonitoringLocation(){
        locationManager.startUpdatingLocation()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.eachSecond()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
    }
    
    func eachSecond() {
        seconds += 1
        updateDisplay()
    }
    
    private var formattedDistance = "0"
    
    private func updateDisplay() {
//        let components = Calendar.current.dateComponents([.hour, .minute, .second], from: startTime, to: Date())
        
        formattedDistance = FormatDisplay.distance(distance)
//        let formattedTime = FormatDisplay.time(components.second!)
        
//        currentDistance = formattedDistance
        
        guard let lastLocation = locationList.last?.coordinate else { return }

        
        var displayText = "Distance:  \(formattedDistance) \n"
//        displayText += "Time:  \(formattedTime)\n"
        displayText += "Lat: \(lastLocation.latitude)\n"
        displayText += "Long: \(lastLocation.longitude)"
        detailsLabel.text = displayText
    }
    
    // u sec
    let pauseTimeOfGPS: TimeInterval = 8
    
    private func startLocationUpdates() {
        locationManager.delegate = self
        locationManager.activityType = .automotiveNavigation
        locationManager.distanceFilter = 10
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.startUpdatingLocation()
        
        if let startLocation = locationManager.location?.coordinate {
            let viewRegion = MKCoordinateRegionMakeWithDistance(startLocation, 500, 500)
            mapView.setRegion(viewRegion, animated: true)
        }
    }
    
    private func dropPinZoomIn(placemark: MKPlacemark){
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = "Passanger".localized
        
        let newLocationData = CurrentRideLocations(bookingId: currentRideId,
                                                   status: RideStatus.pickedUp.rawValue,
                                                   sendOnServer: false,
                                                   latitude: placemark.coordinate.latitude,
                                                   longitude: placemark.coordinate.longitude,
                                                   timestamp: Date(),
                                                   distance: "\(formattedDistance)")
        CoreDataManager.shared.createRideLocationDetails(forLocationData: newLocationData)
        
        
        mapView.addAnnotation(annotation)
    }
    
    private func updateGPSposition(location: CLLocation) {
        var newLocationData = CurrentRideLocations(bookingId: currentRideId,
                                                   status: "",
                                                   sendOnServer: false,
                                                   latitude: location.coordinate.latitude,
                                                   longitude: location.coordinate.longitude,
                                                   timestamp: Date(),
                                                   distance: "\(formattedDistance)")
        service.sendGPS(data: newLocationData) { (statusCompletion: Bool) in
            newLocationData.sendOnServer = statusCompletion
            CoreDataManager.shared.createRideLocationDetails(forLocationData: newLocationData)
        }

    }
}

extension RideStartedViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        for newLocation in locations {
            let howRecent = newLocation.timestamp.timeIntervalSinceNow
            guard abs(howRecent) < pauseTimeOfGPS else { continue }
            
            if let lastLocation = locationList.last {
                let delta = newLocation.distance(from: lastLocation)
                distance = distance + Measurement(value: delta, unit: UnitLength.meters)
                let coordinates = [lastLocation.coordinate, newLocation.coordinate]
                mapView.add(MKPolyline(coordinates: coordinates, count: 2))
                let region = MKCoordinateRegionMakeWithDistance(newLocation.coordinate, 500, 500)
                mapView.setRegion(region, animated: true)
            }
            
            locationList.append(newLocation)
            updateGPSposition(location: newLocation)
        }
    }
}

extension RideStartedViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let polyline = overlay as? MKPolyline else {
            return MKOverlayRenderer(overlay: overlay)
        }
        let renderer = MKPolylineRenderer(polyline: polyline)
        renderer.strokeColor = .tealColor
        renderer.lineWidth = 4
        return renderer
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?{
        if annotation is MKUserLocation {
            //return nil so map view draws "blue dot" for standard user location
            return nil
        }
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
        pinView?.pinTintColor = UIColor.orange
        pinView?.canShowCallout = true
        return pinView
    }
}
