//
//  DataModel.swift
//  Checklists
//
//  Created by Sergey Romaniuk on 22.01.15.
//  Copyright (c) 2015 Sergey Romaniuk. All rights reserved.
//

import Foundation
// Хранит чеклисты,
// Сохраняет чеклисты,
// Устанавливает дефолтные значения для ключей UserDefaults
// Получает и меняет данные в UserDefaults по ключу
// Создает тестовый чеклист при первом запуске
// Сортирует чеклисты

class DataModel {
    var lists = [Checklist]()
    
    init() {
        loadChecklists()
        registerDefaults()
        handleFirstTime()
    }
    
    // сохранение данных
    // построение пути к дериктории DocumentDirectory
    func documentsDirectory() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(
        .DocumentDirectory, .UserDomainMask, true) as [String]
        return paths[0]
    }
    // построение пути к файлу Checklists.plist
    func dataFilePath() -> String {
            return documentsDirectory().stringByAppendingPathComponent(
        "Checklists.plist")
    }
    // варианты потсроения пути к файлу
    //    func dataFilePath() -> String {
    //            let directory = documentsDirectory()
    //            return directory.stringByAppendingPathComponent("Checklists.plist")
    //    }
    //    func dataFilePath() -> String {
    //            return "\(documentsDirectory())/Checklists.plist"
    //    }
    
    // сохранение данных Чеклистов
    func saveChecklists() {
        let data = NSMutableData()
        
        //        NSKeyedArchiver, which is a form of NSCoder that creates plist files, encodes the
        //        array and all the ChecklistItems in it into some sort of binary data format that
        //        can be written to a file.
        //        That data is placed in an NSMutableData object, which will write itself to the file
        //        specified by dataFilePath.
        
        let archiver = NSKeyedArchiver(forWritingWithMutableData: data)
        archiver.encodeObject(lists, forKey: "Checklists")
        archiver.finishEncoding()
        data.writeToFile(dataFilePath(), atomically: true)
    }
    // восстановление данных Чеклистов
    func loadChecklists() {
        // Путь к файлу с сохраненными данными Checklists.plist
        let path = dataFilePath()
        // Если такой файл есть...
        if NSFileManager.defaultManager().fileExistsAtPath(path) {
            //  то....
            // получаем бинарные данные из файла
            if let data = NSData(contentsOfFile: path){
            // создаем распаковщик для данных
            let unarchiver = NSKeyedUnarchiver(forReadingWithData: data)
            // распаковываем с помощью NSKeyedUnarchiver в items
            lists = unarchiver.decodeObjectForKey("Checklists") as [Checklist]
            unarchiver.finishDecoding()
            } // сортируем чеклисты
            sortChecklists()
        }
    }
// Устанавливает дефолтные значения (при первой загрузке) в NSUserDefaults
    func registerDefaults() {
                let dictionary = [ "ChecklistIndex": -1,
                                        "FirstTime": true,
                                  "ChecklistItemID": 0]
                NSUserDefaults.standardUserDefaults().registerDefaults(dictionary)
    }
    
// метод сохранения индекса чек листа на котором закрыто приложение для открытия на нем при следующем запуске приложения. Оформлен в виде get/set т.е. indexOfSelectedChecklist() - получает индекс (get), а indexOfSelectedChecklist(1) устанавливает (set) индекс равный 1.
    var indexOfSelectedChecklist: Int {
        get {return NSUserDefaults.standardUserDefaults().integerForKey("ChecklistIndex")}
        set {NSUserDefaults.standardUserDefaults().setInteger(newValue, forKey: "ChecklistIndex")
             NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
// Проверка если приложение запущено в первый раз
    func handleFirstTime() {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let firstTime = userDefaults.boolForKey("FirstTime")
        if firstTime { // если стоит флаг что запущено в первый раз то...
            let checklist = Checklist(name: "List", iconName:"Appointments") // создаем пустой список с названием  List
            lists.append(checklist)
            indexOfSelectedChecklist = 0 // и переходим на него
            userDefaults.setBool(false, forKey: "FirstTime") // снимаем флаг что запущено в первый раз
        }
    }
// Сортировка чек листов по названию(Хер его знает как работает....)
    func sortChecklists() {
        lists.sort({ checklist1, checklist2 in return
        checklist1.name.localizedStandardCompare(checklist2.name) ==
        NSComparisonResult.OrderedAscending })
    }
// Создание нового уникального ItemID
    class func nextChecklistItemID() -> Int {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let itemID = userDefaults.integerForKey("ChecklistItemID")
        userDefaults.setInteger(itemID + 1, forKey: "ChecklistItemID")
        userDefaults.synchronize()
        return itemID
    }
    
}