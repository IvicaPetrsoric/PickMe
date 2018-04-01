//
//  RideHistoryViewController.swift
//  PickMe
//
//  Created by Ivica Petrsoric on 30/03/2018.
//  Copyright © 2018 Ivica Petrsoric. All rights reserved.
//

import UIKit

class RideHistoryViewController: UITableViewController {
    
    private var rides = [Ride]()
    
    private var cellId = "cellId"
    
    private var service = Server()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .darkBlue
        
        navigationItem.title = "History"
        
        tableView.backgroundColor = .darkBlue
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.register(RideHistoryCell.self, forCellReuseIdentifier: cellId)
        
        rides = CoreDataManager.shared.fetchRides()
        
        checkGPSDataSendedToServer()
    }
    
    func checkGPSDataSendedToServer(){
        for ride in rides {
            for rideLocations in ride.locations! {
                let locationData = rideLocations as! Location
                
                if !locationData.sendOnServer {
                    guard let timestamp = locationData.timestamp, let distance = locationData.distance else { return}
                    
                    let newLocationData = CurrentRideLocations(bookingId: Int(locationData.bookingId),
                                                               status: "",
                                                               sendOnServer: false,
                                                               latitude: locationData.latitude,
                                                               longitude: locationData.longitude,
                                                               timestamp: timestamp,
                                                               distance: distance)
                    
                    service.sendGPS(data: newLocationData) { (statusCompletion: Bool) in
                        if statusCompletion {
                            CoreDataManager.shared.updateRideLocationSendOnServer(location: locationData)
                        }
                    }
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (_, indexPath) in           

            CoreDataManager.shared.deleteRide(rideData: self.rides[indexPath.row])
            
            self.rides.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .left)
            
            if self.rides.count == 0{
                self.tableView.reloadData()
            }
        }
        
        deleteAction.backgroundColor = .lightRed
        
        return [deleteAction]
    }
        
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rides.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! RideHistoryCell
        cell.ride = rides[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let newVC = RideHistoryDetailsViewController()
        newVC.ride = rides[indexPath.row]
        
        navigationController?.pushViewController(newVC, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "No Ride History!"
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return rides.count == 0 ? 150 : 0
    }
    
}
