//
//  VBTask.swift
//  VBTaskManager
//
//  Created by Varoon Behramsha on 09/06/19.
//  Copyright © 2019 Varoon Behramsha. All rights reserved.
//

import Foundation

enum VBTaskPriority : String
{
    case low,medium,high
}
enum VBTaskStatus : String
{
    case open,closed
}
struct VBTask
{
    let taskID : String
    var title : String
    var dueDate : Date?
    var priority : VBTaskPriority
    var status : VBTaskStatus
    var notes : String?
}
