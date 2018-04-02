//
//  RideStartedView.swift
//  PickMe
//
//  Created by Ivica Petrsoric on 02/04/2018.
//  Copyright © 2018 Ivica Petrsoric. All rights reserved.
//

import UIKit
import MapKit

protocol RideStartedViewDelegate: class {
    func ridePassangerPicked()
    func rideStopOver()
    func rideContinue()
    func rideEnd()
}

class RideStartedView: BaseView {
    
    weak var delegate: RideStartedViewDelegate?
    
    lazy var mapView: MKMapView = {
        let map = MKMapView()
        map.delegate = self
        map.showsUserLocation = true
        return map
    }()
    
    private let balackBackgroundMask: UIView = {
        let view = UIView()
        view.backgroundColor = .darkBlue
        return view
    }()
    
    private let passangerPickedButton: UIButton = {
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
    
    private let stopOverButton: UIButton = {
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
    
    private let endRidePickedButton: UIButton = {
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
    
    private let continueRideButton: UIButton = {
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
    
    private let detailsLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    @objc private func handlepassangerPicked() {
        if let delegate = delegate {
            delegate.ridePassangerPicked()
        }
        
        UIView.animate(withDuration: 0.3) {
            self.balackBackgroundMask.alpha = 0.7
            self.passangerPickedButton.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
            self.stopOverButton.transform = CGAffineTransform.identity
            self.endRidePickedButton.transform = CGAffineTransform.identity
        }
    }
    
    @objc private func handleStopOver() {
        if let delegate = delegate {
            delegate.rideStopOver()
        }
        
        UIView.animate(withDuration: 0.3) {
            self.stopOverButton.transform = CGAffineTransform(translationX: -self.frameWidth / 2, y: 0)
            self.endRidePickedButton.transform = CGAffineTransform(translationX: self.frameWidth / 2, y: 0)
            self.continueRideButton.transform = CGAffineTransform.identity
        }
    }
    
    @objc private func handleContineRide() {
        if let delegate = delegate {
            delegate.rideContinue()
        }
        
        UIView.animate(withDuration: 0.3) {
            self.balackBackgroundMask.alpha = 0
            self.continueRideButton.transform = CGAffineTransform(translationX: 0, y: self.frameWidth / 5)
            self.passangerPickedButton.transform = CGAffineTransform.identity
        }
    }
    
    @objc private func handleEndRide() {
        if let delegate = delegate {
            delegate.rideEnd()
        }
    }
    
    var frameWidth: CGFloat = 0
    
    func showView() {
        addSubview(mapView)
        addSubview(balackBackgroundMask)
        addSubview(passangerPickedButton)
        addSubview(stopOverButton)
        addSubview(endRidePickedButton)
        addSubview(continueRideButton)
                
        mapView.removeOverlays(mapView.overlays)
        balackBackgroundMask.alpha = 0
        
        stopOverButton.transform = CGAffineTransform(translationX: -frameWidth / 2, y: 0)
        endRidePickedButton.transform = CGAffineTransform(translationX: frameWidth / 2, y: 0)
        continueRideButton.transform = CGAffineTransform(translationX: 0, y: frameWidth / 4)
        
        mapView.anchor(top: topAnchor, left: leftAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        balackBackgroundMask.anchor(top: topAnchor, left: leftAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        passangerPickedButton.anchor(top: nil, left: leftAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 8, paddingRight: 8, width: 0, height: 44)
        
        stopOverButton.anchor(top: nil, left: leftAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 8, paddingBottom: 8, paddingRight: 0, width: frameWidth / 2 - 16, height: 44)
        
        endRidePickedButton.anchor(top: nil, left: nil, bottom: safeAreaLayoutGuide.bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 8, paddingRight: 8, width: frameWidth / 2 - 16, height: 44)
        
        continueRideButton.anchor(top: nil, left: nil, bottom: safeAreaLayoutGuide.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 8, paddingRight: 0, width: frameWidth * 0.75, height: 44)
        continueRideButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
}
