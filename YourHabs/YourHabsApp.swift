import SwiftUI
import ComposableArchitecture

@main
struct YourHabsApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(store: Store(initialState: AppState(context: PersistenceController.shared.container.viewContext),
                                     reducer: appReducer,
                                     environment: AppEnvrionment(mainQueue: .main,
                                                                 managedObjectContext: PersistenceController.shared.container.viewContext,
                                                                 uuid: UUID.init)))
        }
    }
}
