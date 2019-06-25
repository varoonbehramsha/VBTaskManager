//
//  VBNetworkManager.swift
//  VBTaskManager
//
//  Created by Varoon Behramsha on 15/06/19.
//  Copyright © 2019 Varoon Behramsha. All rights reserved.
//

import Foundation

class NetworkManager
{
    static let shared = NetworkManager()
  
    private init ()
    {
        
    }
    
    /// Fetches tasks from a google sheet with the help of Sheetson API
    ///
    /// - Parameter completionHandler: (error, tasks))
     func getTasks(completionHandler: @escaping (_ error:Error?,_ tasks:[VBTaskDTO])->())
    {
       
        guard let url = URL(string: "https://api.sheetson.com/v1/sheets/Tasks") else { return  }
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("17m2WNo-PmSr4xyk4ktMyFxD_DAwl_vs8HhE3-KE5J78", forHTTPHeaderField: "X-Sheetson-Spreadsheet-Id")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpMethod = "GET"
        
        let urlSession = URLSession(configuration: URLSessionConfiguration.default)
        urlSession.dataTask(with: urlRequest) { (data, response, error) in
            if error == nil
            {
                do
                {
                    let json = try! JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:Any]
                    print(json)
                    if let resultsJSON = json["results"] as? [[String:Any]]
                    {
                        let resultsData = try? JSONSerialization.data(withJSONObject: resultsJSON, options: .prettyPrinted)
                        let decoder = JSONDecoder()
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "dd-MM-yyyy"
                        decoder.dateDecodingStrategy = .formatted(dateFormatter)
                        let tasks = try decoder.decode([VBTaskDTO].self, from: resultsData!)
                        completionHandler(nil,tasks)
                    }
                    
                }catch
                {
                    print("error:\(error.localizedDescription)")
                    completionHandler(error,[])
                }
                
            }else
            {
                print("error:\(error!.localizedDescription)")
                completionHandler(error,[])
            }
            }.resume()

    }
    
    /// Update the details of a specific task in the google sheet
    ///
    /// - Parameters:
    ///   - task: Task with updated details
    ///   - completionHandler: completion handler called when the operation is completed
    func updateTask(task:VBTaskDTO,_ completionHandler:@escaping (_ error:Error?)->())
    {
        guard let url = URL(string: "https://api.sheetson.com/v1/sheets/Tasks/\(task.rowIndex)") else { return  }
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("17m2WNo-PmSr4xyk4ktMyFxD_DAwl_vs8HhE3-KE5J78", forHTTPHeaderField: "X-Sheetson-Spreadsheet-Id")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpMethod = "PUT"
        let encoder = JSONEncoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        encoder.dateEncodingStrategy = .formatted(dateFormatter)
        urlRequest.httpBody = try! encoder.encode(task)
        let urlSession = URLSession(configuration: URLSessionConfiguration.default)
        urlSession.dataTask(with: urlRequest) { (data, response, error) in
            
            completionHandler(error)
            }.resume()
    }
}
