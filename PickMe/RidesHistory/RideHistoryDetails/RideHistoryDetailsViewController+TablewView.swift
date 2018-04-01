//
//  RideHistoryDetailsViewController+TablewView.swift
//  PickMe
//
//  Created by Ivica Petrsoric on 01/04/2018.
//  Copyright © 2018 Ivica Petrsoric. All rights reserved.
//

import UIKit

extension RideHistoryDetailsViewController {
    
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
        return 140
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
}
