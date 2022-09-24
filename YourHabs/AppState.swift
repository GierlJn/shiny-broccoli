import ComposableArchitecture
import CoreData

struct Main {
    struct State: Equatable {
        var habits: IdentifiedArrayOf<HabitState> = []
        var selectedHabit: HabitState?
        var isHabitDetailSheetActive: Bool { self.selectedHabit != nil }
    }

    enum Action: Equatable {
        case onAppear
        case habit(id: UUID, action: HabitAction)
        case selectedHabit(HabitAction)
        case addButtonTapped
        case setSelectedHabitSheet(habit: HabitState?)
        case setTest(isActive: Bool)
    }

    struct Environment {
        var mainQueue: AnySchedulerOf<DispatchQueue>
        var context: NSManagedObjectContext
        var uuid: () -> UUID
        
        static let preview = Environment(mainQueue: .main,
                                         context: NSManagedObjectContext.mocked,
                                            uuid: UUID.init)
    }

    static var reducer = Reducer.combine(
        habitReducer
            .optional()
            .pullback(state: \.selectedHabit,
                      action: /Action.selectedHabit,
                      environment: { $0 }),
        habitReducer.forEach(state: \.habits,
                             action: /Action.habit(id:action:),
                             environment: { $0 }),
        Reducer<State, Action, Environment>.init { state, action, env in
            switch action {
            case .onAppear:
                return fetchHabits(state: &state, env: env)
            case .habit(id: let id, action: .showDetail):
                guard let selected = state.habits.first(where: {$0.id == id}) else {
                    return .none
                }
                return Effect(value: .setSelectedHabitSheet(habit: selected))
            case .addButtonTapped:
                return .none
            case .setSelectedHabitSheet(habit: let habit):
                state.selectedHabit = habit
                return .none
            default:
                return .none
            }
            return Effect.none
        }
    )

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
