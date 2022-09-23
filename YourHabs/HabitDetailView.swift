import SwiftUI
import ComposableArchitecture

struct HabitDetailView: View {
    var store: Store<HabitState, HabitAction>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            VStack {
                Text(viewStore.habit.safeName)
                Button {
                    viewStore.send(.deleteHabit)
                } label: {
                    Text("Delete")
                }
            }
        }
    }
}

struct HabitDetailView_Previews: PreviewProvider {
    static var previews: some View {
        HabitDetailView(store: Store(initialState: HabitState(context: .mocked, habit: Habit(context: .mocked)),
                               reducer: habitReducer,
                                     environment: Main.Environment.preview))
    }
}
