import SwiftUI
import ComposableArchitecture
import CoreData

struct AppState: Equatable {
    var habits: IdentifiedArrayOf<HabitState> = []
    var needsUpdate = false
    init(context: NSManagedObjectContext) {
        do {
            let coreDataHabits = try context.fetch(Habit.fetchRequest())
            for habit in coreDataHabits {
                habits.append(HabitState(context: context, habit: habit))
            }
        } catch {
            fatalError("error loading coredata habits")
        }
        
    }
}

enum AppAction: Equatable {
    case addButtonTapped
    case delete(IndexSet)
    case habit(id: HabitState.ID, action: HabitAction)
    case onAppear
}

struct AppEnvrionment {
    var mainQueue: AnySchedulerOf<DispatchQueue>
    let managedObjectContext: NSManagedObjectContext
    var uuid: () -> UUID
}

let appReducer = Reducer<AppState, AppAction, AppEnvrionment>.combine(
    habitReducer.forEach(state: \.habits,
                         action: /AppAction.habit(id:action:),
                         environment: { $0 }
                        ),
    Reducer { state, action, environment in
        switch action {
        case .addButtonTapped:
            return .none
        case .delete(let indexSet):
            state.habits.remove(atOffsets: indexSet)
            return .none
        case .habit(id: _, action: _):
            return .none
        case .onAppear:
            do {
                try MockSeeder.shared.seed(context: environment.managedObjectContext)
                state.needsUpdate.toggle()
            } catch {
                fatalError("mockseeder failed sesding")
            }
            
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
            .onAppear {
                viewStore.send(.onAppear)
            }
        }
        .debug()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(store: Store(initialState: AppState(context: PersistenceController.mocked.container.viewContext),
                                 reducer: appReducer,
                                 environment: AppEnvrionment(mainQueue: .main,
                                                             managedObjectContext: PersistenceController.mocked.container.viewContext,
                                                             uuid: UUID.init)))
    }
}
