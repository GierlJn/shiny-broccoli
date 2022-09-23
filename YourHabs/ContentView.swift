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
//                .sheet(isPresented: viewStore.binding(get: { $0.showDetail },
//                                                      send: AppAction.showDetail)) {
//                    HabitDetailView(store: store)
//                }

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
