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
    
    lazy var mapView: MKMapView = {
        let map = MKMapView()
        map.delegate = self
        map.showsUserLocation = true
        return map
    }()
    
    private var cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Ride Details".localized
        
        tableView.backgroundColor = .darkBlue
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.register(RideHistoryDetailsCell.self, forCellReuseIdentifier: cellId)
        
        loadMap()
        

    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let locations = ride?.locations, locations.count > 0 else {
            return 0
        }

        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! RideHistoryDetailsCell
        cell.rideInfo = ride
        cell.selectionStyle = .none
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }

    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let locations = ride?.locations, locations.count > 0 else {
            let label = UILabel()
            label.text = "No Ride Locations!".localized
            label.textColor = .white
            label.textAlignment = .center
            label.font = UIFont.boldSystemFont(ofSize: 16)
            return label
        }
        return mapView
    }

    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return view.frame.width
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    enum rideStatus: String {
        case pickedUp
        case rideOn
    }
    
    
    private func loadMap() {
        guard let locations = ride?.locations, locations.count > 0, let region = mapRegion() else {
            let alert = UIAlertController(title: "Error".localized,
                                          message: "This ride has no locations saved".localized,
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK".localized, style: .cancel))
            present(alert, animated: true)
            return
        }
        
        mapView.setRegion(region, animated: true)
        mapView.add(polyLine())
    }
    
    private func mapRegion() -> MKCoordinateRegion? {
        guard let locations = ride?.locations, locations.count > 0 else { return nil }
        
        let latitudes = locations.map { location -> Double in
            let location = location as! Location
            return location.latitude
        }
        
        let longitudes = locations.map { location -> Double in
            let location = location as! Location
            return location.longitude
        }
                
        let maxLat = latitudes.max()!
        let minLat = latitudes.min()!
        let maxLong = longitudes.max()!
        let minLong = longitudes.min()!
        
        let center = CLLocationCoordinate2D(latitude: (minLat + maxLat) / 2, longitude: (minLong + maxLong) / 2)
        let span = MKCoordinateSpan(latitudeDelta: (maxLat - minLat) * 1.5, longitudeDelta: (maxLong - minLong) * 1.5)
        return MKCoordinateRegion(center: center, span: span)
    }
    
    private enum PinAnnotinations: String {
        case passanger = "Passanger"
        case start = "Start"
        case end = "End"
    }
    
    private func polyLine() -> MKPolyline {
        guard let locations = ride?.locations else {
            return MKPolyline()
        }
        
        let coords: [CLLocationCoordinate2D] = locations.map { location in
            let location = location as! Location
            
            if location.status == rideStatus.pickedUp.rawValue {
                dropPinZoomIn(placemark:
                    MKPlacemark(coordinate: CLLocationCoordinate2DMake(location.latitude, location.longitude)),
                              title: "Passanger".localized)
            }
            return CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        }
        
        if coords.count > 0 {
            if let firstCoords = coords.first, let lastCoords = coords.last{
                dropPinZoomIn(placemark: MKPlacemark(coordinate: firstCoords), title: "Start".localized)
                dropPinZoomIn(placemark: MKPlacemark(coordinate: lastCoords), title: "End".localized)
            }
        }
        
        return MKPolyline(coordinates: coords, count: coords.count)
    }
    
    private func dropPinZoomIn(placemark: MKPlacemark, title: String){
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = title
        mapView.addAnnotation(annotation)
    }
    
}

extension RideHistoryDetailsViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let polyline = overlay as? MKPolyline else {
            return MKOverlayRenderer(overlay: overlay)
        }
        let renderer = MKPolylineRenderer(polyline: polyline)
        renderer.strokeColor = .tealColor
        renderer.lineWidth = 3
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
