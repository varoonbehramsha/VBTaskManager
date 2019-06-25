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
    var presenter : VBTaskDetailsPresenter!
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var dueDateButton: UIButton!
    @IBOutlet weak var prioritySegment: UISegmentedControl!
    @IBOutlet weak var statusSegment: UISegmentedControl!
    @IBOutlet weak var notesTextView: UITextView!
    
    weak var delegate:VBTaskDetailsVCDelegate?
    
    
    
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

    
    @IBAction func saveButtonAction(_ sender: Any)
    {
        //Update values before saving
        self.presenter.title = self.titleTextField.text ?? ""
        self.presenter.notes = self.notesTextView.text
        
        switch self.statusSegment.selectedSegmentIndex
        {
        case 0: // Open
            self.presenter.status = .open
        case 1: // Closed
            self.presenter.status = .closed
        default:break
        }
        
        switch self.prioritySegment.selectedSegmentIndex
        {
        case 0: self.presenter.priority = VBTaskPriority.low
        case 1: self.presenter.priority = VBTaskPriority.medium
        case 2:
            self.presenter.priority = VBTaskPriority.high
            
        default:
            break
        }
        
        self.presenter.save { (error) in
            if error == nil{
                DispatchQueue.main.async {
                    self.delegate?.didSave()
                }
                
                }else
            {
                // Show alert with the error message
            }
        }
        
    }
    
    //MARK:- Helper Methods
    func setupUI()
    {
        // Initialising the properties required by the different UI components in this View Controller...
        self.titleTextField.text = self.presenter.title
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM"
        self.dueDateButton.setTitle(dateFormatter.string(from: self.presenter.dueDate), for: .normal)
        
        switch self.presenter.priority
        {
        case .low:
            self.prioritySegment.selectedSegmentIndex = 0
        case .medium:
            self.prioritySegment.selectedSegmentIndex = 1
        case .high:
            self.prioritySegment.selectedSegmentIndex = 2
        }
        
        switch self.presenter.status
        {
        case .open:
            self.statusSegment.selectedSegmentIndex = 0
        case .closed:
            self.statusSegment.selectedSegmentIndex = 1
        }
        
        self.notesTextView.text = self.presenter.notes ?? ""
        
    }

}


