//
//  ItemDetailViewController.swift
//  Checklists
//
//  Created by Sergey Romaniuk on 17.01.15.
//  Copyright (c) 2015 Sergey Romaniuk. All rights reserved.
//

import UIKit


// протокол делегата itemDetailViewController
protocol itemDetailViewControllerDelegate: class {
    // обработка нажатия на Cancel    
    func itemDetailViewControllerDidCancel(controller: ItemDetailViewController)
    // обработка нажатия на Done при создании нового Item    
    func itemDetailViewController(controller: ItemDetailViewController,
        didFinishAddingItem item: ChecklistItem)
    // обработка нажатия на Done при редактировании Item
    func itemDetailViewController(controller: ItemDetailViewController,
        didFinishEditingItem item: ChecklistItem)
}

class ItemDetailViewController: UITableViewController, UITextFieldDelegate {

    
    var itemToEdit: ChecklistItem?

    @IBAction func CancelButt() {
        delegate?.itemDetailViewControllerDidCancel(self)
        
    }
    
    @IBAction func DoneButt() {
        if let item = itemToEdit {
            item.text = newItemText.text
            delegate?.itemDetailViewController(self, didFinishEditingItem: item)
        }
        else {
            let item = ChecklistItem()
            item.text = newItemText.text
            item.checked = false
            delegate?.itemDetailViewController(self, didFinishAddingItem: item)
             
        }
    }
    
// для включения/отключения кнопки Done методом который проверяет введено ли что-то в поле для ввода
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    
    @IBOutlet weak var newItemText: UITextField!

    weak var delegate: itemDetailViewControllerDelegate?
    
// подготовка окна (перелючение Add/Edit)
    override func viewDidLoad() {
        super.viewDidLoad()
        if let item = itemToEdit {
            title = "Edit Item"
            newItemText.text = item.text
        }
    }
    
// отключает выбор ячейки
    override func tableView(tableView: UITableView,
        willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        return nil
    }
    
//Проверяет введено ли что-то в поле для ввода и потом делает кнопку DoneBarButton активной
    func textField(textField: UITextField,
        shouldChangeCharactersInRange range: NSRange,
                    replacementString string: String) -> Bool {
        let oldText: NSString = textField.text
        let newText: NSString = oldText.stringByReplacingCharactersInRange(
        range, withString: string)
        doneBarButton.enabled = (newText.length > 0)
        return true
    }
  
}
