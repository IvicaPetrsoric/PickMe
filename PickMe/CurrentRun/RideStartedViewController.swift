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
//        map.delegate = self
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
        button.setTitle("Passanger picked up", for: .normal)
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
        button.setTitle("Stop over", for: .normal)
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
        button.setTitle("End ride", for: .normal)
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
        button.setTitle("Continue ride", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.backgroundColor = .lightGreen
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(handleContineRide), for: .touchUpInside)
        return button
    }()
    
    @objc private func handlepassangerPicked() {
        navigationItem.title = "Status: New Passanger"

        UIView.animate(withDuration: 0.3) {
            self.balackBackgroundMask.alpha = 0.7
            self.passangerPickedButton.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
            self.stopOverButton.transform = CGAffineTransform.identity
            self.endRidePickedButton.transform = CGAffineTransform.identity
        }
    }
    
    @objc private func handleStopOver() {
        navigationItem.title = "Status: Stop Over"

        UIView.animate(withDuration: 0.3) {
            self.stopOverButton.transform = CGAffineTransform(translationX: -self.view.frame.width / 2, y: 0)
            self.endRidePickedButton.transform = CGAffineTransform(translationX: self.view.frame.width / 2, y: 0)
            self.continueRideButton.transform = CGAffineTransform.identity
        }
    }
    
    @objc private func handleContineRide() {
        navigationItem.title = "Status: Driving"

        UIView.animate(withDuration: 0.3) {
            self.balackBackgroundMask.alpha = 0
            self.continueRideButton.transform = CGAffineTransform(translationX: 0, y: self.view.frame.width / 5)
            self.passangerPickedButton.transform = CGAffineTransform.identity
        }
    }
    
    @objc private func handleEndRide() {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .darkBlue
        navigationItem.title = "Status: Driving"
        
        setupViews()
    }
    
    private func setupViews() {
        view.addSubview(mapView)
        view.addSubview(balackBackgroundMask)

        view.addSubview(passangerPickedButton)
        view.addSubview(stopOverButton)
        view.addSubview(endRidePickedButton)
        view.addSubview(continueRideButton)
        
        balackBackgroundMask.alpha = 0
        
        stopOverButton.transform = CGAffineTransform(translationX: -view.frame.width / 2, y: 0)
        endRidePickedButton.transform = CGAffineTransform(translationX: view.frame.width / 2, y: 0)
        continueRideButton.transform = CGAffineTransform(translationX: 0, y: view.frame.width / 5)

        mapView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        balackBackgroundMask.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        passangerPickedButton.anchor(top: nil, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 8, paddingRight: 8, width: 0, height: 44)
        
        stopOverButton.anchor(top: nil, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 8, paddingBottom: 8, paddingRight: 0, width: view.frame.width / 2 - 16, height: 44)
        
        endRidePickedButton.anchor(top: nil, left: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 8, paddingRight: 8, width: view.frame.width / 2 - 16, height: 44)
        
        continueRideButton.anchor(top: nil, left: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 8, paddingRight: 0, width: view.frame.width / 2 - 16, height: 44)
        continueRideButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true        
    }
    
}
