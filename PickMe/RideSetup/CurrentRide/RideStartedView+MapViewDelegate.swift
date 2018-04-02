//
//  RideStartedView+MapViewDelegate.swift
//  PickMe
//
//  Created by Ivica Petrsoric on 02/04/2018.
//  Copyright © 2018 Ivica Petrsoric. All rights reserved.
//

import MapKit

extension RideStartedView: MKMapViewDelegate {
    
    func addPolylineToMap(line: MKPolyline) {
        mapView.add(line)
    }
    
    func addRegionToMap(region: MKCoordinateRegion) {
        mapView.setRegion(region, animated: true)
    }
    
    func addAnnotation(annotation: MKPointAnnotation) {
        mapView.addAnnotation(annotation)
    }
   
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
