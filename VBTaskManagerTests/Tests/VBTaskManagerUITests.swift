//
//  VBTaskManagerUITests.swift
//  VBTaskManagerTests
//
//  Created by Varoon Behramsha on 05/10/19.
//  Copyright © 2019 Varoon Behramsha. All rights reserved.
//

import XCTest

class VBTaskManagerUITests: XCTestCase {

    let app = XCUIApplication()
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        app.launchArguments = ["UITests"]
        app.launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_tableViewCell()
    {
        //Wait for table view to load the cell
        waitForExistence(of: app.tables.cells.firstMatch)
        
        //Check the number of cells. Should match the number of tasks in VBTasksPresenterUITestMock
        XCTAssert(app.tables.cells.count == 2)
        
        let cells = app.tables.cells
        let cell = cells.firstMatch
        
        //Check the title label's text
        let titleLabel = cell.children(matching: .staticText)["TaskCellTitleLabel"]
        XCTAssertEqual(titleLabel.label, "Test Task")
      
        //Check the priority label's text
        let priorityLabel = cell.children(matching: .staticText)["TaskCellPriorityLabel"]
        XCTAssertEqual(priorityLabel.label, "!!!")
       
        //Check the date label's text
        let dateLabel = cell.children(matching: .staticText)["TaskCellDateLabel"]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        XCTAssertEqual(dateLabel.label, dateFormatter.string(from: Date()))

    }
    
    func test_taskDetailsVC()
    {
        //Wait for table view to load the cell
        waitForExistence(of: app.tables.cells.firstMatch)
        
        let cells = app.tables.cells
        let cell = cells.firstMatch
        cell.tap()

        let titleTextField = app.textFields["TaskTitleLabel"]
        XCTAssertEqual(titleTextField.value as! String,"Test Task")
        
        let dateButton = app.buttons["DueDateButton"]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM"
        XCTAssertEqual(dateButton.label, dateFormatter.string(from: Date()))
        
        let notesTextView = app.textViews["NotesTextView"]
        XCTAssertEqual(notesTextView.value as! String, "Test Notes")

    }
    
    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

}

extension XCTestCase {
    
    func waitForExistence(of element: XCUIElement, file: String = #file, line: UInt = #line) {
        let predicate = NSPredicate(format: "exists == true")
        expectation(for: predicate, evaluatedWith: element, handler: nil)
        
        waitForExpectations(timeout: 3) { (error) in
            guard error != nil else { return }
            
            let description = "\(element) does not exist after 3 seconds."
            self.recordFailure(withDescription: description, inFile: file, atLine: Int(line), expected: true)
        }
    }
}
