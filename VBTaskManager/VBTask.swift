//
//  VBTask.swift
//  VBTaskManager
//
//  Created by Varoon Behramsha on 09/06/19.
//  Copyright © 2019 Varoon Behramsha. All rights reserved.
//

import Foundation
import RealmSwift

enum VBTaskPriority : String,Codable
{
    case low,medium,high
}
enum VBTaskStatus : String,Codable
{
    case open,closed
}

struct VBTaskDTO : Codable
{
    let rowIndex : Int
    var title : String
    var dueDate : Date
    var priority : VBTaskPriority
    var status : VBTaskStatus
    var notes : String?
}

extension VBTaskDTO
{
    init(task:VBTask)
    {
        self.rowIndex = task.rowIndex
        self.title = task.title
        self.dueDate = task.dueDate
        self.priority = task.priority
        self.status = task.status
        self.notes = task.notes
    }
}

class VBTask:Object
{
    @objc dynamic var rowIndex : Int = 0
    @objc dynamic var title : String = ""
    @objc dynamic var dueDate : Date = Date()
    @objc private dynamic var privatePriority : String = VBTaskPriority.low.rawValue
    var priority : VBTaskPriority
    {
        get {return VBTaskPriority(rawValue: privatePriority) ?? VBTaskPriority.low}
        set {privatePriority = newValue.rawValue}
    }
    @objc private dynamic var privateStatus : String = VBTaskStatus.open.rawValue
    var status:VBTaskStatus
    {
        get {return VBTaskStatus(rawValue: privateStatus) ?? VBTaskStatus.open}
        set {privateStatus = newValue.rawValue}
    }
    @objc dynamic var notes : String? = nil
    
    convenience init(rowIndex:Int,title:String,dueDate:Date,priority:VBTaskPriority,status:VBTaskStatus,notes:String?)
    {
        self.init()
        self.rowIndex = rowIndex
        self.title = title
        self.dueDate = dueDate
        self.priority = priority
        self.status = status
        self.notes = notes
    }
    
    convenience init(taskDTO:VBTaskDTO)
    {
        self.init(rowIndex: taskDTO.rowIndex, title: taskDTO.title, dueDate: taskDTO.dueDate, priority: taskDTO.priority, status: taskDTO.status, notes: taskDTO.notes)
    }
    
   
    override static func primaryKey()->String?
    {
        return "rowIndex"
    }
    
}
