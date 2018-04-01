//
//  DriverDetailViewController.swift
//  PickMe
//
//  Created by Ivica Petrsoric on 30/03/2018.
//  Copyright © 2018 Ivica Petrsoric. All rights reserved.
//

import UIKit

class DriverDetailViewController: UIViewController {
    
    let plusPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "plusImage"), for: .normal)
        button.tintColor = .lightBlue
        button.addTarget(self, action: #selector(handlePlusPhoto), for: .touchUpInside)
        button.imageView?.contentMode = .scaleAspectFill
        return button
    }()
    
    @objc func handlePlusPhoto(){
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion: nil)
    }
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name:".localized
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.textColor = .lightBlue
        return label
    }()
    
    let driverNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter name".localized
        textField.backgroundColor = .lightBlue
        textField.borderStyle = .roundedRect
        textField.textAlignment = .center
        textField.layer.cornerRadius = 8
        textField.layer.masksToBounds = true
        return textField
    }()
    
    let ageLabel: UILabel = {
        let label = UILabel()
        label.text = "Age:".localized
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.textColor = .lightBlue
        return label
    }()
    
    let driverAgeTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter age".localized
        textField.backgroundColor = .lightBlue
        textField.borderStyle = .roundedRect
        textField.textAlignment = .center
        textField.layer.cornerRadius = 8
        textField.layer.masksToBounds = true
        textField.keyboardType = UIKeyboardType.numberPad
        return textField
    }()
    
    let carRegLabel: UILabel = {
        let label = UILabel()
        label.text = "Car registration:".localized
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.textColor = .lightBlue
        return label
    }()
    
    let driverCarRegTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter car registration".localized
        textField.backgroundColor = .lightBlue
        textField.borderStyle = .roundedRect
        textField.textAlignment = .center
        textField.layer.cornerRadius = 8
        textField.layer.masksToBounds = true
        return textField
    }()
    
    private var driver: Driver?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .darkBlue
        navigationItem.title = "Driver Profile".localized
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(removeKeyboard)))
        
        fetchDriverData()
        setupViews()
        roundCornerPickImage()
    }
        
    @objc private func removeKeyboard() {
        view.endEditing(true)
    }
    
    private func fetchDriverData() {
        driver = CoreDataManager.shared.loadDriver()
        guard let name = driver?.name else { return }
        guard let age = driver?.age else { return }
        guard let registration = driver?.registration else { return }
        
        driverNameTextField.text = name
        driverAgeTextField.text = age
        driverCarRegTextField.text = registration
        
        guard let image = driver?.image else { return }
        
        plusPhotoButton.setImage(UIImage(data: image)?.withRenderingMode(.alwaysOriginal), for: .normal)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        guard let name = driverNameTextField.text else { return }
        guard let age = driverAgeTextField.text else { return }
        guard let registration = driverCarRegTextField.text else { return }
        
        guard let image = plusPhotoButton.imageView?.image else { return }
        guard let uploadData = UIImagePNGRepresentation(image) else { return }
        
        let dataToSave = DriverData(name: name, age: age, registration: registration, image: uploadData)

        if let driver = driver {
            CoreDataManager.shared.updateDriver(data: dataToSave, driver: driver)
        } else {
            CoreDataManager.shared.createDriver(data: dataToSave)
        }
    }
    
    private func setupViews() {
        let stackViewLabels = UIStackView(arrangedSubviews: [nameLabel, ageLabel, carRegLabel])
        stackViewLabels.axis = .vertical
        stackViewLabels.distribution = .fillEqually
        stackViewLabels.spacing = 8
        
        let stackViewTextFields = UIStackView(arrangedSubviews: [driverNameTextField, driverAgeTextField, driverCarRegTextField])
        stackViewTextFields.axis = .vertical
        stackViewTextFields.distribution = .fillEqually
        stackViewTextFields.spacing = 8
        
        view.addSubview(stackViewLabels)
        view.addSubview(plusPhotoButton)
        view.addSubview(stackViewTextFields)
    
        plusPhotoButton.anchor(top: view.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 70, height: 70)
        plusPhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        stackViewLabels.anchor(top: plusPhotoButton.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 4, paddingBottom: 0, paddingRight: 0, width: 120, height: 150)
        
        stackViewTextFields.anchor(top: stackViewLabels.topAnchor, left: stackViewLabels.rightAnchor, bottom: stackViewLabels.bottomAnchor, right: view.rightAnchor, paddingTop: 8, paddingLeft: 4, paddingBottom: 0, paddingRight: 4, width: 0, height: 0)
    }
    
    private func roundCornerPickImage() {
        plusPhotoButton.layer.cornerRadius = 35
        plusPhotoButton.layer.masksToBounds = true
        plusPhotoButton.layer.borderColor = UIColor.lightBlue.cgColor
        plusPhotoButton.layer.borderWidth = 3
    }
    
}

extension DriverDetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            plusPhotoButton.setImage(editedImage.withRenderingMode(.alwaysOriginal), for: .normal)
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage{
            plusPhotoButton.setImage(originalImage.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        
        roundCornerPickImage()
        dismiss(animated: true, completion: nil)
    }
}
