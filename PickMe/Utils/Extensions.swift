//
//  Extensions.swift
//  PickMe
//
//  Created by Ivica Petrsoric on 28/03/2018.
//  Copyright © 2018 Ivica Petrsoric. All rights reserved.
//

import UIKit

extension UIColor{
    
    static let tealColor = UIColor(red: 48/255, green: 164/255, blue: 182/255, alpha: 1)
    static let lightRed = UIColor(red: 247/255, green: 66/255, blue: 82/255, alpha: 1)
    static let darkBlue = UIColor(red: 9/255, green: 45/255, blue: 64/255, alpha: 1)
    static let lightBlue = UIColor(red: 218/255, green: 235/255, blue: 243/255, alpha: 1)
    static let midBlue = UIColor(red: 100/255, green: 170/255, blue: 245/255, alpha: 1)
    static let lightGreen = UIColor(red: 150/255, green: 240/255, blue: 120/255, alpha: 1)
    static let lightOrange = UIColor(red: 230/255, green: 148/255, blue: 30/255, alpha: 1)

    
}

extension UIView{
    
    func anchor(top: NSLayoutYAxisAnchor?, left: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, right: NSLayoutXAxisAnchor?, paddingTop: CGFloat, paddingLeft: CGFloat, paddingBottom: CGFloat, paddingRight: CGFloat, width: CGFloat, height: CGFloat){
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top{
            self.topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        
        if let left = left{
            leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        
        if let bottom = bottom{
            bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }
        
        if let right = right{
            rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        
        if width != 0{
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if height != 0{
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
}

extension UIViewController{
    
    enum alertMessage: String{
        case errorWebConnection = "Check your Web connection!"
        case errorWebAndURL = "Ooops, check your Web connection and Feed URL!"
        case errorFeedExsist = "You already have this Feed!"
        case errorWithParsing = "Couldn't read that Feed, check again if URL was correct!"
    }
    
    func showAllert(message: String){
        let alert = UIAlertController(title: "Notice", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
}
