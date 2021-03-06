//
//  RideHistoryViewController+TableView.swift
//  PickMe
//
//  Created by Ivica Petrsoric on 01/04/2018.
//  Copyright © 2018 Ivica Petrsoric. All rights reserved.
//

import UIKit

extension RideHistoryViewController {
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete".localized) { (_, indexPath) in
            
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
        label.text = "No Ride History!".localized
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return rides.count == 0 ? 150 : 0
    }
    
}
