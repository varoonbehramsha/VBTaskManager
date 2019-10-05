//
//  VBTaskTests.swift
//  VBTaskManager
//
//  Created by Varoon Behramsha on 03/10/19.
//  Copyright © 2019 Varoon Behramsha. All rights reserved.
//

import XCTest
@testable import VBTaskManager

class VBTaskTests: XCTestCase {

    var taskDTO : VBTaskDTO!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        self.taskDTO = VBTaskDTO(rowIndex: 0, title: "Test Task", dueDate: Date(), priority: .high, status: .open, notes: "Test Notes")
    }

    func test_initialiser()
    {
        //Arrange
        
        //Act
        let  task = VBTask(rowIndex: self.taskDTO.rowIndex, title: self.taskDTO.title, dueDate: self.taskDTO.dueDate, priority: self.taskDTO.priority, status: self.taskDTO.status, notes: self.taskDTO.notes)
        
        //Assert
        XCTAssertEqual(self.taskDTO.rowIndex, task.rowIndex)
        XCTAssertEqual(self.taskDTO.title, task.title)
        XCTAssertEqual(self.taskDTO.dueDate, task.dueDate)
        XCTAssertEqual(self.taskDTO.priority, task.priority)
        XCTAssertEqual(self.taskDTO.status, task.status)
        XCTAssertEqual(self.taskDTO.notes, task.notes)




    }
    
    func test_initialiserWithTaskDTO()
    {
        //Arrange
        
        //Act
        let task = VBTask(taskDTO: self.taskDTO)
        
        //Assert
        XCTAssertEqual(self.taskDTO.rowIndex, task.rowIndex)
        XCTAssertEqual(self.taskDTO.title, task.title)
        XCTAssertEqual(self.taskDTO.dueDate, task.dueDate)
        XCTAssertEqual(self.taskDTO.priority, task.priority)
        XCTAssertEqual(self.taskDTO.status, task.status)
        XCTAssertEqual(self.taskDTO.notes, task.notes)

    }
    
    

}
