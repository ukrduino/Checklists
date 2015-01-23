import Foundation


// Класс Item
// Сохраняется, восстанавливается
// Меняет свойство экземпляра checked


// NSObject - для поиска по массиву , NSCoding - для сохранения в файл с NSKeyedArchiver
class ChecklistItem: NSObject, NSCoding{
    
    var text = ""
    var checked = false
    
    
    convenience init(name: String) {
        
        self.init(name: name, isChecked: false)
    }
    
    init(name: String, isChecked: Bool) {
            self.text = name
            self.checked = isChecked
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
    }
    // восстанавливаем объекты из архива...
    required init(coder aDecoder: NSCoder) {
        text = aDecoder.decodeObjectForKey("Text") as String
        checked = aDecoder.decodeBoolForKey("Checked")
        super.init()
    }
    
}


