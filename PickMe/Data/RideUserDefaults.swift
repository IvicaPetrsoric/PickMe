//
//  UserDefaults.swift
//  PickMe
//
//  Created by Ivica Petrsoric on 02/04/2018.
//  Copyright © 2018 Ivica Petrsoric. All rights reserved.
//

import Foundation

class RideUserDefaults: NSObject {
    
    enum UserKey: String {
        case rideID
    }
    
    func save(value: Int, key: UserKey) {
        let preferences = UserDefaults.standard
        preferences.set(value, forKey: key.rawValue)
        
        let didSave = preferences.synchronize()
        
        if !didSave {
            print("Error with saveing in userDefaults by key: ", key)
        }
    }
    
    func load(key: UserKey) -> Int {
        let preferences = UserDefaults.standard

        if preferences.object(forKey: key.rawValue) != nil{
            return preferences.value(forKey: key.rawValue) as! Int
        } else {
            save(value: 1, key: key)
            print("Data is empty by key: ", key)
            return 1
        }
    }
    
}
