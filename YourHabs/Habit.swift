import SwiftUI
import ComposableArchitecture

struct Habit: Identifiable, Equatable {
    var name: String
    var id: UUID
    var finishedToday: Bool
    var iconName: String
    var time: Int
}

extension IdentifiedArray where Element == Habit, ID == Habit.ID {
    static let mock: Self = [
        Habit(name: "Meditation",
              id: UUID(uuidString: "DEADBEEF-DEAD-BEEF-DEAD-BEEDDEADBEEF")!,
              finishedToday: false,
              iconName: "face.smiling",
              time: 45),
        Habit(name: "Breathing",
              id: UUID(uuidString: "DEADBEEF-DEAD-CAFE-DEAD-BEEDDEADBEEF")!,
              finishedToday: false,
              iconName: "air.conditioner.horizontal.fill",
              time: 45)
    ]
}

enum HabitAction {
    case toggleFinish
    case undoFinish
}

struct HabitEnvrionment {}

let habitReducer = Reducer<Habit, HabitAction, HabitEnvrionment> { habit, action, _ in
    switch action {
    case .toggleFinish:
        habit.finishedToday.toggle()
        return .none
    case .undoFinish:
        habit.finishedToday.toggle()
        return .none
    }
}
