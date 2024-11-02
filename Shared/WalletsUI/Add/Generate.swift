import ComposableArchitecture
import SwiftUI

@Reducer(state: .sendable, .equatable, action: .sendable)
public enum Generate {
    case create(Create)
    case present(Present)

    public static var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {

            case let .create(.terms(.finish(source, name, color, emoji))):
                state = .present(Present.State(source: source, name: name, color: color, emoji: emoji))
                return .none

            default:
                return .none
            }
        }
        .ifCaseLet(\.create, action: \.create) {
            Create.name(Name())
        }
        .ifCaseLet(\.present, action: \.present) {
            Present()
        }
    }
}

struct GenerateView: View {
    let store: StoreOf<Generate>

    init(store: StoreOf<Generate>) {
        self.store = store
    }

    public var body: some View {
        switch store.case {
        case let .create(store):
            CreateView(store: store)
                .transition(.move(edge: .bottom).combined(with: .opacity))
        case let .present(store):
            PresentView(store: store)
                .transition(.move(edge: .leading).combined(with: .opacity))
        }
    }
}
