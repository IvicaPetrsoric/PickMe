//
//  RideSetupView.swift
//  PickMe
//
//  Created by Ivica Petrsoric on 02/04/2018.
//  Copyright © 2018 Ivica Petrsoric. All rights reserved.
//

import UIKit

protocol RideSetupViewDelegate: class {
    func prepareForRide(startLoc: String, endLoc: String, passangers: String)
}

class RideSetupView: BaseView {
    
    weak var delegate: RideSetupViewController?

    private let locationStartField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Start Location".localized
        textField.backgroundColor = .lightBlue
        textField.borderStyle = .roundedRect
        textField.textAlignment = .center
        textField.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        textField.layer.cornerRadius = 8
        textField.layer.masksToBounds = true
        return textField
    }()
    
    private let locationEndField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter End Location".localized
        textField.backgroundColor = .lightBlue
        textField.borderStyle = .roundedRect
        textField.textAlignment = .center
        textField.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        textField.layer.cornerRadius = 8
        textField.layer.masksToBounds = true
        return textField
    }()
    
    private let passangersField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Total Passangers".localized
        textField.backgroundColor = .lightBlue
        textField.borderStyle = .roundedRect
        textField.textAlignment = .center
        textField.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        textField.layer.cornerRadius = 8
        textField.layer.masksToBounds = true
        textField.keyboardType = UIKeyboardType.numberPad
        return textField
    }()
    
    private let startRideButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Start Ride".localized, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 30)
        button.backgroundColor = .lightGreen
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(handleEndSetup), for: .touchUpInside)
        return button
    }()
    
    @objc private func handleTextInputChange(sender: UITextField) {
        switch sender {
        case locationStartField:
            if locationEndField.alpha == 0 {
                animateView(animateTextField: locationEndField)
            }
            
        case locationEndField:
            if passangersField.alpha == 0 {
                animateView(animateTextField: passangersField)
            }
            
        case passangersField:
            if startRideButton.alpha == 0 {
                UIView.animate(withDuration: 0.5) {
                    self.startRideButton.alpha = 1
                }
            }
            
        default:
            break
        }
    }
    
    private func animateView(animateTextField: UITextField) {
        UIView.animate(withDuration: 0.5) {
            animateTextField.alpha = 1
        }
    }
    
    @objc private func handleEndSetup() {
        removeKeyboard()
        
        guard let startLocation = locationStartField.text, let endLocation = locationEndField.text, let totalPassanger = passangersField.text else { return }
        
        if let delegate = delegate {
            delegate.prepareForRide(startLoc: startLocation, endLoc: endLocation, passangers: totalPassanger)
        }
    }
    
    @objc private func removeKeyboard() {
        endEditing(true)
    }
    
    override func setupViews() {
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(removeKeyboard)))
        
        let stackViewLabels = UIStackView(arrangedSubviews: [locationStartField, locationEndField, passangersField])
        stackViewLabels.axis = .vertical
        stackViewLabels.distribution = .fillEqually
        stackViewLabels.spacing = 8
        
        addSubview(stackViewLabels)
        addSubview(startRideButton)
        
        locationEndField.alpha = 0
        passangersField.alpha = 0
        startRideButton.alpha = 0
        
        stackViewLabels.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 0, height: 150)
        
        startRideButton.anchor(top: stackViewLabels.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 24, paddingLeft: 44, paddingBottom: 0, paddingRight: 44, width: 0, height: 52)
    }

}
