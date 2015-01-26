import Foundation


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
    
}


