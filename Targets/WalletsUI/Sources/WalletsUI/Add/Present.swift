import ComposableArchitecture
import Domain
import Repository
import SwiftUI

@Reducer
public struct Present {
    @ObservableState
    public struct State: Equatable, Sendable {
        var source: Create.Source?
        var name: String
        var color: Color
        var emoji: String
        var address: String?
        var error: String?
    }

    public enum Action: BindableAction, Sendable {
        case binding(BindingAction<State>)
        case obtainAddress
        case didObtainAddress(String)
        case finish(String)
        case cancel
        case error(Error)
        case didFinish(Wallet)
    }

    @Dependency(\.addressGenerator) var addressGenerator

    public var body: some Reducer<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case let .error(error):
                state.error = error.localizedDescription
                return .none

            case .obtainAddress:
                let addressGenerator = self.addressGenerator
                let source = state.source.map(AddressGenerator.Source.init)
                return .run { send in
                    let address = try await addressGenerator.generate(source)
                    await send(.didObtainAddress(address))
                } catch: { error, send in
                    await send(.error(error))
                }
                
            case let .didObtainAddress(address):
                state.address = address
                return .none
                
            case let .finish(address):
                let wallet = Wallet(
                    address: address,
                    name: state.name,
                    color: Colour(from: state.color),
                    emoji: state.emoji
                )
                return .run { send in
                    await send(.didFinish(wallet))
                }

            default:
                return .none
            }
        }
    }
}

struct PresentView: View {
    @Bindable var store: StoreOf<Present>

    var body: some View {
        VStack(alignment: .leading) {

            if store.state.address != nil {
                Spacer()
                ZStack {
                    // Background color for the card
                    RoundedRectangle(cornerRadius: 16)
                        .fill(store.state.color)
                        .shadow(radius: 4)

                    VStack {
                        HStack {
                            // Emoji on the top left
                            Text(store.state.emoji)
                                .font(.largeTitle)
                                .padding(.leading, 16)

                            Spacer()

                            // Circular button with 3 dots
                            Button(action: {
                                // Action for the button
                                print("3 dots button tapped")
                            }) {
                                Circle()
                                    .fill(Color.white.opacity(0.2)) // Button background color
                                    .frame(width: 28, height: 28) // Size of the button
                                    .overlay(
                                        Image(systemName: "ellipsis") // Use the SF Symbol for 3 dots
                                            .foregroundColor(.white) // Dot color
                                    )
                            }
                            .padding(.trailing, 16)
                        }
                        .padding(.top, 16)

                        Spacer()

                        // Name on the bottom left
                        HStack {
                            Text(store.state.name)
                                .font(.largeTitle)
                                .foregroundColor(.white)
                                .padding(.leading, 16)

                            Spacer()
                        }
                        .padding(.bottom, 8)
                    }
                }.aspectRatio(1.585, contentMode: .fit)
                Spacer()
            } else if let error = store.state.error {
                VStack {
                    Text("Error: \(error)")
                        .font(.headline)
                        .foregroundColor(.red)
                    Button(action: {
                        store.send(.cancel)
                    }) {
                        Text("Cancel")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(store.state.color)
                                .cornerRadius(25)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                }
            } else {
                Spacer()
                ProgressView()
                    .frame(maxWidth: .infinity)
                Spacer()
            }

            Button(action: {
                guard let address = store.state.address else { return }
                store.send(.finish(address))
            }) {
                Text("Finish")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(store.state.address == nil ? Color.gray : store.state.color)
                        .cornerRadius(25)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .disabled(store.state.address == nil)
        }
        .padding()
        .background(Color(UIColor.systemBackground))
        .task { store.send(.obtainAddress) }
    }
}

private extension AddressGenerator.Source {
    init(from view: Create.Source) {
        switch view {
        case let .seed(seed):
            self = .seed(seed)
        case let .privateKey(privateKey):
            self = .privateKey(privateKey)
        }
    }
}

#if DEBUG

#Preview("light") {
    NavigationStack {
        PresentView(
            store: Store(initialState: Present.State(name: "test", color: .red, emoji: "😂")) {
                Present()
            }
        )
    }
    .environment(\.colorScheme, .light)
}

#Preview("dark") {
    NavigationStack {
        PresentView(
            store: Store(initialState: Present.State(name: "test", color: .red, emoji: "😂")) {
                Present()
            }
        )
    }
    .environment(\.colorScheme, .dark)
}

#endif
