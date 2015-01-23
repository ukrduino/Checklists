//
//  ListDetailViewController.swift
//  Checklists
//
//  Created by Sergey Romaniuk on 21.01.15.
//  Copyright (c) 2015 Sergey Romaniuk. All rights reserved.
//

import UIKit


// показывает свойства чеклиста (редактирует)
// создает новый чеклист

// протокол делегата ListDetailViewController
protocol ListDetailViewControllerDelegate: class {
    // обработка нажатия на Cancel
    func listDetailViewControllerDidCancel(
    controller: ListDetailViewController)
    // обработка нажатия на Done при создании нового чеклиста
    func listDetailViewController(controller: ListDetailViewController,
    didFinishAddingChecklist checklist: Checklist)
    // обработка нажатия на Done при редактировании чеклист
    func listDetailViewController(controller: ListDetailViewController,
    didFinishEditingChecklist checklist: Checklist)
}
class ListDetailViewController: UITableViewController, UITextFieldDelegate, IconPickerViewControllerDelegate{
    
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    
    @IBOutlet weak var iconImageView: UIImageView!
    
    weak var delegate: ListDetailViewControllerDelegate?
    
    var checklistToEdit: Checklist?
    
    var iconName = "Folder"
    
    @IBAction func cancel() {
        delegate?.listDetailViewControllerDidCancel(self)
    }
    
    @IBAction func done() {
        if let checklist = checklistToEdit {
            checklist.name = textField.text
            checklist.iconName = iconName
            delegate?.listDetailViewController(self,
            didFinishEditingChecklist: checklist)
        }
        else {
            let checklist = Checklist(name: textField.text)
            delegate?.listDetailViewController(self, didFinishAddingChecklist: checklist)
        }
    }
// подготовка окна (перелючение Add/Edit)
    override func viewDidLoad() {
        super.viewDidLoad()
        // если при вызове ListDetailViewController в переменную checklistToEdit передали чеклист который редактировать то название окна будет Edit Checklist
        if let checklist = checklistToEdit {
            title = "Edit Checklist"
            // и в тектовом поле будет название чеклиста
            textField.text = checklist.name
            iconName = checklist.iconName
        
        }
        iconImageView.image = UIImage(named: iconName)
    }
    
// активизация поля для ввода текста
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
    }
    
// запрет выбора текстового поля в ячейке (выделения его) и разрешение нажатия на ячейке с иконкой для выбора иконки
    override func tableView(tableView: UITableView,
        willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        if indexPath.section == 1 {
        return indexPath
    } else {
        return nil
        }
    }

// проверка наличия текста в текстовом поле перед сохранением и активизация кнопки Done
    func textField(textField: UITextField,
        shouldChangeCharactersInRange range: NSRange,
                   replacementString string: String) -> Bool {
        let oldText: NSString = textField.text
        let newText: NSString = oldText.stringByReplacingCharactersInRange(
        range, withString: string)
        doneBarButton.enabled = (newText.length > 0)
        return true
    }
    
// при подготовке к переходу на экрен выбора иконки (IconPickerViewController)
// self становится делегатом IconPickerViewController
    override func prepareForSegue(segue: UIStoryboardSegue,
            sender: AnyObject!) {
            if segue.identifier == "PickIcon" {
            let controller = segue.destinationViewController as IconPickerViewController
                controller.delegate = self
            }
    }

// метод делегата IconPickerViewController
    
// принимая от IconPickerViewController указание сменить иконку с именем иконки
    func iconPicker(picker: IconPickerViewController, didPickIcon iconName: String){
            // передает имя иконки в переменную  self.iconName из которой потом при нажатии кнопки Done
            // имя передается в свойство редактируемого/создаваемого чеклиста
            self.iconName = iconName
            iconImageView.image = UIImage(named: iconName)
            navigationController?.popViewControllerAnimated(true)
    
    }
	}