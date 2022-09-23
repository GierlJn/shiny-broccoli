import ComposableArchitecture
import CoreData

struct Main {
    struct State: Equatable {
        var habits: IdentifiedArrayOf<HabitState> = []
    }

    enum Action: Equatable {
        case onAppear
        case habit(id: UUID, action: HabitAction)
        case addButtonTapped
    }

    struct Environment {
        var mainQueue: AnySchedulerOf<DispatchQueue>
        var context: NSManagedObjectContext
        var uuid: () -> UUID
        
        static let preview = Environment(mainQueue: .main,
                                         context: NSManagedObjectContext.mocked,
                                            uuid: UUID.init)
    }

    static var reducer = Reducer<State, Action, Environment>.init { state, action, env in
        switch action {
        case .onAppear:
            return fetchHabits(state: &state, env: env)
        case .habit(id: let id, action: let action):
            return .none
        case .addButtonTapped:
            return .none
        }
    }
    
    private static func fetchHabits(state: inout State, env: Environment) -> Effect<Action, Never> {
        do {
            let fetchedHabits = try env.context.fetch(Habit.fetchRequest())
            let habitsStates = fetchedHabits.map { HabitState(context: env.context, habit: $0) }
            state.habits = IdentifiedArrayOf(uniqueElements: habitsStates)
        } catch {
            return .none
        }
        return .none
    }
}
