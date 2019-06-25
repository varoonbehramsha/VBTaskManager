//
//  VBDataManager.swift
//  VBTaskManager
//
//  Created by Varoon Behramsha on 17/06/19.
//  Copyright © 2019 Varoon Behramsha. All rights reserved.
//

import Foundation
import RealmSwift

class VBDataManager
{
    static let shared = VBDataManager()
    private init()
    {
        
    }
    
    func getTasks(_ completionHandler :@escaping (_ error:Error?,_ tasks:[VBTaskDTO])->())
    {

        //1. Get tasks from local DB
        DispatchQueue.main.async {
            let tasks = self.getTasksfromLocalDB()
            completionHandler(nil,tasks.map{VBTaskDTO(task: $0)})
        }
        //2. Fetch tasks from remote DB
        NetworkManager.shared.getTasks { (error, taskDTOs) in
            if error == nil
            {
                
                //Add to local DB
                DispatchQueue.main.async {
                    self.addTasksToLocalDB(tasks: taskDTOs.map{VBTask(taskDTO: $0)})
                    completionHandler(error,taskDTOs)
                }
                
            }else
            {
                completionHandler(error,[])
            }
        }
    }
    
    func updateTask(taskDTO:VBTaskDTO,_ completionHandler: @escaping (_ error:Error?)->())
    {
        //1. Update in Remote DB
        NetworkManager.shared.updateTask(task: taskDTO) { (error) in
            if error == nil
            {
                //2. Update in local DB
                self.addTasksToLocalDB(tasks: [VBTask(taskDTO: taskDTO)])
                completionHandler(nil)
            }else
            {
                completionHandler(error)
            }
        }
    }
    
    
}

//MARK: - Local Database Operations
extension VBDataManager
{
    private func getTasksfromLocalDB()-> [VBTask]
    {
        
            let realm = try! Realm()
            let tasks = realm.objects(VBTask.self)
            return Array(tasks)
      
    }
    
    
    
    private func addTasksToLocalDB(tasks:[VBTask])
    {
        
            let realm = try! Realm()
            try! realm.write {
                realm.add(tasks, update: Realm.UpdatePolicy.modified)
            }
        
        
    }
}
