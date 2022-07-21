import SwiftUI
import ComposableArchitecture

struct AppState: Equatable {
    var habits: IdentifiedArrayOf<Habit> = []
}

enum AppAction: Equatable {
    case addButtonTapped
    case delete(IndexSet)
    case habit(id: Habit.ID, action: HabitAction)
}

struct AppEnvrionment {
    var mainQueue: AnySchedulerOf<DispatchQueue>
    var uuid: () -> UUID
}

let appReducer = Reducer<AppState, AppAction, AppEnvrionment>.combine(
    habitReducer.forEach(state: \.habits,
                         action: /AppAction.habit(id:action:),
                         environment: { _ in HabitEnvrionment()}),
    Reducer { state, action, environment in
        switch action {
        case .addButtonTapped:
            return .none
        case .delete(let indexSet):
            state.habits.remove(atOffsets: indexSet)
            return .none
        case .habit(id: _, action: _):
            return .none
        }
        
    }
)

struct ContentView: View {
    var store: Store<AppState, AppAction>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            VStack {
                List {
                    ForEachStore(
                        self.store.scope(state: \.habits, action: AppAction.habit(id:action:))
                    ) {
                        HabitView(store: $0)
                            
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(store: Store(initialState: AppState(habits: .mock),
                                 reducer: appReducer,
                                 environment: AppEnvrionment(mainQueue: .main,
                                                             uuid: UUID.init)))
    }
}
