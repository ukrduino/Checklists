//
//  AllListsViewController.swift
//  Checklists
//
//  Created by Sergey Romaniuk on 21.01.15.
//  Copyright (c) 2015 Sergey Romaniuk. All rights reserved.
//

import UIKit

class AllListsViewController: UITableViewController, ListDetailViewControllerDelegate{
    
    
    var lists: [Checklist]
    
    required init(coder aDecoder: NSCoder) {
        // Put values into your instance variables and constants.
        // 1
        lists = [Checklist]()
        // 2
        super.init(coder: aDecoder)
        
        // Other initialization code, such as calling methods, goes here.
       
        var list = Checklist(name: "Birthdays")
        lists.append(list)
        list = Checklist(name: "Groceries")
        lists.append(list)
        list = Checklist(name: "Cool Apps")
        lists.append(list)
        list = Checklist(name: "To Do")
        lists.append(list)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }



    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return lists.count
    }
    
    override func tableView(tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "Cell"
        let checklist = lists[indexPath.row]
        var cell: UITableViewCell! = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? UITableViewCell
        if cell == nil {cell = UITableViewCell(style: .Default, reuseIdentifier: cellIdentifier)
        }
        cell.textLabel!.text = checklist.name
        cell.accessoryType = .DetailDisclosureButton
        return cell
    }
    
    override func tableView(tableView: UITableView,
            didSelectRowAtIndexPath indexPath: NSIndexPath) {
            let checklist = lists[indexPath.row]
            performSegueWithIdentifier("ShowChecklist", sender: checklist)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue,
        sender: AnyObject!) {
        if segue.identifier == "ShowChecklist" {
            let controller = segue.destinationViewController as ChecklistsViewController
            controller.checklist = sender as Checklist
        }
        else if segue.identifier == "AddChecklist" {
            let navigationController = segue.destinationViewController
            as UINavigationController
            let controller = navigationController.topViewController
            as ListDetailViewController
            controller.delegate = self
            controller.checklistToEdit = nil
        }
    }
    
    func listDetailViewControllerDidCancel(
        controller: ListDetailViewController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    func listDetailViewController(controller: ListDetailViewController,
        didFinishAddingChecklist checklist: Checklist) {
           lists.append(checklist)
           tableView.reloadData()
           dismissViewControllerAnimated(true, completion: nil)
    }
    func listDetailViewController(controller: ListDetailViewController,
        didFinishEditingChecklist checklist: Checklist) {
            if let index = find(lists, checklist) {
                let indexPath = NSIndexPath(forRow: index, inSection: 0)
                if let cell = tableView.cellForRowAtIndexPath(indexPath) {
                    cell.textLabel!.text = checklist.name
                }
            }
        dismissViewControllerAnimated(true, completion: nil)
    }
    override func tableView(tableView: UITableView,
      commitEditingStyle editingStyle: UITableViewCellEditingStyle,
          forRowAtIndexPath indexPath: NSIndexPath) {
            lists.removeAtIndex(indexPath.row)
            let indexPaths = [indexPath]
            tableView.deleteRowsAtIndexPaths(indexPaths,
            withRowAnimation: .Automatic)
    }
    
    override func tableView(tableView: UITableView,
            accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
            let navigationController = storyboard!.instantiateViewControllerWithIdentifier("ListNavigationController") as UINavigationController
            let controller = navigationController.topViewController as ListDetailViewController
            controller.delegate = self
            let checklist = lists[indexPath.row]
            controller.checklistToEdit = checklist
            presentViewController(navigationController, animated: true,
            completion: nil)
    }

}