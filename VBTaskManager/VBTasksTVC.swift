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
    
    

    private var tasks : [VBTask] = []
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        //Dynamic Row Height based on content size
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.loadData()
    }

    //MARK: - Data Related Methods
    private func loadData()
    {
        self.getTasks { (error, tasks) in
            if error == nil
            {
                self.tasks = tasks
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    
                }
            }
        }
    }
    private func getTasks(completionHandler: @escaping (_ error:Error?,_ tasks:[VBTask])->())
    {
//        let task1 = VBTask(taskID: UUID().uuidString, title: "Design UI for Cell", dueDate: Date(), priority: .medium, status: .open, notes: nil)
//        let task2 = VBTask(taskID: UUID().uuidString, title: "Design DB Model for Task", dueDate: Date(), priority: .medium, status: .open, notes: nil)
//
        guard let url = URL(string: "https://api.sheetson.com/v1/sheets/Tasks") else { return  }
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("17m2WNo-PmSr4xyk4ktMyFxD_DAwl_vs8HhE3-KE5J78", forHTTPHeaderField: "X-Sheetson-Spreadsheet-Id")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpMethod = "GET"
        
        let urlSession = URLSession(configuration: URLSessionConfiguration.default)
        urlSession.dataTask(with: urlRequest) { (data, response, error) in
            if error == nil
            {
                do
                {
                    let json = try! JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:Any]
                    print(json)
                    if let resultsJSON = json["results"] as? [[String:Any]]
                    {
                        let resultsData = try? JSONSerialization.data(withJSONObject: resultsJSON, options: .prettyPrinted)
                        let decoder = JSONDecoder()
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "dd-MM-yyyy"
                        decoder.dateDecodingStrategy = .formatted(dateFormatter)
                        let tasks = try decoder.decode([VBTask].self, from: resultsData!)
                        completionHandler(nil,tasks)
                    }
                    
                }catch
                {
                    print("error:\(error.localizedDescription)")
                }
                
            }
        }.resume()
        //completionHandler(nil,[task1,task2])
    }
    
    //MARK : - VBTaskDetailsVCDelegate
    func didSave()
    {
        self.navigationController?.popViewController(animated: true)
        self.loadData()
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.tasks.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VBTaskCell", for: indexPath) as! VBTaskCell
        // Configure the cell...

        let task = self.tasks[indexPath.row]
        cell.titleLabel.text = task.title
     
        switch task.priority
        {
        case .low: cell.priorityLabel.text = "!"
        case .medium: cell.priorityLabel.text = "!!"
        case .high: cell.priorityLabel.text = "!!!"
        }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        
        cell.dueDateLabel.text = task.dueDate == nil ? " " : dateFormatter.string(from: task.dueDate)

        cell.tag = indexPath.row
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
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
                taskDetailsVC?.task = self.tasks[cell.tag]
                taskDetailsVC?.delegate = self
            }
        }
    }
    

}
