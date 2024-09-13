import ComposableArchitecture
import SwiftUI

@Reducer
public struct Seed {
    @ObservableState
    public struct State: Equatable, Sendable {
        var seed: String = ""
        var shake: Bool = false
    }

    public enum Action: BindableAction, Sendable {
        case binding(BindingAction<State>)
        case cancelButtonTapped
        case pasteButtonTapped
        case importSeed(String)
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
                guard let _ = pasteboard.range(of: "^([a-z]+ ){11}[a-z]+$", options: .regularExpression) else {
                    state.shake = true
                    return .none
                }
                state.seed = pasteboard
                return .none

            default:
                return .none
            }
        }
    }
}

struct SeedView: View {
    @Bindable var store: StoreOf<Seed>

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
                Text("Enter your Secret Recovery Phrase to import your wallet securely.")
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

                if store.state.seed.isEmpty {
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
                        VStack {
                            Word(store: store, index: 0)
                            Word(store: store, index: 1)
                            Word(store: store, index: 2)
                            Word(store: store, index: 3)
                            Word(store: store, index: 4)
                            Word(store: store, index: 5)
                        }
                        VStack {
                            Word(store: store, index: 6)
                            Word(store: store, index: 7)
                            Word(store: store, index: 8)
                            Word(store: store, index: 9)
                            Word(store: store, index: 10)
                            Word(store: store, index: 11)
                        }
                    }
                }
            }
            .aspectRatio(1.585, contentMode: .fit)
            .padding()

            Spacer()

            Button(action: {
                store.send(.importSeed(store.state.seed))
            }) {
                Text("Import")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(store.state.seed.isEmpty ? Color.gray : Color.green)
                        .cornerRadius(25)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .disabled(store.state.seed.isEmpty)
        }
        .padding()
        .background(Color(UIColor.systemBackground))
    }
}

private struct Word: View {
    @Bindable var store: StoreOf<Seed>
    var index: Int

    var body: some View {
        HStack {
            Text("\(index + 1) ")
                .font(.headline)
            Text(store.state.seed.split(separator: " ")[index])
                .font(.headline)
        }
    }
}

extension View {
    func shakeAnimation(_ shake: Binding<Bool>, intensity: CGFloat = 3, duration: CGFloat = 0.05) -> some View {
        modifier(ShakeEffect(shake: shake, intensity: intensity, duration: duration))
    }
}

struct ShakeEffect: ViewModifier {
    @Binding var shake: Bool
    let intensity: CGFloat
    let duration: CGFloat

    func body(content: Content) -> some View {
        content
            .modifier(ShakeViewModifier(shake: $shake, intensity: intensity, duration: duration))

    }
}
struct ShakeViewModifier: ViewModifier {
    @Binding var shake: Bool
    let intensity: CGFloat
    let duration: CGFloat
    @State private var xIntensity: CGFloat = 0

    func body(content: Content) -> some View {
        if shake {
            return content
                .offset(x: shake ? xIntensity : -xIntensity, y: 0)
                .onAppear {
                    self.xIntensity = intensity
                    withAnimation(.easeInOut(duration: duration).repeatCount(5)) {
                        shake.toggle()
                    } completion: {
                        withAnimation(.easeInOut(duration: duration)) {
                            self.xIntensity = 0
                        }
                    }
                }
        } else {
            return content
        }
    }
}


#if DEBUG

#Preview("light") {
    NavigationStack {
        SeedView(
            store: Store(initialState: Seed.State()) {
                Seed()
            }
        )
    }
    .environment(\.colorScheme, .light)
}

#Preview("dark") {
    NavigationStack {
        SeedView(
            store: Store(initialState: Seed.State()) {
                Seed()
            }
        )
    }
    .environment(\.colorScheme, .dark)
}

#endif
