import SwiftUI
import ComposableArchitecture

@main
struct YourHabsApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(store: Store(initialState: Main.State(),
                                     reducer: Main.reducer,
                                     environment: Main.Environment.preview))
        }
    }
}
