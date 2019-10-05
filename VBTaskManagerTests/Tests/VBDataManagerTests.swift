//
//  VBDataManagerTests.swift
//  VBTaskManagerTests
//
//  Created by Varoon Behramsha on 03/10/19.
//  Copyright © 2019 Varoon Behramsha. All rights reserved.
//

import XCTest
@testable import VBTaskManager

class VBDataManagerTests: XCTestCase {

    var localDataManagerMock :LocalDataManagerMock!
    var remoteDataManagerMock : RemoteDataManagerMock!
    
    //Subject Under Test : VBDataManager
    var sut : VBDataManager!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        self.localDataManagerMock = LocalDataManagerMock()
        self.remoteDataManagerMock = RemoteDataManagerMock()
        self.sut = VBDataManager(remoteDataManager: self.remoteDataManagerMock, localDataManager: self.localDataManagerMock)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

   func test_getTasks_withServerError_localStorageTasks()
   {
    let _expectation = expectation(description: "Tasks Received")
    
    //Arrange
    self.remoteDataManagerMock.encounteredServerError = true
     let task1 = VBTask(rowIndex: 0, title: "Test Task", dueDate: Date(), priority: .high, status: .open, notes: "Test Notes")
      let task2 = VBTask(rowIndex: 1, title: "Task2", dueDate: Date(), priority: .medium, status: .closed, notes: "")
    self.localDataManagerMock.tasks = [task1]
    self.remoteDataManagerMock.tasks = [VBTaskDTO(task: task1),VBTaskDTO(task: task2)]

    //Act
    self.sut.getTasks { (error, tasks) in
        //Assert there was no error
        XCTAssertNil(error)
        
        //Assert there is only one task as the local data manager has only one task to return
        XCTAssert(tasks.count == 1)
        
        //Assert that the correct task (from local data manager) is returned
        XCTAssert(tasks[0].rowIndex == task1.rowIndex)
        _expectation.fulfill()
    }
    waitForExpectations(timeout: 2, handler: nil)
    }

    func test_getTasks_withoutServerError_remoteStorageTasks()
    {
        let _expectation = expectation(description: "Tasks Received")
        
        //Arrange
        self.remoteDataManagerMock.encounteredServerError = false
        
        let task1 = VBTask(rowIndex: 0, title: "Test Task", dueDate: Date(), priority: .high, status: .open, notes: "Test Notes")
        let task2 = VBTask(rowIndex: 1, title: "Task2", dueDate: Date(), priority: .medium, status: .closed, notes: "")
        self.localDataManagerMock.tasks = [task1]
        self.remoteDataManagerMock.tasks = [VBTaskDTO(task: task1),VBTaskDTO(task: task2)]
        
        //Act
        self.sut.getTasks { (error, tasks) in
            //Assert there was no error
            XCTAssertNil(error)
            
            //Assert there is only one task as the local data manager has only one task to return
            XCTAssert(tasks.count == 2)
            
            //Assert that the correct task (from local data manager) is returned
            XCTAssert(tasks[0].rowIndex == task1.rowIndex)
            XCTAssert(tasks[1].rowIndex == task2.rowIndex)

            _expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
}
