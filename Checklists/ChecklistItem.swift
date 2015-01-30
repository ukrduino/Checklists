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
    
    func scheduleNotification() {
        let existingNotification = notificationForThisItem()
        if let notification = existingNotification {
            println("Removing existing notification \(notification)")
            UIApplication.sharedApplication().cancelLocalNotification(notification)
        }
        if shouldRemind && dueDate.compare(NSDate()) != NSComparisonResult.OrderedAscending {
            let localNotification = UILocalNotification()
            localNotification.fireDate = dueDate
            localNotification.timeZone = NSTimeZone.defaultTimeZone()
            localNotification.alertBody = text
            localNotification.soundName = UILocalNotificationDefaultSoundName
            localNotification.userInfo = ["ItemID": itemID]
            UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
            println("Scheduled notification \(localNotification) for itemID \(itemID)")
        }
    }
    
    func notificationForThisItem() -> UILocalNotification? {
        let allNotifications = UIApplication.sharedApplication().scheduledLocalNotifications as [UILocalNotification]
        for notification in allNotifications {
            if let number = notification.userInfo?["ItemID"] as? NSNumber {
                if number.integerValue == itemID {
                return notification
                }
            }
        }
        return nil
    }
}


