import Foundation

// NSObject - для поиска по массиву , NSCoding - для сохранения в файл с NSKeyedArchiver

class ChecklistItem: NSObject, NSCoding{
    var text = ""
    var checked = false
    // переключение чекмарка
    func toggleChecked() {
        checked = !checked
    }
    // сохранение свойств объекта...
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(text, forKey: "Text")
        aCoder.encodeBool(checked, forKey: "Checked")
    }
    // восстанавливаем объекты из архива...
    required init(coder aDecoder: NSCoder) {
        text = aDecoder.decodeObjectForKey("Text") as String
        checked = aDecoder.decodeBoolForKey("Checked")
        super.init()
    }
    override init() {
        super.init()
    }
}