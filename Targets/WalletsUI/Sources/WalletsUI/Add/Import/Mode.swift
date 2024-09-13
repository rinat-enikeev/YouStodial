import ComposableArchitecture
import SwiftUI

@Reducer
public struct Mode {
    @ObservableState
    public struct State: Equatable, Sendable {
        var mode: String = ""
    }

    public enum Action: BindableAction, Sendable {
        case binding(BindingAction<State>)
        case cancelButtonTapped
        case seedButtonTapped
        case keyButtonTapped
        case continueWithMode(String)
    }

    public var body: some Reducer<State, Action> {
        BindingReducer()
    }
}

struct ModeView: View {
    @Bindable var store: StoreOf<Mode>

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

            ZStack {
                // Background color for the card
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.green)
                    .shadow(radius: 4)
                VStack {
                    HStack {
                        // Emoji on the top left
                        Circle()
                            .fill(Color.white.opacity(0.5))  // Semi-opaque fill
                            .frame(width: 32, height: 32)  // Adjust the size of the circle
                            .padding(.leading, 16)

                        Spacer()

                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.white.opacity(0.5))  // Semi-opaque fill
                            .frame(width: 100, height: 30)  // Adjust size to mimic a text line
                        .padding(.trailing, 16)
                    }
                    .padding(.top, 16)

                    Spacer()
                }
            }
            .aspectRatio(1.585, contentMode: .fit)
            .padding()

            Spacer()

            VStack {
                Text("Add an Existing Wallet")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.bottom, 4)
                Text("Choose how you'd like to import and existing wallet.")
                    .font(.subheadline)
                    .frame(maxWidth: .infinity)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 8)
                Spacer()
            }.padding()

            HStack {
                Image(systemName: "arrow.counterclockwise.circle")
                    .foregroundColor(.green)
                    .font(.largeTitle)
                    .padding()
                VStack(alignment: .leading) {
                    Text("Secret Recovery Phrase")
                        .font(.headline)
                        .fontWeight(.bold)
                    Text("Import any wallet using a 12-word Secret Recovery Phrase.")
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
                store.send(.seedButtonTapped)
            }

            HStack {
                Image(systemName: "goforward.plus")
                    .foregroundColor(.blue)
                    .font(.largeTitle)
                    .padding()
                VStack(alignment: .leading) {
                    Text("Private Key")
                        .font(.headline)
                        .fontWeight(.bold)
                    Text("Import any wallet using a unique Private Key.")
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
                store.send(.keyButtonTapped)
            }
        }
        .padding()
        .background(Color(UIColor.systemBackground))
    }
}

#if DEBUG

#Preview("light") {
    NavigationStack {
        ModeView(
            store: Store(initialState: Mode.State()) {
                Mode()
            }
        )
    }
    .environment(\.colorScheme, .light)
}

#Preview("dark") {
    NavigationStack {
        ModeView(
            store: Store(initialState: Mode.State()) {
                Mode()
            }
        )
    }
    .environment(\.colorScheme, .dark)
}

#endif

