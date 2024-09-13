import ComposableArchitecture
import SwiftUI

@Reducer
public struct Tint {
    @ObservableState
    public struct State: Equatable, Sendable {
        var source: Create.Source?
        var name: String
        var color: Color?
    }

    public enum Action: BindableAction, Sendable {
        case binding(BindingAction<State>)
        case backButtonTapped(Create.Source?, String)
        case didSelectColor(Color)
        case continueWithNameAndColor(Create.Source?, String, Color)
    }

    public var body: some Reducer<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {

            case let .didSelectColor(color):
                state.color = color
                return .none

            default:
                return .none
            }
        }
    }
}

struct TintView: View {
    @Bindable var store: StoreOf<Tint>
    let colors: [Color] = [
        .red, .orange, .yellow, .green, 
        .blue, .purple, .pink, .brown,
        .indigo, .mint, .cyan, .teal,
        Color(UIColor(red: 0.85, green: 0.77, blue: 0.5, alpha: 1)),
        Color(UIColor(red: 0.85, green: 0.43, blue: 0.43, alpha: 1)),
        Color(UIColor(red: 0.5, green: 0.4, blue: 0.65, alpha: 1)),
        Color(UIColor(red: 0.35, green: 0.58, blue: 0.38, alpha: 1)),
        Color(UIColor(red: 0.2, green: 0.3, blue: 0.55, alpha: 1)),
        Color(UIColor(red: 0.8, green: 0.45, blue: 0.2, alpha: 1)),
        Color(UIColor(red: 0.45, green: 0.5, blue: 0.55, alpha: 1)),
        Color(UIColor(red: 0.6, green: 0.55, blue: 0.85, alpha: 1))
    ]

    // Number of columns in the grid
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Button("", systemImage: "chevron.left") {
                    store.send(
                        .backButtonTapped(
                            store.state.source,
                            store.state.name
                        )
                    )
                }
                .foregroundStyle(.gray)
                .font(.headline)
                Spacer()
                StepperView(totalSteps: 4, currentStep: 1, color: store.state.color ?? .blue)
                Spacer()
            }
            .padding(.bottom, 8)
            VStack(alignment: .leading) {
                Text("Choose a Color")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.bottom, 4)
                Text("Great! Now choose a color for your wallet.")
                    .font(.subheadline)
                    .padding(.bottom, 8)
            }.padding()

            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(colors.indices, id: \.self) { index in
                        Button(action: {
                            store.send(.didSelectColor(colors[index]))
                        }) {
                            ZStack {
                                Circle()
                                    .fill(colors[index])
                                    .frame(width: 60, height: 60)
                                    .shadow(radius: 4)

                                if store.state.color == colors[index] {
                                    // Inner stroke
                                    Circle()
                                        .stroke(Color.white, lineWidth: 2) // Inner stroke color and width
                                        .frame(width: 54, height: 54) // Slightly smaller than the outer circle to create inner stroke
                                }
                            }


                        }
                    }
                }
                .padding()
            }

            Spacer()

            Text("Only you will see your wallet color.")
                .font(.subheadline)
                .frame(maxWidth: .infinity)

            Button(action: {
                store.send(.continueWithNameAndColor(store.state.source, store.state.name, store.state.color!))
            }) {
                Text("Continue")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(store.state.color == nil ? Color.gray : store.state.color!)
                        .cornerRadius(25)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .disabled(store.state.color == nil)
        }
        .padding()
        .background(Color(UIColor.systemBackground))
    }
}

#if DEBUG

#Preview("light") {
    NavigationStack {
        TintView(
            store: Store(initialState: Tint.State(name: "test")) {
                Tint()
            }
        )
    }
    .environment(\.colorScheme, .light)
}

#Preview("dark") {
    NavigationStack {
        TintView(
            store: Store(initialState: Tint.State(name: "test")) {
                Tint()
            }
        )
    }
    .environment(\.colorScheme, .dark)
}

#endif
