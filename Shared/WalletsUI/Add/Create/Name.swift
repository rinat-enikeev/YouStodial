import ComposableArchitecture
import SwiftUI

@Reducer
public struct Name {
    @ObservableState
    public struct State: Equatable, Sendable {
        var source: Create.Source?
        var name: String = ""
    }

    public enum Action: BindableAction, Sendable {
        case binding(BindingAction<State>)
        case cancelButtonTapped(Create.Source?)
        case continueWithName(Create.Source?, String)
    }

    public var body: some Reducer<State, Action> {
        BindingReducer()
    }
}

struct NameView: View {
    @Bindable var store: StoreOf<Name>

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Button("", systemImage: "xmark") {
                    store.send(.cancelButtonTapped(store.state.source))
                }
                .foregroundStyle(.gray)
                .font(.headline)
                Spacer()
                StepperView(totalSteps: 4, currentStep: 0, color: .blue)
                Spacer()
            }
            .padding(.bottom, 8)
            VStack(alignment: .leading) {
                Text("Name Your Wallet")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.bottom, 4)
                Text("Choose a nickname for your wallet")
                    .font(.subheadline)
                    .padding(.bottom, 8)
                TextField("My New Wallet", text: $store.state.name)
                    .font(.title2)
                    .padding(.bottom, 8)
                Text("Your nickname is stored locally on your device. It will only be visible to you.")
                    .font(.caption)
            }.padding()
            Spacer()

            Button(action: {
                store.send(.continueWithName(store.state.source, store.state.name))
            }) {
                Text("Continue")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(store.state.name.isEmpty ? Color.gray : Color.blue)
                        .cornerRadius(25)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .disabled(store.state.name.isEmpty)
        }
        .padding()
        .background(Color(UIColor.systemBackground))
    }
}

#if DEBUG

#Preview("light") {
    NavigationStack {
        NameView(
            store: Store(initialState: Name.State()) {
                Name()
            }
        )
    }
    .environment(\.colorScheme, .light)
}

#Preview("dark") {
    NavigationStack {
        NameView(
            store: Store(initialState: Name.State()) {
                Name()
            }
        )
    }
    .environment(\.colorScheme, .dark)
}

#endif
