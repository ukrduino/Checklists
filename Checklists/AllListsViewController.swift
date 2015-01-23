//
//  AllListsViewController.swift
//  Checklists
//
//  Created by Sergey Romaniuk on 21.01.15.
//  Copyright (c) 2015 Sergey Romaniuk. All rights reserved.
//



import UIKit

// стартовый экран на котором представлен список всех чеклистов
// добавляет, редактирует чеклисты вызывая ListDetailViewController
// удаляет чеклисты из DataModel.lists
//
class AllListsViewController: UITableViewController, ListDetailViewControllerDelegate, UINavigationControllerDelegate{

// Получает ссылку на созданный в AppDelegate экземпляр класса DataModel
    var dataModel: DataModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
// Переход после загрузки основного экрана на тот чеклист который был открыт при последнем закрытии приложения
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.delegate = self
        let index = dataModel.indexOfSelectedChecklist
            if index >= 0 && index < dataModel.lists.count {
                let checklist = dataModel.lists[index]
                performSegueWithIdentifier("ShowChecklist", sender: checklist)
            }
        tableView.reloadData()
    }
    
// строк в таблице - количество списков
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return dataModel.lists.count
    }

// конфигурация ячейки
    override func tableView(tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "Cell"
        let checklist = dataModel.lists[indexPath.row]
        var cell: UITableViewCell! = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? UITableViewCell
        if cell == nil {cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellIdentifier)
        }
        cell.textLabel!.text = checklist.name
        cell.accessoryType = .DetailDisclosureButton
        cell.imageView!.image = UIImage(named: checklist.iconName)
        let itemsCount = checklist.items.count
            if itemsCount == 0 {
                cell.detailTextLabel!.text = "Empty list 😕"
            }
            else{
                let countRemaining = checklist.countUncheckedItems()
                if countRemaining == 0 {
                    cell.detailTextLabel!.text = "All Done! 😃"
                }
                else{
                    cell.detailTextLabel!.text = "\(countRemaining) Remaining"
                }
            }
        return cell
    }

// переход на список
    override func tableView(tableView: UITableView,
        didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // установка индекса списка на который переходим (для поледующего открытия его при повторном открытии приложения, если закрыть приложение на этом списке)
        dataModel.indexOfSelectedChecklist = indexPath.row
        let checklist = dataModel.lists[indexPath.row]
        performSegueWithIdentifier("ShowChecklist", sender: checklist)
            
            
    }
    
// Будучи делегатом (UINavigationControllerDelegate) при переходе с чеклиста на общий список чеклистов...
    func navigationController(navigationController: UINavigationController,
                willShowViewController viewController: UIViewController,
                animated: Bool) {
        // проверяем если переходим (возвращаемся) именно на AllListsViewController т.е. self
        if viewController === self {
            // устанавливаем индекс списка равный -1
            dataModel.indexOfSelectedChecklist = -1
        }
    }
    
// Удаление чеклиста (Swipe to Delete)
    override func tableView(tableView: UITableView,
        commitEditingStyle editingStyle: UITableViewCellEditingStyle,
        forRowAtIndexPath indexPath: NSIndexPath) {
        dataModel.lists.removeAtIndex(indexPath.row)
        let indexPaths = [indexPath]
        tableView.deleteRowsAtIndexPaths(indexPaths,
            withRowAnimation: .Automatic)
}
// при подготовке перехода (Segue)
    override func prepareForSegue(segue: UIStoryboardSegue,
        sender: AnyObject!) {
            // если переходим на просмотр чеклиста
        if segue.identifier == "ShowChecklist" {
            let controller = segue.destinationViewController as ChecklistsViewController
            // то передаем чеклист (с ячейки на которую нажали) в ChecklistsViewController для отображения
            controller.checklist = sender as Checklist
        }  // если переходим на добавить чеклист (с кнопки плюс)
        else if segue.identifier == "AddChecklist" {
            let navigationController = segue.destinationViewController
            as UINavigationController
            let controller = navigationController.topViewController
            as ListDetailViewController
            // становимся делегатом ListDetailViewController (и будем выполнять его команды см. 2 метода ниже: listDetailViewControllerDidCancel, )
            controller.delegate = self
            controller.checklistToEdit = nil
        }
    }
    
// методы делегата ListDetailViewController
    
// обработка нажатия на Cancel в ListDetailViewController
    func listDetailViewControllerDidCancel(
        controller: ListDetailViewController) {
        dismissViewControllerAnimated(true, completion: nil)
    }

// обработка нажатия на Done при создании нового чеклиста в ListDetailViewController
    func listDetailViewController(controller: ListDetailViewController,
        didFinishAddingChecklist checklist: Checklist) {
       dataModel.lists.append(checklist)
       dataModel.sortChecklists()
       tableView.reloadData()
       dismissViewControllerAnimated(true, completion: nil)
    }
    
// обработка нажатия на Done при редактировании чеклиста в ListDetailViewController
    func listDetailViewController(controller: ListDetailViewController,
        didFinishEditingChecklist checklist: Checklist) {
        dataModel.sortChecklists()
        tableView.reloadData()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
// обработка нажатия на кнопку редактирования accessoryButtonTapped
    override func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        // получаем навигац контроллер с storyboardID = "ListNavigationController"...
        let navigationController = storyboard!.instantiateViewControllerWithIdentifier("ListNavigationController") as UINavigationController
        // получаем из него ListDetailViewController
        let controller = navigationController.topViewController as ListDetailViewController
        // становимся его делегатом
        controller.delegate = self
        // получаем чеклист на котором нажали кнопочку....
        let checklist = dataModel.lists[indexPath.row]
        // передаем его в свойство checklistToEdit
        controller.checklistToEdit = checklist
        presentViewController(navigationController, animated: true,
        completion: nil)
    }
    
}
