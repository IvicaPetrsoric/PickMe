//
//  CustomNavigationController.swift
//  PickMe
//
//  Created by Ivica Petrsoric on 01/04/2018.
//  Copyright © 2018 Ivica Petrsoric. All rights reserved.
//

import UIKit

class CustomNavigationController: UINavigationController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
}

extension UINavigationController{
    open override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
}
