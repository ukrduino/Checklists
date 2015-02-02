import Foundation
import UIKit


// Класс Item
// Сохраняется, восстанавливается
// Меняет свойство экземпляра checked


// NSObject - для поиска по массиву , NSCoding - для сохранения в файл с NSKeyedArchiver
class ChecklistItem: NSObject, NSCoding{
    
    var text = ""
    var checked = false
    var dueDate = NSDate()
    var shouldRemind = false
    var itemID: Int
    
    
    convenience init(name: String) {
        
        self.init(name: name, isChecked: false)
    }
    
    init(name: String, isChecked: Bool) {
            self.text = name
            self.checked = isChecked
            itemID = DataModel.nextChecklistItemID()
            println(itemID)
            super.init()
    }
// удаляем уведомление при удалении объекта
    deinit {
        let existingNotification = notificationForThisItem()
        if let notification = existingNotification {
            println("Removing existing notification \(notification)")
            UIApplication.sharedApplication().cancelLocalNotification(notification)
        }
    }
    
    
// переключение чекмарка
    func toggleChecked() {
        checked = !checked
    }
    
    // сохранение свойств объекта...
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(text, forKey: "Text")
        aCoder.encodeBool(checked, forKey: "Checked")
        aCoder.encodeObject(dueDate, forKey: "DueDate")
        aCoder.encodeBool(shouldRemind, forKey: "ShouldRemind")
        aCoder.encodeInteger(itemID, forKey: "ItemID")
        
    }
    // восстанавливаем объекты из архива...
    required init(coder aDecoder: NSCoder) {
        text = aDecoder.decodeObjectForKey("Text") as String
        checked = aDecoder.decodeBoolForKey("Checked")
        dueDate = aDecoder.decodeObjectForKey("DueDate") as NSDate
        shouldRemind = aDecoder.decodeBoolForKey("ShouldRemind")
        itemID = aDecoder.decodeIntegerForKey("ItemID")
        super.init()
    }
// создание LocalNotification:

    func scheduleNotification() {
// проверка есть ли LocalNotification для данного объекта с помощью метода notificationForThisItem()
        let existingNotification = notificationForThisItem()
// если есть то его удалаяем
        if let notification = existingNotification {
            println("Removing existing notification \(notification)")
            UIApplication.sharedApplication().cancelLocalNotification(notification)
        }
// создание свеженького LocalNotification -  если стоит отметка о его созаднии и дата выбранная на Date Pickere позже чем сейчас то...

        if shouldRemind && dueDate.compare(NSDate()) != NSComparisonResult.OrderedAscending {
// создаем новое LocalNotification
            let localNotification = UILocalNotification()
            localNotification.fireDate = dueDate
            localNotification.timeZone = NSTimeZone.defaultTimeZone()
            localNotification.alertBody = text
            localNotification.soundName = UILocalNotificationDefaultSoundName
// в его userInfo пишем к какому item он имеет отношение
            localNotification.userInfo = ["ItemID": itemID]
// регистрируем в системе
            UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
            println("Scheduled notification \(localNotification) for itemID \(itemID)")
        }
    }
// поиск LocalNotification для Item
    func notificationForThisItem() -> UILocalNotification? {
// получаем из системы массив всех существующих UILocalNotification...
        let allNotifications = UIApplication.sharedApplication().scheduledLocalNotifications as [UILocalNotification]
        for notification in allNotifications {
            // если в userInfo есть словарь с ключем ItemID и из него удалось получить itemID
            if let number = notification.userInfo?["ItemID"] as? NSNumber {
                // если он соответсвует itemID данного объекта ChecklistItem..
                if number.integerValue == itemID {
                    // передаем его 
                    return notification
                }
            }
        }
        return nil
    }
}


