import ComposableArchitecture
import SwiftUI

@Reducer(state: .sendable, .equatable, action: .sendable)
public enum Import {
    case mode(Mode)
    case seed(Seed)
    case key(Key)
    case create(Create)
    case present(Present)

    public static var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {

            case .mode(.seedButtonTapped):
                state = .seed(Seed.State())
                return .none

            case .mode(.keyButtonTapped):
                state = .key(Key.State())
                return .none

            case .seed(.cancelButtonTapped):
                state = .mode(Mode.State())
                return .none

            case .key(.cancelButtonTapped):
                state = .mode(Mode.State())
                return .none

            case let .create(.name(.cancelButtonTapped(source))):
                switch source {
                case let .seed(seed):
                    state = .seed(Seed.State(seed: seed))
                case let .privateKey(privateKey):
                    state = .key(Key.State(key: privateKey))
                case .none:
                    state = .mode(Mode.State())
                }
                return .none

            case let .seed(.importSeed(seed)):
                state = .create(Create.State.name(Name.State(source: .seed(seed))))
                return .none

            case let .key(.finishWithKey(key)):
                state = .create(Create.State.name(Name.State(source: .privateKey(key))))
                return .none

            case let .create(.terms(.finish(source, name, color, emoji))):
                state = .present(Present.State(source: source, name: name, color: color, emoji: emoji))
                return .none

            default:
                return .none
            }
        }
        .ifCaseLet(\.mode, action: \.mode) {
            Mode()
        }
        .ifCaseLet(\.seed, action: \.seed) {
            Seed()
        }
        .ifCaseLet(\.key, action: \.key) {
            Key()
        }
        .ifCaseLet(\.create, action: \.create) {
            Create.name(Name())
        }
        .ifCaseLet(\.present, action: \.present) {
            Present()
        }
    }
}

struct ImportView: View {
    let store: StoreOf<Import>

    init(store: StoreOf<Import>) {
        self.store = store
    }

    public var body: some View {
        switch store.case {
        case let .mode(store):
            ModeView(store: store)
                .transition(.move(edge: .bottom).combined(with: .opacity))
        case let .seed(store):
            SeedView(store: store)
                .transition(.opacity)
        case let .key(store):
            KeyView(store: store)
                .transition(.opacity)
        case let .create(store):
            CreateView(store: store)
                .transition(.move(edge: .leading).combined(with: .opacity))
        case let .present(store):
            PresentView(store: store)
                .transition(.move(edge: .leading).combined(with: .opacity))
        }
    }
}
