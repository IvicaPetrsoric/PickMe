//
//  RideHistoryDetailsCell.swift
//  PickMe
//
//  Created by Ivica Petrsoric on 30/03/2018.
//  Copyright © 2018 Ivica Petrsoric. All rights reserved.
//

import UIKit

class RideHistoryDetailsCell: BaseCell {
    
    private let dateFormat = "HH:mm"
    
    var rideInfo: Ride? {
        didSet{
            var attributedText = NSMutableAttributedString()
            
            if let locStart = rideInfo?.locStart, let locEnd = rideInfo?.locEnd {
                attributedText = NSMutableAttributedString(string: "Start Location: ".localized, attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 18)])
                
                attributedText.append(attributedString(forText: "\(locStart)\n", withBoldFont: false))
                attributedText.append(attributedString(forText: "End Location: ".localized, withBoldFont: true))
                attributedText.append(attributedString(forText: "\(locEnd)\n", withBoldFont: false))
            }
            
            if let passangers = rideInfo?.passangers {
                attributedText.append(attributedString(forText: "Passangers: ".localized, withBoldFont: true))
                attributedText.append(attributedString(forText: "\(passangers)\n", withBoldFont: false))
            }
            
            if let timeStart = rideInfo?.timestamp {
                attributedText.append(attributedString(forText: "Time Start: ".localized, withBoldFont: true))
                attributedText.append(attributedString(forText: FormatDisplay.time(date: timeStart, format: dateFormat) + "\n", withBoldFont: false))
            }
                
            if let location = rideInfo?.locations?.array.last as? Location, let timeEnd = location.timestamp {
                attributedText.append(attributedString(forText: "Time End: ".localized, withBoldFont: true))
                attributedText.append(attributedString(forText: FormatDisplay.time(date: timeEnd, format: dateFormat) + "\n", withBoldFont: false))
                
                if let distance = location.distance {
                    attributedText.append(attributedString(forText: "Distance: ".localized, withBoldFont: true))
                    attributedText.append(attributedString(forText: distance, withBoldFont: false))
                }
            }
            
            infoLabel.attributedText = attributedText
        }
    }
    
    private func attributedString(forText: String, withBoldFont: Bool) -> NSAttributedString{
        if withBoldFont {
            return NSAttributedString(string: forText, attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 18)])
        } else {
            return NSAttributedString(string: forText, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14)])
        }
    }
    
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    override func setupViews() {
        addSubview(infoLabel)

        backgroundColor = .darkBlue

        infoLabel.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 4, paddingBottom: 0, paddingRight: 4, width: 0, height: 0)
    }
    
}
