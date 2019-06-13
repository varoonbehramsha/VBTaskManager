//
//  VBTask.swift
//  VBTaskManager
//
//  Created by Varoon Behramsha on 09/06/19.
//  Copyright © 2019 Varoon Behramsha. All rights reserved.
//

import Foundation

enum VBTaskPriority : String,Codable
{
    case low,medium,high
}
enum VBTaskStatus : String,Codable
{
    case open,closed
}

struct VBTask : Codable
{
    let rowIndex : Int
    var title : String
    var dueDate : Date
    var priority : VBTaskPriority
    var status : VBTaskStatus
    var notes : String?
}
