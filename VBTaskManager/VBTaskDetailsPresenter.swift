//
//  VBTaskDetailsPresenter.swift
//  VBTaskManager
//
//  Created by Varoon Behramsha on 25/06/19.
//  Copyright © 2019 Varoon Behramsha. All rights reserved.
//

import Foundation

class VBTaskDetailsPresenter
{
    var dataManager : VBDataManager!
    private var task:VBTaskDTO!
    
    var title:String
    var dueDate:Date
    var priority:VBTaskPriority
    var status:VBTaskStatus
    var notes : String?
    
    init(task:VBTaskDTO, dataManager:VBDataManager)
    {
        self.task = task
        
        self.title = task.title
        self.dueDate = task.dueDate
        self.priority = task.priority
        self.status = task.status
        self.notes = task.notes
        self.dataManager = dataManager
    }
    
    func save(_ completionHandler:@escaping (_ error:Error?)->())
    {
        let updatedTask = VBTaskDTO(rowIndex: self.task.rowIndex, title: self.title, dueDate: self.dueDate, priority: self.priority, status: self.status, notes: self.notes)
        
        self.dataManager.updateTask(taskDTO: updatedTask) { (error) in
  
            completionHandler(error)
        }
    }
}
