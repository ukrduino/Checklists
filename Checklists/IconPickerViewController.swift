//
//  IconPickerViewController.swift
//  Checklists
//
//  Created by Sergey Romaniuk on 23.01.15.
//  Copyright (c) 2015 Sergey Romaniuk. All rights reserved.
//

import UIKit

// выбирает иконку для чеклиста

protocol IconPickerViewControllerDelegate: class {
    func iconPicker(picker: IconPickerViewController, didPickIcon iconName: String)
}

class IconPickerViewController: UITableViewController {
        
    weak var delegate: IconPickerViewControllerDelegate?
    
    let icons = [
        "No Icon",
        "Appointments",
        "Birthdays",
        "Chores",
        "Drinks",
        "Folder",
        "Groceries",
        "Inbox",
        "Photos",
        "Trips"]
        

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return icons.count
    }

// Названия иконок выводит в таблице
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCellWithIdentifier("IconCell") as UITableViewCell
            cell.textLabel!.text = icons[indexPath.row]
            return cell
    }
 
// передает в ListDetailViewController название выбранной в таблице иконки
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let delegate = delegate {
            let iconName = icons[indexPath.row]
            delegate.iconPicker(self, didPickIcon: iconName)
        }
    }

}