//
//  VBTaskDetailsVC.swift
//  VBTaskManager
//
//  Created by Varoon Behramsha on 09/06/19.
//  Copyright © 2019 Varoon Behramsha. All rights reserved.
//

import UIKit

protocol VBTaskDetailsVCDelegate: class
{
    func didSave()
}

class VBTaskDetailsVC: UIViewController
{
    var task:VBTask!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var dueDateButton: UIButton!
    @IBOutlet weak var prioritySegment: UISegmentedControl!
    @IBOutlet weak var statusSegment: UISegmentedControl!
    @IBOutlet weak var notesTextView: UITextView!
    
    weak var delegate:VBTaskDetailsVCDelegate?
    
    private var currentPriority:VBTaskPriority!
    private var currentStatus:VBTaskStatus!
    private var currentDueDate: Date!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setupUI()

        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
    }

    //MARK: - Button Actions
    @IBAction func prioritySegmentValueChanged(_ sender: Any)
    {
        switch self.prioritySegment.selectedSegmentIndex
        {
        case 0: self.currentPriority = VBTaskPriority.low
        case 1: self.currentPriority = VBTaskPriority.medium
        case 2:
            self.currentPriority = VBTaskPriority.high
            
        default:
            break
        }
    }
    
    @IBAction func statusSegmentValueChanged(_ sender: Any)
    {
        switch self.statusSegment.selectedSegmentIndex
        {
        case 0: // Open
            self.currentStatus = .open
        case 1: // Closed
            self.currentStatus = .closed
        default:break
        }
        
    }
    @IBAction func saveButtonAction(_ sender: Any)
    {
        let updatedTask = VBTask(rowIndex: self.task.rowIndex, title: self.titleTextField.text!, dueDate: self.currentDueDate, priority: self.currentPriority, status: self.currentStatus, notes: self.notesTextView.text)
        NetworkManager.shared.updateTask(task: updatedTask) { (error) in
            if error == nil
            {
                DispatchQueue.main.async {
                    self.delegate?.didSave()
                }
            }else
            {
                print("Update Task Failed : Error : \(error?.localizedDescription ?? "")")
            }
        }
        
    }
    //MARK:- Helper Methods
    func setupUI()
    {
        // Initialising the properties required by the different UI components in this View Controller...
        self.currentStatus = self.task.status
        self.currentPriority = self.task.priority
        self.currentDueDate = self.task.dueDate
        //
        self.titleTextField.text = self.task.title
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM"
        
        self.dueDateButton.setTitle(dateFormatter.string(from: self.currentDueDate!), for: .normal)
        
        switch self.currentPriority! {
        case .low:
            self.prioritySegment.selectedSegmentIndex = 0
        case .medium:
            self.prioritySegment.selectedSegmentIndex = 1
        case .high:
            self.prioritySegment.selectedSegmentIndex = 2
            
        }
        
        switch self.currentStatus! {
        case .open:
            self.statusSegment.selectedSegmentIndex = 0
        case .closed:
            self.statusSegment.selectedSegmentIndex = 1
        }
        
            self.notesTextView.text = self.task.notes ?? ""
        
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
