//
//  ChecklistsViewController.swift
//  Checklists
//
//  Created by Sergey Romaniuk on 17.01.15.
//  Copyright (c) 2015 Sergey Romaniuk. All rights reserved.
//

import UIKit


// Создает/получает массив ChecklistItem для конкретного чеклиста
// Добавляет и редактирует(название) Item
// Проставляет чекмарк (сделано) с помощью ChecklistItem.toggleChecked()
// Удаляет Item



class ChecklistsViewController: UITableViewController, itemDetailViewControllerDelegate{
    
    // создаваемый/редактируемый чеклист
    var checklist: Checklist!
    // его Itemы
    var items: [ChecklistItem]
    
    
    
    required init(coder aDecoder: NSCoder) {
        items = [ChecklistItem]()
        
        super.init(coder: aDecoder)

    }

// настройка окна чеклиста (Заголовок)
    override func viewDidLoad() {
        super.viewDidLoad()
        title = checklist.name
        tableView.rowHeight = 44

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


// количество строк в таблице...
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

         // как количество записей в массиве
        return checklist.items.count
        
    }

// конфигурация ячейки
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // переиспользовать ячейки с Identifier("ChecklistItem")
        let cell = tableView.dequeueReusableCellWithIdentifier("ChecklistItem") as UITableViewCell

        // получаем запись из массива с номером равным indexPath.row запрашиваемой ячейки
        let item = checklist.items[indexPath.row]
        // пишем текст в ячейку
        configureTextForCell(cell, withChecklistItem: item)
        // проставляем чекмарк
        configureCheckmarkForCell(cell, withChecklistItem: item)
        return cell
    }
    
// проставляем чекмарк в (отображение его в таблице)...
    func configureCheckmarkForCell(cell: UITableViewCell,
        withChecklistItem item: ChecklistItem) {
        // в переданной в метод ячейке ищем надпись с Tag(1001)
        let label = cell.viewWithTag(1001) as UILabel
            label.textColor = view.tintColor
        // а в переданном в метод объекте смотрим поле checked и если оно true то...
        if item.checked {
            label.text = "✓"
        } else {
            label.text = ""
        }
    }
        
// пишем текст в ячейку...
    func configureTextForCell(cell: UITableViewCell,
            withChecklistItem item: ChecklistItem) {
        // в переданной в метод ячейке ищем надпись с Tag(1000)
        let label = cell.viewWithTag(1000) as UILabel
        label.text = item.text
    }

// отмечает и снимает отметку с ячейки
    override func tableView(tableView: UITableView,
    didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // получаем ячейку по indexPath-у
        if let cell = tableView.cellForRowAtIndexPath(indexPath) {
            // получаем объект из массива по indexPath.row
            let item = checklist.items[indexPath.row]
                // вызываем метод объекта toggleChecked()
                item.toggleChecked()
                // обновляем таблицу
                tableView.reloadData()
            }
            
            // снимаем выделение с ячейки
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
 
    }


// методы делегата itemDetailViewController
    
// обработка нажатия на Cancel
    func itemDetailViewControllerDidCancel(controller: ItemDetailViewController) {
 
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
// обработка нажатия на Done при создании нового Item
    func itemDetailViewController(controller: ItemDetailViewController,
                    didFinishAddingItem item: ChecklistItem) {
        checklist.items.append(item)
        
 
        dismissViewControllerAnimated(true, completion: nil)
    }
    
// обработка нажатия на Done при редактировании Itema
    func itemDetailViewController(controller: ItemDetailViewController,
                didFinishEditingItem item: ChecklistItem) {
        // по объекту находим его индекс в массиве
        if let index = find(checklist.items, item) { // Returns the first index where `value` appears in `domain`
            // создаем indexPath с номером ряда соответствующим индексу объекта массиве
            let indexPath = NSIndexPath(forRow: index, inSection: 0)
            // оплучаем ячейку по данному indexPath-у
            if let cell = tableView.cellForRowAtIndexPath(indexPath) {
                // меняем текст в ячейке используя метод как при первом создании ячейки
                configureTextForCell(cell, withChecklistItem: item)
            }
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    
// удаление записи
    override func tableView(tableView: UITableView,
        commitEditingStyle editingStyle: UITableViewCellEditingStyle,
        forRowAtIndexPath indexPath: NSIndexPath) {
            checklist.items.removeAtIndex(indexPath.row)
            // красиво удаляет строчку
            let indexPaths = [indexPath]
            tableView.deleteRowsAtIndexPaths(indexPaths,
                withRowAnimation: .Automatic)
            
    }

// передача данных при переходе на другой контроллер
    override func prepareForSegue(segue: UIStoryboardSegue,
                                 sender: AnyObject!) {
        // ищем переход по идентификатору
        if segue.identifier == "AddItem" {
            // ищем в переходе конечный контроллер (это в данном случае navigationController)
            let navigationController = segue.destinationViewController as UINavigationController
            // в navigationController ищем встроенный в него ItemDetailViewController
            let controller = navigationController.topViewController as ItemDetailViewController
            // устанавливаем его свойство делегат себя (ChecklistsViewController)
            controller.delegate = self
        } // тоже что и выше...
        else if segue.identifier == "EditItem" {
            let navigationController = segue.destinationViewController as UINavigationController
            let controller = navigationController.topViewController as ItemDetailViewController
            controller.delegate = self
            // плюс ....
            // получаем индекс (номер записи item в массиве items), он соответствует indexPath-у
            // ячейки которая инициировала переход (т.е. является sender данного метода)
            // т.е обращаемся к tableView той ячейки (sender) и спрашиваем ее indexPathForCell...
            // если его получаем то выбираем в массиве items запись с номером indexPath.row и 
            // передаем в свойство itemToEdit ItemDetailViewController
            if let indexPath = tableView.indexPathForCell(sender as UITableViewCell) {
                controller.itemToEdit = checklist.items[indexPath.row]
            }
        }
    }

}
