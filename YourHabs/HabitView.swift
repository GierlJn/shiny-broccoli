import SwiftUI
import ComposableArchitecture

struct HabitView: View {
    var store: Store<Habit, HabitAction>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            HStack {
                Image(systemName: "face.smiling")
                    .resizable()
                    .frame(width: 50, height: 50)
                Text(viewStore.name)
                    .strikethrough(viewStore.finishedToday)
                Spacer()
                VStack {
                    Image(systemName: "clock.fill")
                    Text(String(viewStore.time) + "m")
                }
            }
            .opacity(viewStore.finishedToday ? 0.5 : 1.0)
            .swipeActions(edge: .leading) {
                Button {
                    viewStore.send(.toggleFinish)
                } label: {
                    Image(systemName: "checkmark")
                }
                .tint(.indigo)
            }
            .if(viewStore.finishedToday, transform: { view in
                view
                    .swipeActions(edge: .trailing) {
                    Button {
                        viewStore.send(.undoFinish)
                    } label: {
                        Text("Undo")
                    }
                    .tint(.red)
                }
            })
            
            .padding()
        }
    }
}

struct HabitView_Previews: PreviewProvider {
    static var previews: some View {
        HabitView(store: Store(initialState: Habit(name: "Meditation",
                                                   id: UUID(),
                                                   finishedToday: false,
                                                   iconName: "face.smiling",
                                                   time: 45),
                               reducer: habitReducer,
                               environment: HabitEnvrionment()))
    }
    
}
