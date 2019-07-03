//
//  VBLocalDataManager.swift
//  VBTaskManager
//
//  Created by Varoon Behramsha on 03/07/19.
//  Copyright © 2019 Varoon Behramsha. All rights reserved.
//

import Foundation
import RealmSwift

class VBLocalDataManager
{
     func getTasksfromLocalDB()-> [VBTask]
    {
        
        let realm = try! Realm()
        let tasks = realm.objects(VBTask.self)
        return Array(tasks)
        
    }
    
    
    
     func addTasksToLocalDB(tasks:[VBTask])
    {
        
        let realm = try! Realm()
        try! realm.write {
            realm.add(tasks, update: Realm.UpdatePolicy.modified)
        }
        
        
    }
}
