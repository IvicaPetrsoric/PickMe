//
//  RideHistoryDetailsCell.swift
//  PickMe
//
//  Created by Ivica Petrsoric on 30/03/2018.
//  Copyright © 2018 Ivica Petrsoric. All rights reserved.
//

import UIKit

class RideHistoryDetailsCell: BaseCell {
    
    var rideInfo: Ride? {
        didSet{
            if let locStart = rideInfo?.locStart,
                let locEnd = rideInfo?.locEnd,
                let passangers = rideInfo?.passangers,
                let timeStart = rideInfo?.timestamp,
                let location = rideInfo?.locations?.array.last as? Location,
                let distance = location.distance,
                let timeEnd = location.timestamp {
                    
                    let dateFormater = DateFormatter()
                    dateFormater.dateFormat = "HH:mm"
                    
                    let attributedText = NSMutableAttributedString(string: "Start Location: ", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 16)])
                    attributedText.append(NSAttributedString(string: locStart + "\n", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14)]))
                    
                    
                    attributedText.append(NSAttributedString(string: "End Location: ", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 16)]))
                    attributedText.append(NSAttributedString(string: locEnd + "\n", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14)]))
                    
                    attributedText.append(NSAttributedString(string: "Passangers: ", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 16)]))
                    attributedText.append(NSAttributedString(string: "\(passangers)\n", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14)]))
                    
                    attributedText.append(NSAttributedString(string: "Distance: ", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 16)]))
                    attributedText.append(NSAttributedString(string: distance + "\n", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14)]))

                    attributedText.append(NSAttributedString(string: "Time start: ", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 16)]))
                    attributedText.append(NSAttributedString(string: "\(dateFormater.string(from: timeStart))\n", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14)]))

                    attributedText.append(NSAttributedString(string: "Time end: ", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 16)]))
                    attributedText.append(NSAttributedString(string: "\(dateFormater.string(from: timeEnd))\n", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14)]))
                    
                    infoLabel.attributedText = attributedText
            }
        }
    }
    
    let infoLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    override func setupViews() {
        backgroundColor = .darkBlue
        addSubview(infoLabel)
        infoLabel.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 4, paddingLeft: 4, paddingBottom: 4, paddingRight: 4, width: 0, height: 0)
    }
    
}
