//
//  VBLocalDataManagerMock.swift
//  VBTaskManager
//
//  Created by Varoon Behramsha on 03/10/19.
//  Copyright © 2019 Varoon Behramsha. All rights reserved.
//

import Foundation
@testable import VBTaskManager

class LocalDataManagerMock : LocalDataManagerProtocol
{
    var tasks:[VBTask] = []
    func getTasksfromLocalDB() -> [VBTask] {
        return self.tasks
    }
    
    func addTasksToLocalDB(tasks: [VBTask]) {
        
    }
    
    
}
