//
//  VBTasksTVC.swift
//  VBTaskManager
//
//  Created by Varoon Behramsha on 09/06/19.
//  Copyright © 2019 Varoon Behramsha. All rights reserved.
//

import UIKit

class VBTasksTVC: UITableViewController,VBTaskDetailsVCDelegate
{
    
    

    fileprivate var presenter : VBTasksPresenter!
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        //Dynamic Row Height based on content size
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.presenter = VBTasksPresenter()
        presenter.loadData { (error) in
            if error == nil
            {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }

  
    //MARK : - VBTaskDetailsVCDelegate
    func didSave()
    {
        self.navigationController?.popViewController(animated: true)
        self.presenter.loadData { (error) in
            if error == nil
            {
                self.tableView.reloadData()
            }
        }
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.presenter.tasks.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let task = self.presenter.tasks[indexPath.row]
        
        let cell = VBTaskCell.dequeueCell(from: tableView, for: indexPath, with: task)
        cell.tag = indexPath.row
        return cell
    }
   
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "TaskDetailsSegue"
        {
            let taskDetailsVC = segue.destination as? VBTaskDetailsVC
            if let cell = sender as? VBTaskCell
            {
                let taskDetailsPresenter = VBTaskDetailsPresenter(task: self.presenter.tasks[cell.tag])
                taskDetailsVC?.presenter = taskDetailsPresenter
                taskDetailsVC?.delegate = self
            }
        }
    }
    

}
