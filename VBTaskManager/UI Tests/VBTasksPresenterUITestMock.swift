//
//  VBTasksPresenterUITestMock.swift
//  VBTaskManager
//
//  Created by Varoon Behramsha on 06/10/19.
//  Copyright © 2019 Varoon Behramsha. All rights reserved.
//

import Foundation

class VBTasksPresenterUITestMock:TaskPresenterProtocol
{
    var tasks: [VBTaskDTO] = []
    
    
    func loadData(_ completionHandler: @escaping BlockWithError)
    {
        // Simulate network call
        DispatchQueue.main.asyncAfter(deadline:  DispatchTime.now() + .seconds(1)) {
            let task1 = VBTaskDTO(rowIndex: 0, title: "Test Task", dueDate: Date(), priority: .high, status: .open, notes: "Test Notes")
            let task2 = VBTaskDTO(rowIndex: 1, title: "Task2", dueDate: Date(), priority: .medium, status: .closed, notes: "")
            self.tasks = [task1,task2]
            completionHandler(nil)
        }
        
    }
    
    
}
