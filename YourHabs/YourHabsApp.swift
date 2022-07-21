import SwiftUI
import ComposableArchitecture

@main
struct YourHabsApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(store: Store(initialState: AppState(habits: .mock),
                                     reducer: appReducer,
                                     environment: AppEnvrionment(mainQueue: .main,
                                     uuid: UUID.init)))
        }
    }
}
