import ComposableArchitecture
import SwiftUI

@Reducer
public struct Emoji {
    @ObservableState
    public struct State: Equatable, Sendable {
        var source: Create.Source?
        var name: String
        var color: Color
        var emoji: String?
    }

    public enum Action: BindableAction, Sendable {
        case binding(BindingAction<State>)
        case backButtonTapped(Create.Source?, String, Color)
        case didSelectEmoji(String)
        case continueWithEmoji(Create.Source?, String, Color, String)
    }

    public var body: some Reducer<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {

            case let .didSelectEmoji(emoji):
                state.emoji = emoji
                return .none

            default:
                return .none
            }
        }
    }
}

struct EmojiView: View {
    @Bindable var store: StoreOf<Emoji>

    // Function to get all emojis
    static func getAllEmojis() -> [String] {
        var emojiList = [String]()
        // Iterate over a range of Unicode scalar values
        for i in 0x1F600...0x1F64F { // Emoticons range
            if let scalar = UnicodeScalar(i), scalar.properties.isEmoji {
                emojiList.append(String(scalar))
            }
        }

        // Additional emojis from Supplemental Symbols and Pictographs range
        for i in 0x1F900...0x1F9FF {
            if let scalar = UnicodeScalar(i), scalar.properties.isEmoji {
                emojiList.append(String(scalar))
            }
        }
        return emojiList
    }

    // Get the list of emojis
    let emojis: [String] = getAllEmojis()


    // Number of columns in the grid
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
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
                            store.state.name,
                            store.state.color
                        )
                    )
                }
                .foregroundStyle(.gray)
                .font(.headline)
                Spacer()
                StepperView(totalSteps: 4, currentStep: 2, color: store.state.color)
                Spacer()
            }
            .padding(.bottom, 8)
            VStack(alignment: .leading) {
                Text("Set a Display Emoji")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.bottom, 4)
                Text("Finally, let's choose an emoji for your wallet.")
                    .font(.subheadline)
                    .padding(.bottom, 8)
            }.padding()

            // Scrollable grid of emojis
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(emojis, id: \.self) { emoji in
                        Button(action: {
                            store.send(.didSelectEmoji(emoji))
                        }) {
                            Text(emoji)
                                .font(.title)
                                .background(store.state.emoji == emoji ? Color.blue.opacity(0.2) : Color.clear)
                                .cornerRadius(8)
                        }
                    }
                }
                .padding()
            }
            .padding(.bottom, 16)

            Spacer()

            Text("This is visible only to you.")
                .font(.subheadline)
                .frame(maxWidth: .infinity)

            Button(
                action: {
                    store.send(
                        .continueWithEmoji(
                            store.state.source,
                            store.state.name,
                            store.state.color,
                            store.state.emoji!
                        )
                    )
            }) {
                Text("Continue")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(store.state.emoji == nil ? Color.gray : store.state.color)
                        .cornerRadius(25)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .disabled(store.state.emoji == nil)
        }
        .padding()
        .background(Color(UIColor.systemBackground))
    }
}

#if DEBUG

#Preview("light") {
    NavigationStack {
        EmojiView(
            store: Store(initialState: Emoji.State(name: "test", color: .red)) {
                Emoji()
            }
        )
    }
    .environment(\.colorScheme, .light)
}

#Preview("dark") {
    NavigationStack {
        EmojiView(
            store: Store(initialState: Emoji.State(name: "test", color: .red)) {
                Emoji()
            }
        )
    }
    .environment(\.colorScheme, .dark)
}

#endif
