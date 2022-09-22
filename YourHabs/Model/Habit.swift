import Foundation
import CoreData

@objc(Habit)
public class Habit: NSManagedObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Habit> {
        return NSFetchRequest<Habit>(entityName: "Habit")
    }

    @NSManaged public var name: String?
    @NSManaged public var id: UUID?
    @NSManaged public var iconName: String?
    @NSManaged public var entries: Set<DayEntry>?
    var context: NSManagedObjectContext?
    
    convenience init(context: NSManagedObjectContext, name: String, id: UUID, iconName: String, entries: Set<DayEntry>) {
        self.init(context: context)
        self.context = context
        self.name = name
        self.id = id
        self.iconName = iconName
        self.entries = entries
    }
}

// MARK: Generated accessors for entries
extension Habit {
    @objc(addEntriesObject:)
    @NSManaged public func addToEntries(_ value: DayEntry)

    @objc(removeEntriesObject:)
    @NSManaged public func removeFromEntries(_ value: DayEntry)

    @objc(addEntries:)
    @NSManaged public func addToEntries(_ values: NSSet)

    @objc(removeEntries:)
    @NSManaged public func removeFromEntries(_ values: NSSet)
}

extension Habit : Identifiable {
    var identifier: UUID {
        self.id!
    }
}

extension Habit {
    var safeName: String {
        self.name ?? "N/A"
    }
    
    var safeEntries: Set<DayEntry> {
        self.entries ?? Set<DayEntry>()
    }
    
    var currentDayEntry: DayEntry? {
        safeEntries.first(where: { $0.safeDate == Calendar.current.startOfCurrentDay })
    }
    
    func setFinishToday() {
        currentDayEntry?.isDoneToday = true
    }
    
    func removeFinishToday() {
        currentDayEntry?.isDoneToday = false
    }
}
