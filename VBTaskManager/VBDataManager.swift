//
//  VBDataManager.swift
//  VBTaskManager
//
//  Created by Varoon Behramsha on 17/06/19.
//  Copyright © 2019 Varoon Behramsha. All rights reserved.
//

import Foundation

protocol DataManagerProtocol
{
    func getTasks(_ completionHandler :@escaping BlockWithTasks)
    func updateTask(taskDTO:VBTaskDTO,_ completionHandler: @escaping BlockWithError)

}

class VBDataManager : DataManagerProtocol
{
    var remoteDataManager = VBRemoteDataManager()
    var localDataManager = VBLocalDataManager()
    

    init(remoteDataManager:VBRemoteDataManager, localDataManager:VBLocalDataManager)
    {
        self.remoteDataManager = remoteDataManager
        self.localDataManager = localDataManager
        
    }
    
    func getTasks(_ completionHandler :@escaping BlockWithTasks)
    {

        //1. Get tasks from local DB
        DispatchQueue.main.async {
            let tasks = self.localDataManager.getTasksfromLocalDB()
            completionHandler(nil,tasks.map{VBTaskDTO(task: $0)})
        }
        //2. Fetch tasks from remote DB
        self.remoteDataManager.getTasks { (error, taskDTOs) in
            if error == nil
            {
                
                //Add to local DB
                DispatchQueue.main.async {
                    self.localDataManager.addTasksToLocalDB(tasks: taskDTOs.map{VBTask(taskDTO: $0)})
                    completionHandler(error,taskDTOs)
                }
                
            }else
            {
                completionHandler(error,[])
            }
        }
    }
    
    func updateTask(taskDTO:VBTaskDTO,_ completionHandler: @escaping BlockWithError)
    {
        //1. Update in Remote DB
        self.remoteDataManager.updateTask(task: taskDTO) { (error) in
            if error == nil
            {
                //2. Update in local DB
                self.localDataManager.addTasksToLocalDB(tasks: [VBTask(taskDTO: taskDTO)])
                completionHandler(nil)
            }else
            {
                completionHandler(error)
            }
        }
    }
    
    
}

