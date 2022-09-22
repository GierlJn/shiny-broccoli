import CoreData

extension NSManagedObjectContext {
   #if DEBUG
      public static var mocked: NSManagedObjectContext {
         let context = PersistenceController.mocked.container.viewContext
         try! MockSeeder.shared.seed(context: context)
         return context
      }
   #endif
}

public final class MockSeeder {
   public static let shared = MockSeeder()

   public func seed(context: NSManagedObjectContext) throws {
      let habitsAreEmpty = try context.count(for: Habit.fetchRequest()) == 0

      if habitsAreEmpty {
          _ = Habit(context: context,
                    name: "Meditation",
                    id: UUID(uuidString: "DEADBEEF-DEAD-BEEF-DEAD-BEEDDEADBEEF")!,
                    iconName: "person",
                    entries: Set<DayEntry>())
          
          _ = Habit(context: context,
                    name: "Jogging",
                    id: UUID(uuidString: "DEADBEEF-DEAD-BEEF-CAFE-BEEDDEADBEEF")!,
                    iconName: "person",
                    entries: Set<DayEntry>())
          
         try context.save()
      }
   }
}
