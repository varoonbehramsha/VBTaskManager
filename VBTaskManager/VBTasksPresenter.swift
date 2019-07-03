//
//  VBTasksPresenter.swift
//  VBTaskManager
//
//  Created by Varoon Behramsha on 20/06/19.
//  Copyright © 2019 Varoon Behramsha. All rights reserved.
//

import Foundation

class VBTasksPresenter
{
    var dataManager : VBDataManager
    
     var tasks : [VBTaskDTO] = []
    
    init(dataManager:VBDataManager)
    {
        self.dataManager = dataManager
    }
    
    func loadData(_ completionHandler:@escaping(_ error:Error?)->())
    {
        self.dataManager.getTasks { (error, tasks) in
            if error == nil
            {
                self.tasks = tasks
                
            }
            completionHandler(error)
        }
    }
}
