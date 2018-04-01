//
//  Server.swift
//  PickMe
//
//  Created by Ivica Petrsoric on 29/03/2018.
//  Copyright © 2018 Ivica Petrsoric. All rights reserved.
//

import Foundation

class Server {
    
    private let baseUrl = "https://test.mother.i-ways.hr/?json=1"
    
    func sendWorlflowAction(data: CurrentRideLocations) {
        var dateToSend = "bookingId=" + "\(data.bookingId)"
        dateToSend += "&status=" + "\(data.status)"
        dateToSend += "&time=" + "\(data.timestamp)"
        dateToSend += "&lat=" + "\(data.latitude)"
        dateToSend += "&lng=" + "\(data.longitude)"
        
        executeToServer(postString: dateToSend) { (_) in
        }
    }
    
    func sendGPS(data: CurrentRideLocations, completion: @escaping (Bool) -> ()) {
        var dateToSend = "bookingId=" + "\(data.bookingId)"
        dateToSend += "&time=" + "\(data.timestamp)"
        dateToSend += "&lat=" + "\(data.latitude)"
        dateToSend += "&lng=" + "\(data.longitude)"
        
        executeToServer(postString: dateToSend, completion: completion)
    }
    
    private func executeToServer(postString: String, completion: @escaping (Bool) -> ()){
        guard let url = URL(string: baseUrl) else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = postString.data(using: .utf8)
        request.timeoutInterval = 10
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Network error: ", error)
                
                DispatchQueue.main.async(execute: {
                    completion(false)
                })
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse {
                print("Server response: \(httpStatus.statusCode)")
            }
            
            DispatchQueue.main.async(execute: {
                completion(true)
            })
        }
        task.resume()
    }
    
}
