import ComposableArchitecture
import SwiftUI

@Reducer(state: .sendable, .equatable, action: .sendable)
public enum AddWallet {
    case prompt(Prompt)
    case generate(Generate)
    case `import`(Import)

    public static var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {

            case .generate(.create(.name(.cancelButtonTapped))):
                state = .prompt(Prompt.State())
                return .none

            case .import(.mode(.cancelButtonTapped)):
                state = .prompt(Prompt.State())
                return .none

            case .prompt(.createButtonTapped):
                state = .generate(Generate.State.create(Create.State.name(Name.State())))
                return .none

            case .prompt(.importButtonTapped):
                state = .import(Import.State.mode(Mode.State()))
                return .none

            case .generate:
                return .none

            case .import:
                return .none

            case .prompt:
                return .none
            }
        }
        .ifCaseLet(\.prompt, action: \.prompt) {
            Prompt()
        }
        .ifCaseLet(\.generate, action: \.generate) {
            Generate.create(Create.name(Name()))
        }
        .ifCaseLet(\.import, action: \.import) {
            Import.mode(Mode())
        }
    }
}

struct AddWalletView: View {
    @Bindable var store: StoreOf<AddWallet>

    init(store: StoreOf<AddWallet>) {
        self.store = store
    }

    public var body: some View {
        ZStack {
            switch store.case {
            case let .prompt(store):
                PromptView(store: store)
            case let .generate(store):
                Color(UIColor.systemBackground)
                    .edgesIgnoringSafeArea(.all)
                    .transition(.opacity)
                GenerateView(store: store)
            case let .import(store):
                Color(UIColor.systemBackground)
                    .edgesIgnoringSafeArea(.all)
                    .transition(.opacity)
                ImportView(store: store)
            }
        }
        .animation(.easeIn, value: store.state)
    }
}
