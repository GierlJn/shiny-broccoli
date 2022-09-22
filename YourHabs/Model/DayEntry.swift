import Foundation
import CoreData

@objc(DayEntry)
public class DayEntry: NSManagedObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<DayEntry> {
        return NSFetchRequest<DayEntry>(entityName: "DayEntry")
    }

    @NSManaged public var timeDone: Int64
    @NSManaged public var date: Date?
    @NSManaged public var habit: Habit?
    @NSManaged public var isDoneToday: Bool
    
    convenience init(context: NSManagedObjectContext, timeDone: Int = 0, date: Date = Calendar.current.startOfCurrentDay, habit: Habit, isDoneToday: Bool = false) {
        self.init(context: context)
        self.timeDone = Int64(timeDone)
        self.date = date
        self.habit = habit
        self.isDoneToday = isDoneToday
        do {
            try context.save()
        } catch {
            fatalError("error saving dayentry")
        }
    }
}

extension DayEntry : Identifiable {
    public var id: Date {
        self.date!
    }
}

extension DayEntry {
    var safeDate: Date {
        self.date ?? Calendar.current.startOfCurrentDay
    }

}
