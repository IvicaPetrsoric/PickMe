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
                    
                    let attributedText = NSMutableAttributedString(string: "Start Location: ".localized, attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 16)])
//                    attributedText.append(NSAttributedString(string: locStart + "\n", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14)]))
                
                attributedText.append(createAttributedString(forText: locStart + "\n", withBoldFont: false))
                
                attributedText.append(createAttributedString(forText: "End Location: ".localized, withBoldFont: true))
                attributedText.append(createAttributedString(forText: locEnd + "\n", withBoldFont: false))
                
                attributedText.append(createAttributedString(forText: "Passangers: ".localized, withBoldFont: true))
                attributedText.append(createAttributedString(forText: "\(passangers)\n", withBoldFont: false))
                
                attributedText.append(createAttributedString(forText: "Distance: ".localized, withBoldFont: true))
                attributedText.append(createAttributedString(forText: distance + "\n", withBoldFont: false))
                
                attributedText.append(createAttributedString(forText: "Time Start: ".localized, withBoldFont: true))
                attributedText.append(createAttributedString(forText: "\(dateFormater.string(from: timeStart))\n", withBoldFont: false))

                attributedText.append(createAttributedString(forText: "Time End: ".localized, withBoldFont: true))
                attributedText.append(createAttributedString(forText: "\(dateFormater.string(from: timeEnd))", withBoldFont: false))

                
                    
//                    attributedText.append(NSAttributedString(string: "End Location: ".localized, attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 16)]))
//                    attributedText.append(NSAttributedString(string: locEnd + "\n", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14)]))
//
//                    attributedText.append(NSAttributedString(string: "Passangers: ".localized, attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 16)]))
//                    attributedText.append(NSAttributedString(string: "\(passangers)\n", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14)]))
//
//                    attributedText.append(NSAttributedString(string: "Distance: ".localized, attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 16)]))
//                    attributedText.append(NSAttributedString(string: distance + "\n", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14)]))
//
//                    attributedText.append(NSAttributedString(string: "Time Start: ".localized, attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 16)]))
//                    attributedText.append(NSAttributedString(string: "\(dateFormater.string(from: timeStart))\n", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14)]))
//
//                    attributedText.append(NSAttributedString(string: "Time End: ".localized, attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 16)]))
//                    attributedText.append(NSAttributedString(string: "\(dateFormater.string(from: timeEnd))\n", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14)]))
                
                    infoLabel.attributedText = attributedText
            }
        }
    }
    
    private func createAttributedString(forText: String, withBoldFont: Bool) -> NSAttributedString{
        if withBoldFont {
            return NSAttributedString(string: forText, attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 18)])
        } else {
            return NSAttributedString(string: forText, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14)])
        }
    }
    
    let infoLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .white
        label.backgroundColor = .red
        label.numberOfLines = 0
        return label
    }()
    
    override func setupViews() {
        backgroundColor = .darkBlue
        addSubview(infoLabel)
        infoLabel.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 4, paddingLeft: 4, paddingBottom: 4, paddingRight: 4, width: 0, height: 0)
    }
    
}
