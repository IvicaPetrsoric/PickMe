//
//  RideHistoryDetailsViewController+MapViewDelegate.swift
//  PickMe
//
//  Created by Ivica Petrsoric on 01/04/2018.
//  Copyright © 2018 Ivica Petrsoric. All rights reserved.
//

import Foundation
import MapKit

extension RideHistoryDetailsViewController: MKMapViewDelegate {
    
    func mapRegion() -> MKCoordinateRegion? {
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
    
    func polyLine() -> MKPolyline {
        guard let locations = ride?.locations else {
            return MKPolyline()
        }
        
        let coords: [CLLocationCoordinate2D] = locations.map { location in
            let location = location as! Location
            
            if location.status == RideStatus.pickedUp.rawValue {
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
