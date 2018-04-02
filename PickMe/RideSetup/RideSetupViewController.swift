//
//  ViewController.swift
//  PickMe
//
//  Created by Ivica Petrsoric on 28/03/2018.
//  Copyright © 2018 Ivica Petrsoric. All rights reserved.
//

import UIKit

class RideSetupViewController: UIViewController {
    
    private var rideSetupView = RideSetupView()
    var userDefaults = RideUserDefaults()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Ride Setup".localized
        
        view.backgroundColor = .darkBlue
        
        print(userDefaults.load(key: RideUserDefaults.UserKey.rideID))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "profile"), style: .plain, target: self, action: #selector(showDriverProfile))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "history"), style: .plain, target: self, action: #selector(showRideHistorList))
        
        rideSetupView.delegate = self
        setupViews()
    }
    
    @objc private func showDriverProfile() {
        let driverProfile = DriverDetailViewController()
        navigationController?.pushViewController(driverProfile, animated: true)
    }
    
    @objc private func showRideHistorList() {
        let rideHistory = RideHistoryViewController()
        navigationController?.pushViewController(rideHistory, animated: true)
    }
    
    private func setupViews() {
        view.addSubview(rideSetupView)
        rideSetupView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    


}
