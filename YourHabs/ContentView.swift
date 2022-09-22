import SwiftUI
import ComposableArchitecture
import CoreData

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
                Button {
                    viewStore.send(.addButtonTapped)
                } label: {
                    Text("delte")
                }
            
//
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
        ContentView(store: Store(initialState: AppState(context: PersistenceController.mocked.container.viewContext),
                                 reducer: appReducer,
                                 environment: AppEnvrionment(mainQueue: .main,
                                                             managedObjectContext: PersistenceController.mocked.container.viewContext,
                                                             uuid: UUID.init)))
    }
}
