//
//  ViewController.swift
//  PickMe
//
//  Created by Ivica Petrsoric on 28/03/2018.
//  Copyright © 2018 Ivica Petrsoric. All rights reserved.
//

import UIKit

class RideSetupViewController: UIViewController {
    
    enum placeholderTextFields: String {
        case start = "Enter start location"
        case end = "Enter end location"
        case passangers = "Enter total passangers:"
    }
    
    enum startTextOfTextFields: String {
        case start = "Start location "
        case end = "End location "
        case passangers = "Passangers: "
    }
    
    let locationStartField: UITextField = {
        let textField = UITextField()
        textField.placeholder = placeholderTextFields.start.rawValue
        textField.backgroundColor = UIColor.lightBlue
        textField.borderStyle = .roundedRect
        textField.textAlignment = .center
        textField.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        textField.layer.cornerRadius = 8
        textField.layer.masksToBounds = true
        return textField
    }()
    
    let locationEndField: UITextField = {
        let textField = UITextField()
        textField.placeholder = placeholderTextFields.end.rawValue
        textField.backgroundColor = UIColor.lightBlue
        textField.borderStyle = .roundedRect
        textField.textAlignment = .center
        textField.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        textField.layer.cornerRadius = 8
        textField.layer.masksToBounds = true
        return textField
    }()
    
    let passangersField: UITextField = {
        let textField = UITextField()
        textField.placeholder = placeholderTextFields.passangers.rawValue
        textField.backgroundColor = UIColor.lightBlue
        textField.borderStyle = .roundedRect
        textField.textAlignment = .center
        textField.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        textField.layer.cornerRadius = 8
        textField.layer.masksToBounds = true
        textField.keyboardType = UIKeyboardType.decimalPad
        return textField
    }()
    
    let startRideButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Start Ride", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 32)
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
            
        default:
            break
        }
        
        if validateEnteredData() {
            UIView.animate(withDuration: 0.5) {
                self.startRideButton.alpha = 1
            }
        }
    }
    
    private func animateView(animateTextField: UITextField) {
        UIView.animate(withDuration: 0.5) {
            animateTextField.alpha = 1
        }
    }
    
    private func validateEnteredData() -> Bool{
        guard let startLocation = locationStartField.text, startLocation != " " && startLocation.count > 0 else { return false}
        guard let endLocation = locationEndField.text, endLocation != " " && endLocation.count > 0 else { return false}
        guard let totalPassanger = passangersField.text, totalPassanger != " " && totalPassanger.count > 0 else { return false}
        
        return true
    }
    
    @objc private func handleEndSetup() {
        if validateEnteredData() {
            view.endEditing(true)
            
            let rideStartedViewController = UINavigationController(rootViewController: RideStartedViewController())
            present(rideStartedViewController, animated: true, completion: nil)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Setup"
        
        view.backgroundColor = .darkBlue
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(removeKeyboard)))
        
        setupViews()
    }
    
    @objc private func removeKeyboard() {
        view.endEditing(true)
    }
    
    private func setupViews() {
        view.addSubview(locationStartField)
        view.addSubview(locationEndField)
        view.addSubview(passangersField)
        view.addSubview(startRideButton)
        
        locationEndField.alpha = 0
        passangersField.alpha = 0
        startRideButton.alpha = 0
        
        locationStartField.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 16, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 0, height: 44)
        
        locationEndField.anchor(top: locationStartField.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 0, height: 44)
        
        passangersField.anchor(top: locationEndField.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 0, height: 44)
        
        startRideButton.anchor(top: passangersField.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 48, paddingLeft: 44, paddingBottom: 0, paddingRight: 44, width: 0, height: 64)
    }

}
