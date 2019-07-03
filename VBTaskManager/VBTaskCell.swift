//
//  VBTaskCell.swift
//  VBTaskManager
//
//  Created by Varoon Behramsha on 09/06/19.
//  Copyright © 2019 Varoon Behramsha. All rights reserved.
//

import UIKit

class VBTaskCell: UITableViewCell {
    @IBOutlet weak var priorityLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dueDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension VBTaskCell
{
    public func configure(with presenter:VBTaskCellPresenter)
    {
     self.setPriorityLabel(priority: presenter.priority)
        self.setTitleLabel(title: presenter.title)
        self.setDueDateLabel(dueDate: presenter.dueDate)
    }
    
    private func setPriorityLabel(priority:VBTaskPriority)
    {
        switch priority
        {
        case .low: self.priorityLabel.text = "!"
        case .medium: self.priorityLabel.text = "!!"
        case .high: self.priorityLabel.text = "!!!"
        }
    }
    
    private func setTitleLabel(title:String)
    {
        self.titleLabel.text = title
    }
    
    private func setDueDateLabel(dueDate : Date)
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        
        self.dueDateLabel.text = dateFormatter.string(from: dueDate)
    }
    
    
}
extension VBTaskCell
{
    public static var cellID : String
    {
        return "VBTaskCell"
    }
    
    public static func dequeueCell(from tableView : UITableView, for indexPath: IndexPath, with presenter:VBTaskCellPresenter) -> VBTaskCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: VBTaskCell.cellID, for: indexPath) as! VBTaskCell
        
        cell.configure(with: presenter)
        
        return cell
    }
}
