import SwiftUI
import ComposableArchitecture

struct HabitView: View {
    var store: Store<HabitState, HabitAction>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            HStack {
                Image(systemName: "face.smiling")
                    .resizable()
                    .frame(width: 50, height: 50)
                Text(viewStore.habit.safeName)
                    .strikethrough(viewStore.isDoneToday)
                Spacer()
                VStack {
                    Image(systemName: "clock.fill")
                    Text(String(viewStore.habit.currentDayEntry?.timeDone ?? 0) + "m")
                }
            }
            .opacity(viewStore.isDoneToday ? 0.5 : 1.0)
            .swipeActions(edge: .leading) {
                Button {
                    viewStore.send(.toggleFinish)
                } label: {
                    Image(systemName: "checkmark")
                }
                .tint(.indigo)
            }
            .if(viewStore.isDoneToday, transform: { view in
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
        .debug()
    }
}

struct HabitView_Previews: PreviewProvider {
    static var previews: some View {
        HabitView(store: Store(initialState: HabitState(context: .mocked, habit: Habit(context: .mocked)),
                               reducer: habitReducer,
                               environment: AppEnvrionment(mainQueue: .main,
                                                           managedObjectContext: PersistenceController.mocked.container.viewContext,
                                                           uuid: UUID.init)))
    }
    
}
