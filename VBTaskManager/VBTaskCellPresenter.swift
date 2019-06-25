//
//  VBTaskCellPresenter.swift
//  VBTaskManager
//
//  Created by Varoon Behramsha on 24/06/19.
//  Copyright © 2019 Varoon Behramsha. All rights reserved.
//

import Foundation

class VBTaskCellPresenter
{
    private var task: VBTaskDTO!
    
    var priority : VBTaskPriority! {return self.task.priority}
    var title:String! {return self.task.title}
    var dueDate : Date! {return self.task.dueDate}
    
    init(task:VBTaskDTO)
    {
        self.task = task
    }
}
