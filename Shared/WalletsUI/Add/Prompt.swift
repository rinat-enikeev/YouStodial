import ComposableArchitecture
import SwiftUI

@Reducer
public struct Prompt {
    @ObservableState
    public struct State: Equatable, Sendable {
    }

    public enum Action: BindableAction, Sendable {
        case binding(BindingAction<State>)
        case cancelButtonTapped
        case createButtonTapped
        case importButtonTapped
    }

    public var body: some Reducer<State, Action> {
        BindingReducer()
    }
}

struct PromptView: View {
    @Bindable var store: StoreOf<Prompt>

    var body: some View {
        VStack {
            Spacer()
            VStack {
                HStack {
                    Text("New Wallet")
                        .font(.title)
                    Spacer()
                    Button("", systemImage: "xmark.circle") {
                        store.send(.cancelButtonTapped)
                    }
                    .foregroundStyle(.gray)
                    .font(.largeTitle)
                }
                .padding(.bottom, 16)
                HStack {
                    Image(systemName: "arrow.counterclockwise.circle")
                        .foregroundColor(.green)
                        .font(.largeTitle)
                        .padding()
                    VStack(alignment: .leading) {
                        Text("Add Existing")
                            .font(.headline)
                            .fontWeight(.bold)
                        Text("Add an existing wallet by importing or restoring.")
                            .font(.subheadline)
                    }
                    Spacer()
                }
                .padding()
                .background(Color(UIColor.secondarySystemBackground))
                .clipShape(
                    .rect(
                        cornerRadii: RectangleCornerRadii(
                            topLeading: 16,
                            bottomLeading: 16,
                            bottomTrailing: 16,
                            topTrailing: 16
                        )
                    )
                )
                .onTapGesture {
                    store.send(.importButtonTapped)
                }

                HStack {
                    Image(systemName: "goforward.plus")
                        .foregroundColor(.blue)
                        .font(.largeTitle)
                        .padding()
                    VStack(alignment: .leading) {
                        Text("Create New")
                            .font(.headline)
                            .fontWeight(.bold)
                        Text("Create a fresh address with no previous history.")
                            .font(.subheadline)
                    }
                    Spacer()
                }
                .padding()
                .background(Color(UIColor.secondarySystemBackground))
                .clipShape(
                    .rect(
                        cornerRadii: RectangleCornerRadii(
                            topLeading: 16,
                            bottomLeading: 16,
                            bottomTrailing: 16,
                            topTrailing: 16
                        )
                    )
                )
                .onTapGesture {
                    store.send(.createButtonTapped)
                }
            }
            .padding()
            .background(Color(UIColor.systemBackground))
            .clipShape(
                .rect(
                    cornerRadii: RectangleCornerRadii(
                        topLeading: 16,
                        bottomLeading: 16,
                        bottomTrailing: 16,
                        topTrailing: 16
                    )
                )
            )
        }
        .padding()
    }
}

#if DEBUG

#Preview("light") {
    NavigationStack {
        PromptView(
            store: Store(initialState: Prompt.State()) {
                Prompt()
            }
        )
    }
    .environment(\.colorScheme, .light)
}

#Preview("dark") {
    NavigationStack {
        PromptView(
            store: Store(initialState: Prompt.State()) {
                Prompt()
            }
        )
    }
    .environment(\.colorScheme, .dark)
}

#endif
