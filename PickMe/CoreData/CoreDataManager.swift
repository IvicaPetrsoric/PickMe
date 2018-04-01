//
//  CoreDataManager.swift
//  PickMe
//
//  Created by Ivica Petrsoric on 29/03/2018.
//  Copyright © 2018 Ivica Petrsoric. All rights reserved.
//

import CoreData
import UIKit

class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "PickMeModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, err) in
            if let err = err{
                fatalError("Loading of store failed: \(err)")
            }
        })
        return container
    }()
    
    // MARK: Ride
    var currentActiveRide: Ride?
    
    func fetchRides() -> [Ride] {
        let context = persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<Ride>(entityName: "Ride")
        
        do {
            var rides = try context.fetch(fetchRequest)
            
            rides.sort { (p1, p2) -> Bool in
                return p1.timestamp?.compare(p2.timestamp!) == .orderedDescending
            }
            
            return rides
        } catch let fetchErr {
            print("Failed to fetch rides: ", fetchErr)
            return []
        }
    }
    
    func createRide(currentRideDetails: CurrentRideDetails) {
        let context = persistentContainer.viewContext
        
        let newRide = NSEntityDescription.insertNewObject(forEntityName: "Ride", into: context)
        newRide.setValue(Int16(currentRideDetails.bookingId), forKey: "bookingId")
        newRide.setValue(currentRideDetails.passangers, forKey: "passangers")
        newRide.setValue(currentRideDetails.timeStart, forKey: "timestamp")
        newRide.setValue(currentRideDetails.locStart, forKey: "locStart")
        newRide.setValue(currentRideDetails.locEnd, forKey: "locEnd")
        
        do {
            try context.save()
            currentActiveRide = newRide as? Ride
        } catch let err {
            print("Failed to create new ride: ", err)
        }
    }
    
    func createRideLocationDetails(forLocationData data: CurrentRideLocations) {
        let context = persistentContainer.viewContext
        
        let location = NSEntityDescription.insertNewObject(forEntityName: "Location", into: context) as! Location
        location.ride = currentActiveRide
        location.bookingId = Int16(data.bookingId)
        location.latitude = data.latitude
        location.longitude = data.longitude
        location.status = data.status
        location.timestamp = data.timestamp
        location.distance = data.distance
        location.sendOnServer = data.sendOnServer

        do {
            try context.save()
        } catch let err {
            print("Failed to create location of current Ride: ", err)
        }
    }
    
    func updateRideLocationSendOnServer(location: Location) {
        let context = persistentContainer.viewContext

        location.sendOnServer = true
        
        do{
            try  context.save()
        } catch let saveErr {
            print("Failed to update locations changes:", saveErr)
        }
    }
    
    func deleteRide(rideData: Ride){
        let context = persistentContainer.viewContext
        context.delete(rideData)
        
        do {
            try context.save()
            
        } catch let delErr{
            print("Failed to delete Ride from CoreData:", delErr)
        }
    }
    
    // MARK: Driver
    func createDriver(data: DriverData) {
        let context = persistentContainer.viewContext
        
        let newDriver = NSEntityDescription.insertNewObject(forEntityName: "Driver", into: context)
        newDriver.setValue(data.name, forKey: "name")
        newDriver.setValue(data.age, forKey: "age")
        newDriver.setValue(data.registration, forKey: "registration")
        newDriver.setValue(data.image, forKey: "image")
        
        do {
            try context.save()
        } catch let err {
            print("Failed to create new Driver: ", err)
        }
    }
    
    func loadDriver() -> Driver? {
        let context = persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<Driver>(entityName: "Driver")
        
        do {
            let driver = try context.fetch(fetchRequest)
            return driver.first
        } catch let fetchErr {
            print("Failed to fetch rides: ", fetchErr)
            return nil
        }
    }
    
    func updateDriver(data: DriverData, driver: Driver) {
        let context = persistentContainer.viewContext
        
        driver.name = data.name
        driver.age = data.age
        driver.registration = data.registration
        driver.image = data.image
        
        do{
            try  context.save()

        } catch let saveErr {
            print("Failed tosave company changes:", saveErr)
        }
    }
    
    
}
