//
//  VBTaskDetailsVC.swift
//  VBTaskManager
//
//  Created by Varoon Behramsha on 09/06/19.
//  Copyright © 2019 Varoon Behramsha. All rights reserved.
//

import UIKit

class VBTaskDetailsVC: UIViewController
{
    var task:VBTask!
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var dueDateButton: UIButton!
    @IBOutlet weak var prioritySegment: UISegmentedControl!
    @IBOutlet weak var statusSegment: UISegmentedControl!
    @IBOutlet weak var notesTextView: UITextView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.titleTextField.text = task.title
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM"
        
        self.dueDateButton.titleLabel?.text = task.dueDate == nil ? "Set" : dateFormatter.string(from: task.dueDate!)
        
        switch self.task.priority {
        case .low:
            self.prioritySegment.selectedSegmentIndex = 0
        case .medium:
            self.prioritySegment.selectedSegmentIndex = 1
        case .high:
            self.prioritySegment.selectedSegmentIndex = 2

        }

        switch self.task.status {
        case .open:
            self.statusSegment.selectedSegmentIndex = 0
        case .closed:
            self.statusSegment.selectedSegmentIndex = 1
        }
        self.notesTextView.text = self.task.notes
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
