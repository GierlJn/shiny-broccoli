import SwiftUI
import ComposableArchitecture
import CoreData

struct HabitState: Identifiable, Equatable {
    var context: NSManagedObjectContext
    var habit: Habit
    var id: UUID {
        habit.identifier
    }
    var needsRefresh = false
    var isDoneToday: Bool {
        return habit.currentDayEntry?.isDoneToday ?? false
    }
}

enum HabitAction {
    case toggleFinish
    case undoFinish
    case showDetail
    case deleteHabit
}

let habitReducer = Reducer<HabitState, HabitAction, AppEnvrionment> { state, action, env in
    switch action {
    case .toggleFinish:
        setCurrentDayIfNeeded()
        state.habit.setFinishToday()
        saveContext()
        state.needsRefresh.toggle()
        return .none
    case .undoFinish:
        state.habit.removeFinishToday()
        saveContext()
        state.needsRefresh.toggle()
        return .none
    case .showDetail:
        //state.showDetail.toggle()
        return .none
    case .deleteHabit:
        return .none
    }
    
    func setCurrentDayIfNeeded() {
        if state.habit.currentDayEntry == nil {
            state.habit.addToEntries(DayEntry(context: state.context, habit: state.habit))
        }
    }
    
    func saveContext() {
        do {
            try env.managedObjectContext.save()
        } catch {
            fatalError()
        }
    }
}
