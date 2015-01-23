// Из файла AllListsViewController.swift

//    required init(coder aDecoder: NSCoder) {
//        // Put values into your instance variables and constants.
//        // инициализируем пустой массив
//        lists = [Checklist]()
//        // 2
//        super.init(coder: aDecoder)
//
//        // Other initialization code, such as calling methods, goes here.
//        loadChecklists()
//
//// автозаполнение массива
////        var list = Checklist(name: "Birthdays")
////        lists.append(list)
////        list = Checklist(name: "Groceries")
////        lists.append(list)
////        list = Checklist(name: "Cool Apps")
////        lists.append(list)
////        list = Checklist(name: "To Do")
////        lists.append(list)
////        for list in lists {
////            if let index = find(lists, list) {
////                var ii : Int = index+1
////                    for r in 1...ii {
////                        let item = ChecklistItem()
////                        item.text = "Item № \(r) for \(list.name)"
////                        list.items.append(item)
////                }
////            }
////        }
//    }

