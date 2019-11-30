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
    
    

    fileprivate var presenter : TaskPresenterProtocol!
    fileprivate var taskCellMaker : DependencyRegistry.TaskCellMaker!
    fileprivate var taskDetailsVCMaker : DependencyRegistry.TaskDetailsVCMaker!
    
    func configure(with presenter:TaskPresenterProtocol, taskDetailsVCMaker: @escaping DependencyRegistry.TaskDetailsVCMaker, taskCellMaker: @escaping DependencyRegistry.TaskCellMaker)
    {
        self.presenter = presenter
        self.taskCellMaker = taskCellMaker
        self.taskDetailsVCMaker = taskDetailsVCMaker
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        //Dynamic Row Height based on content size
        self.tableView.rowHeight = UITableViewAutomaticDimension
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
        
        let cell = self.taskCellMaker(tableView,indexPath,task)
        cell.tag = indexPath.row
        return cell
    }
   
    //MARK: - Table View Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let task = self.presenter.tasks[indexPath.row]
        let taskDetailsVC = self.taskDetailsVCMaker(task,self)
        self.navigationController?.pushViewController(taskDetailsVC, animated: true)
    }
    
    

}
