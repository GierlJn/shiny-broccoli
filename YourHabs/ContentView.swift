import SwiftUI
import ComposableArchitecture
import CoreData

struct ContentView: View {
    var store: Store<Main.State, Main.Action>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            VStack {
                List {
                    ForEachStore(
                        self.store.scope(state: \.habits, action: Main.Action.habit(id:action:))
                    ) {
                        HabitView(store: $0)
                    }
                }
                Button {
                    viewStore.send(.addButtonTapped)
                } label: {
                    Text("delte")
                }
                
                .sheet(item: viewStore.binding(get: \.selectedHabit,
                                               send: Main.Action.setSelectedHabitSheet(habit:))) { _ in
                    IfLetStore(self.store.scope(state: \.selectedHabit, action: Main.Action.selectedHabit)) {
                        HabitDetailView(store: $0)
                    }
                }
            }
            .onAppear {
                viewStore.send(.onAppear)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(store: Store(initialState: Main.State(),
                                 reducer: Main.reducer,
                                 environment: Main.Environment.preview))
    }
}
