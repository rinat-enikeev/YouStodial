import ComposableArchitecture
import SwiftUI

@Reducer(state: .sendable, .equatable, action: .sendable)
public enum Create {
    public enum Source: Equatable, Sendable {
        case seed(String)
        case privateKey(String)
    }

    case name(Name)
    case color(Tint)
    case emoji(Emoji)
    case terms(Terms)

    public static var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {

            case let .name(.continueWithName(source, name)):
                state = .color(Tint.State(source: source, name: name))
                return .none

            case let .color(.backButtonTapped(source, name)):
                state = .name(Name.State(source: source, name: name))
                return .none

            case let .color(.continueWithNameAndColor(source, name, color)):
                state = .emoji(Emoji.State(source: source, name: name, color: color))
                return .none

            case let .emoji(.backButtonTapped(source, name, color)):
                state = .color(Tint.State(source: source, name: name, color: color))
                return .none

            case let .emoji(.continueWithEmoji(source, name, color, emoji)):
                state = .terms(Terms.State(source: source, name: name, color: color, emoji: emoji))
                return .none

            case let .terms(.backButtonTapped(source, name, color, emoji)):
                state = .emoji(Emoji.State(source: source, name: name, color: color, emoji: emoji))
                return .none

            default:
                return .none
            }
        }
        .ifCaseLet(\.name, action: \.name) {
            Name()
        }
        .ifCaseLet(\.color, action: \.color) {
            Tint()
        }
        .ifCaseLet(\.emoji, action: \.emoji) {
            Emoji()
        }
        .ifCaseLet(\.terms, action: \.terms) {
            Terms()
        }
    }
}
struct CreateView: View {
    let store: StoreOf<Create>

    init(store: StoreOf<Create>) {
        self.store = store
    }

    public var body: some View {
        switch store.case {
        case let .name(store):
            NameView(store: store)
                .transition(.move(edge: store.name.isEmpty ? .bottom : .leading).combined(with: .opacity))
        case let .color(color):
            TintView(store: color)
                .transition(.move(edge: store.color?.color == nil ? .trailing : .leading).combined(with: .opacity))
        case let .emoji(emoji):
            EmojiView(store: emoji)
                .transition(.move(edge: store.emoji?.emoji == nil ? .trailing : .leading).combined(with: .opacity))
        case let .terms(terms):
            TermsView(store: terms)
                .transition(.move(edge: .trailing).combined(with: .opacity))
        }
    }
}
