//
//  RideHistoryCell.swift
//  PickMe
//
//  Created by Ivica Petrsoric on 30/03/2018.
//  Copyright © 2018 Ivica Petrsoric. All rights reserved.
//

import UIKit

class RideHistoryCell: BaseCell {
    
    var ride: Ride? {
        didSet{
            if let locStart = ride?.locStart, let locEnd = ride?.locEnd {
                let attributedText = NSMutableAttributedString(string: "Start Location: ", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14)])
                attributedText.append(NSAttributedString(string: locStart + "\n", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14)]))
                attributedText.append(NSAttributedString(string: "End Location: ", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14)]))
                attributedText.append(NSAttributedString(string: locEnd, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14)]))
                
                locationLabel.attributedText = attributedText
            }
            
            if let totalPassangers = ride?.passangers {
                passangersLabel.text = "Passangers: \(totalPassangers)"
            }
            
            if let timestamps = ride?.timestamp {
                let dateFormater = DateFormatter()
                dateFormater.dateFormat = "MM.dd.yyyy"
                timestampLabel.text = "\(dateFormater.string(from: timestamps))"
            }
        }
    }
    
    let backView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        view.backgroundColor = .lightBlue
        return view
    }()
    
    let locationLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    let passangersLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .left
        return label
    }()
    
    let timestampLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .right
        return label
    }()
    
    override func setupViews() {
        addSubview(backView)
        addSubview(locationLabel)
        addSubview(passangersLabel)
        addSubview(timestampLabel)
        
        backgroundColor = .clear
        
        backView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: 8, paddingRight: 8, width: 0, height: 0)
        
        locationLabel.anchor(top: backView.topAnchor, left: backView.leftAnchor, bottom: backView.bottomAnchor, right: backView.rightAnchor, paddingTop: 10, paddingLeft: 4, paddingBottom: 20, paddingRight: 4, width: 0, height: 0)
        
        passangersLabel.anchor(top: nil, left: backView.leftAnchor, bottom: backView.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 4, paddingBottom: 4, paddingRight: 0, width: frame.width * 0.4, height: 16)
        
        timestampLabel.anchor(top: nil, left: nil, bottom: backView.bottomAnchor, right: backView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 4, paddingRight: 4, width: frame.width * 0.5, height: 16)
    }
}
