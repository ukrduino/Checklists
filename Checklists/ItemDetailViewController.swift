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
    var dueDate = NSDate()
    var datePickerVisible = false

    @IBAction func CancelButt() {
        delegate?.itemDetailViewControllerDidCancel(self)
        
    }
    
    @IBAction func DoneButt() {
        if let item = itemToEdit {
            item.text = newItemText.text
            item.shouldRemind = shouldRemindSwitch.on
            item.dueDate = dueDate
            item.scheduleNotification()
            delegate?.itemDetailViewController(self, didFinishEditingItem: item)
        }
        else {
            let item = ChecklistItem(name: newItemText.text)
            item.shouldRemind = shouldRemindSwitch.on
            item.dueDate = dueDate
            item.scheduleNotification()
            // можно добавить на ItemDetailViewController чекмарк и при создании его отмечать
            delegate?.itemDetailViewController(self, didFinishAddingItem: item)
             
        }
    }
   
    @IBAction func shouldRemindSwitchClicked(switchControl: UISwitch){

        if newItemText.text != "" {
            doneBarButton.enabled = true
        }
        newItemText.resignFirstResponder()
        if switchControl.on {
            let notificationSettings = UIUserNotificationSettings(forTypes: .Alert | .Sound, categories: nil)
            UIApplication.sharedApplication().registerUserNotificationSettings(notificationSettings)
        } else {
            
        }
//        let indexPathDateRow = NSIndexPath(forRow: 0, inSection: 1)
//        tableView.reloadRowsAtIndexPaths([indexPathDateRow], withRowAnimation: .None)
    }

    
// для включения/отключения кнопки Done методом который проверяет введено ли что-то в поле для ввода
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    
    @IBOutlet weak var newItemText: UITextField!
    
    @IBOutlet weak var shouldRemindSwitch: UISwitch!
    
    @IBOutlet weak var dueDateLabel: UILabel!
    
    weak var delegate: itemDetailViewControllerDelegate?
    
// подготовка окна (перелючение Add/Edit)
    override func viewDidLoad() {
        super.viewDidLoad()
        if let item = itemToEdit {
            title = "Edit Item"
            newItemText.text = item.text
            shouldRemindSwitch.on = item.shouldRemind
            dueDate = item.dueDate
        }
        updateDueDateLabel()
        tableView.rowHeight = 44
    }
    
    
//2.1 метод вызывается DatePicker-ом после изменения его пользователем
    func dateChanged(datePicker: UIDatePicker) {
        if dueDate != datePicker.date {
            dueDate = datePicker.date
            updateDueDateLabel()
            if newItemText.text != "" {
                doneBarButton.enabled = true
            }
        }
    }

//2.2 обновляем данные надписи даты напоминания из переменной dueDate с помощью NSDateFormatter()
    func updateDueDateLabel() {
        let formatter = NSDateFormatter()
        formatter.dateStyle = .MediumStyle
        formatter.timeStyle = .ShortStyle
        dueDateLabel.text = formatter.stringFromDate(dueDate)
    }
    
//1.1 нажатие на ячейке с датой уведомления открывает ячейку с DatePicker-ом путем следующих методов
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        newItemText.resignFirstResponder()
        if indexPath.section == 1 && indexPath.row == 1 {
            if !datePickerVisible {
                showDatePicker()
            } else {
                hideDatePicker()
            }
        }
    }
    
    func textFieldDidBeginEditing(textField: UITextField!) {
        hideDatePicker()
    }
    
    
//1.2 вставляем ряд во второй секции после даты напоминания
    func showDatePicker() {
        datePickerVisible = true
        let indexPathDateRow = NSIndexPath(forRow: 1, inSection: 1)
        let indexPathDatePicker = NSIndexPath(forRow: 2, inSection: 1)
        if let dateCell = tableView.cellForRowAtIndexPath(indexPathDateRow) {
            dateCell.detailTextLabel!.textColor = dateCell.detailTextLabel!.tintColor
        }
        tableView.beginUpdates()
        tableView.insertRowsAtIndexPaths([indexPathDatePicker], withRowAnimation: .Fade)
        tableView.reloadRowsAtIndexPaths([indexPathDateRow],    withRowAnimation: .None)
        tableView.endUpdates()
        if let pickerCell = tableView.cellForRowAtIndexPath(indexPathDatePicker) {
            let datePicker = pickerCell.viewWithTag(100) as UIDatePicker
        datePicker.setDate(dueDate, animated: false)
        }
    }
    
    func hideDatePicker() {
        if datePickerVisible {
            datePickerVisible = false
            let indexPathDateRow = NSIndexPath(forRow: 1, inSection: 1)
            let indexPathDatePicker = NSIndexPath(forRow: 2, inSection: 1)
            if let cell = tableView.cellForRowAtIndexPath(indexPathDateRow) {
                cell.detailTextLabel!.textColor = UIColor(white: 0, alpha: 0.5)
        }
        tableView.beginUpdates()
        tableView.reloadRowsAtIndexPaths([indexPathDateRow], withRowAnimation: .None)
        tableView.deleteRowsAtIndexPaths([indexPathDatePicker], withRowAnimation: .Fade)
        tableView.endUpdates()
        }
    }
    
//1.3 подготовка статической ячейки для DatePicker
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // если это ячейка 3 в секции 2 то....
            if indexPath.section == 1 && indexPath.row == 2 {
                var cell: UITableViewCell! = tableView.dequeueReusableCellWithIdentifier("DatePickerCell") as? UITableViewCell
                if cell == nil { cell = UITableViewCell(style: .Default, reuseIdentifier: "DatePickerCell")
                    cell.selectionStyle = .None
                
                    let datePicker = UIDatePicker(frame: CGRect(x: 0,
                                                                y: 0,
                                                            width: 320,
                                                           height: 216))
                    datePicker.tag = 100
                    cell.contentView.addSubview(datePicker)
                    // DatePicker вызывает метод dateChanged()
                    datePicker.addTarget(self, action: Selector("dateChanged:"), forControlEvents: .ValueChanged)
                }
                return cell
        // если нет то вызываем стандатрный метод и ячейки строятся из storyboard
            } else {
                return super.tableView(tableView, cellForRowAtIndexPath: indexPath)
            }
    }
//1.4 переназначение необходимых методов для tableView
    
//1.4.1 сообщаем tableViewDataSourse что у него в случае datePickerVisible = true в секции 1 будет 3 ряда
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 && datePickerVisible {
            return 3
        } else {
            return super.tableView(tableView, numberOfRowsInSection: section)
        }
    }
    
//1.4.2 при нажатии на ячейку с датой уведомления получаем indexPath с ее адресом
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
            if indexPath.section == 1 && indexPath.row == 1 {
                return indexPath
            } else {
                return nil
            }
    }
//1.4.3 настраиваем высоту ячейки с DatePicker
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
            if indexPath.section == 1 && indexPath.row == 2 {
            return 217
        } else {
            return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
            }
    }
    
//1.4.4 странный метод......
    override func tableView(tableView: UITableView, var indentationLevelForRowAtIndexPath indexPath: NSIndexPath)
    -> Int {
        if indexPath.section == 1 && indexPath.row == 2 {
            indexPath = NSIndexPath(forRow: 0, inSection: indexPath.section)
        }
        return super.tableView(tableView, indentationLevelForRowAtIndexPath: indexPath)
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
