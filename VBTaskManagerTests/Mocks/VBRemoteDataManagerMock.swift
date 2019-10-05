//
//  VBRemoteDataManagerMock.swift
//  VBTaskManager
//
//  Created by Varoon Behramsha on 02/10/19.
//  Copyright © 2019 Varoon Behramsha. All rights reserved.
//

import Foundation
@testable import VBTaskManager

class RemoteDataManagerMock:RemoteDataManagerProtocol
{
    var tasks:[VBTaskDTO]!
    var encounteredServerError = false
    func getTasks(completionHandler: @escaping BlockWithTasks) {
        
        if encounteredServerError
        {
            completionHandler(ServerError.unknown,[])
            return
        }
        
      //  let task1 = VBTaskDTO(rowIndex: 0, title: "Test Task", dueDate: Date(), priority: .high, status: .open, notes: "Test Notes")
      //  let task2 = VBTaskDTO(rowIndex: 1, title: "Task2", dueDate: Date(), priority: .medium, status: .closed, notes: "")
        completionHandler(nil,self.tasks)
        
    }
    
    func updateTask(task: VBTaskDTO, _ completionHandler: @escaping BlockWithError) {
        completionHandler(nil)
    }
    
    
}

enum ServerError:Error
{
    case unknown,connectionLost,invalidRequest
}
