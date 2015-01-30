//
//  Checklist.swift
//  Checklists
//
//  Created by Sergey Romaniuk on 21.01.15.
//  Copyright (c) 2015 Sergey Romaniuk. All rights reserved.
//

import UIKit

// Класс чеклиста
// Сохраняется, восстанавливается
// подсчитывает свои несделанные(Unchecked) Items

// NSObject - для поиска по массиву , NSCoding - для сохранения в файл с NSKeyedArchiver
class Checklist: NSObject, NSCoding {
    var name = ""
    var items: [ChecklistItem] = [ChecklistItem]()
    var iconName: String
    
    convenience init(name: String) {
        self.init(name: name, iconName: "No Icon")
    }
    
    init(name: String, iconName: String) {
        self.name = name
        self.iconName = iconName
        super.init()

    }
// для восстановления объекта
    required init(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObjectForKey("Name") as String
        items = aDecoder.decodeObjectForKey("Items") as [ChecklistItem]
        iconName = aDecoder.decodeObjectForKey("IconName") as String
        super.init()
    }
// для сохранения объекта
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(name, forKey: "Name")
        aCoder.encodeObject(items, forKey: "Items")
        aCoder.encodeObject(iconName, forKey: "IconName")
    }
// Подсчет несделанных(Unchecked) Items
    func countUncheckedItems() -> Int {
        var count = 0
        for item in items {
            if !item.checked {
                count += 1
            }
        }
        return count
    }

// Сортировка чек листов по названию(Хер его знает как работает....2)
    func sortChecklistItems() {
        items.sort({checklistItem1 , checklistItem2 in return
        checklistItem1.dueDate.compare(checklistItem2.dueDate) ==
        NSComparisonResult.OrderedAscending })
    }
    
   
}
