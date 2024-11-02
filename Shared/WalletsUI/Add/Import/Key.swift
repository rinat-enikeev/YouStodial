import ComposableArchitecture
import SwiftUI

@Reducer
public struct Key {
    @ObservableState
    public struct State: Equatable, Sendable {
        var key: String = ""
        var shake: Bool = false
    }

    public enum Action: BindableAction, Sendable {
        case binding(BindingAction<State>)
        case cancelButtonTapped
        case pasteButtonTapped
        case finishWithKey(String)
    }

    public var body: some Reducer<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .pasteButtonTapped:
                guard let pasteboard = UIPasteboard.general.string else {
                    state.shake = true
                    return .none
                }
                state.key = pasteboard
                return .none

            default:
                return .none
            }
        }
    }
}

struct KeyView: View {
    @Bindable var store: StoreOf<Key>

    var body: some View {
        VStack {
            HStack {
                Button("", systemImage: "xmark") {
                    store.send(.cancelButtonTapped)
                }
                .foregroundStyle(.gray)
                .font(.headline)
                Spacer()
            }
            .padding(.bottom, 8)
            Spacer()
            VStack {
                Text("Import Wallet")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.bottom, 4)
                Text("Enter your Private Key to import your wallet securely.")
                    .font(.subheadline)
                    .frame(maxWidth: .infinity)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 8)
            }.padding()

            ZStack {
                // Background color for the card
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.green)
                    .shadow(radius: 4)

                if store.state.key.isEmpty {
                    VStack {
                        Button(action: {
                            store.send(.pasteButtonTapped)
                        }) {
                            Text("Paste from Clipboard")
                                    .font(.headline)
                                    .foregroundColor(.black)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.white)
                                    .cornerRadius(25)
                        }
                        .frame(maxWidth: .infinity)
                        .shakeAnimation($store.state.shake, intensity: 6, duration: 0.06)
                        .padding()
                    }
                } else {
                    HStack {
                        Text(store.state.key)
                    }
                }
            }
            .aspectRatio(1.585, contentMode: .fit)
            .padding()

            Spacer()

            Button(action: {
                store.send(.finishWithKey(store.state.key))
            }) {
                Text("Import")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(store.state.key.isEmpty ? Color.gray : Color.green)
                        .cornerRadius(25)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .disabled(store.state.key.isEmpty)
        }
        .padding()
        .background(Color(UIColor.systemBackground))
    }
}
