//
//  CoreDataManager.swift
//  PickMe
//
//  Created by Ivica Petrsoric on 29/03/2018.
//  Copyright © 2018 Ivica Petrsoric. All rights reserved.
//

import CoreData

class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    let persistantContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "PickMeModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, err) in
            if let err = err{
                fatalError("Loading of store failed: \(err)")
            }
        })
        return container
    }()
    
    /*
     private func saveRun() {
     let newRun = Run(context: CoreDataStack.context)
     newRun.distance = distance.value
     newRun.duration = Int16(seconds)
     newRun.timestamp = Date()
     
     for location in locationList {
     let locationObject = Location(context: CoreDataStack.context)
     locationObject.timestamp = location.timestamp
     locationObject.latitude = location.coordinate.latitude
     locationObject.longitude = location.coordinate.longitude
     newRun.addToLocations(locationObject)
     }
     
     CoreDataStack.saveContext()
     
     run = newRun
     }
     */
    
    var currentActiveRide: Ride?
    
    func fetchRides() -> [Ride] {
        let context = persistantContainer.viewContext
        
        let fetchRequest = NSFetchRequest<Ride>(entityName: "Ride")
        
        do {
            let rides = try context.fetch(fetchRequest)
            return rides
        } catch let fetchErr {
            print("Failed to fetch rides: ", fetchErr)
            return []
        }
    }
    
    func createRide(currentRideDetails: CurrentRideDetails) {
        let context = persistantContainer.viewContext
        
        let newRide = NSEntityDescription.insertNewObject(forEntityName: "Ride", into: context)
        newRide.setValue(currentRideDetails.id, forKey: "id")
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
        let context = persistantContainer.viewContext
        
        let location = NSEntityDescription.insertNewObject(forEntityName: "Location", into: context) as! Location
        location.ride = currentActiveRide
        location.latitude = data.latitude
        location.longitude = data.longitude
        location.status = data.status
        location.timestamp = data.timestamp
        
        print(location.longitude)
        print(data.longitude)
        do {
            try context.save()
        } catch let err {
            print("Failed to create location of current Ride: ", err)
        }
    }
    
    func deleteDB() {
        let context = CoreDataManager.shared.persistantContainer.viewContext
        
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: Ride.fetchRequest())
        
        do{
            try context.execute(batchDeleteRequest)
            
            // upon deletion from core data succeded
            //            var indexPathsToRemove = [IndexPath]()
            //
            //            for (index, _) in companies.enumerated(){
            //                let indexPath = IndexPath(row: index, section: 0)
            //                indexPathsToRemove.append(indexPath)
            //            }
            
            //            companies.removeAll()
            //            tableView.deleteRows(at: indexPathsToRemove, with: .left)
            
        }catch let delErr {
            print("failed to delete objects from Core Data:", delErr)
        }
    }
    
//    func createEmployee(employeeName: String, employeeType: String, birthday: Date) {
//        let context = persistantContainer.viewContext
    
        
        
//        // create employee
//        let employee = NSEntityDescription.insertNewObject(forEntityName: "Employee", into: context) as! Employee
//        employee.setValue(employeeName, forKey: "fullName")
//
//        employee.company = company
//        employee.type = employeeType
//
//        // lets check company is setup correctly
//        //        let company = Company(context: context)
//        //        company.employees // type: NSSet, many employees!!
//        //        employee.company // type: Company, ONE!!!
//
//        // relationships inserts data
//        let employeeInformation = NSEntityDescription.insertNewObject(forEntityName: "EmployeeInformation", into: context) as! EmployeeInformation
//
//        // safer
//        employeeInformation.taxId = "456"
//        employeeInformation.birthday = birthday
//        // with key
//        //        employeeInformation.setValue("456", forKey: "taxId")
//
//        employee.employeeInformation = employeeInformation
//
//        do{
//            try context.save()
//            return (employee, nil)
//        } catch let err{
//            print("Failed to create employee",err)
//            return (nil, err)
//        }
//    }
    
//    class func saveContext () {
//        let context = persistantContainer.viewContext
//
//        guard context.hasChanges else {
//            return
//        }
//
//        do {
//            try context.save()
//        } catch {
//            let nserror = error as NSError
//            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
//        }
//    }
    
}
