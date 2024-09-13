import ComposableArchitecture
import Domain
import Repository
import SwiftUI

@Reducer
public struct Wallets {
    @ObservableState
    public struct State: Equatable, Sendable {
        @Presents var addWallet: AddWallet.State?
        var cards: IdentifiedArrayOf<Card.State> = []
        public init() {}
    }

    public enum Action: BindableAction, Sendable {
        case binding(BindingAction<State>)
        case fetchAllWallets
        case didFetchAllWallets([Wallet])
        case cards(IdentifiedActionOf<Card>)
        case addWalletButtonTapped
        case addWalletDimmingViewTapped
        case addWallet(AddWallet.Action)
    }

    @Dependency(\.walletsRepository) var walletsRepository

    public init() {}

    public var body: some Reducer<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {

            case .fetchAllWallets:
                let walletsRepository = self.walletsRepository
                return .run { send in
                    let allWallets = try await walletsRepository.fetchAll()
                    await send(.didFetchAllWallets(allWallets))
                }

            case let .didFetchAllWallets(wallets):
                state.cards.append(contentsOf: wallets.map { Card.State(wallet: $0) })
                return .none

            case .addWalletButtonTapped:
                state.addWallet = AddWallet.State.prompt(.init())
                return .none

            case .addWalletDimmingViewTapped:
                state.addWallet = nil
                return .none

            case .addWallet(.prompt(.cancelButtonTapped)):
                state.addWallet = nil
                return .none

            case let .addWallet(.generate(.present(.didFinish(wallet)))):
                state.addWallet = nil
                state.cards.append(Card.State(wallet: wallet))
                let walletsRepository = self.walletsRepository
                return .run { _ in try await walletsRepository.append(wallet) }

            case let .addWallet(.import(.present(.didFinish(wallet)))):
                state.addWallet = nil
                state.cards.append(Card.State(wallet: wallet))
                let walletsRepository = self.walletsRepository
                return .run { _ in try await walletsRepository.append(wallet) }

            case .addWallet(.generate(.present(.cancel))):
                state.addWallet = nil
                return .none

            case .addWallet(.import(.present(.cancel))):
                state.addWallet = nil
                return .none

            default:
                return .none
            }
        }
        .ifLet(\.addWallet, action: \.addWallet) {
            AddWallet.prompt(Prompt())
        }
    }

}

public struct WalletsView: View {
    @Bindable var store: StoreOf<Wallets>

    public init(store: StoreOf<Wallets>) {
        self.store = store
    }

    public var body: some View {
        ZStack {
            ScrollView {

                VStack(spacing: 20) {
                    SectionHeaderView(title: "Wallets", action: {
                        store.send(.addWalletButtonTapped)
                    })

                    if store.cards.isEmpty {
                        EmptyDatasetView(message: "No wallets. Tap + to add new.")
                    } else {
                        LazyVGrid(
                            columns: [
                                GridItem(.flexible(), spacing: 16),
                                GridItem(.flexible(), spacing: 16)
                            ],
                            spacing: 16
                        ) {
                            ForEach(Array(store.scope(state: \.cards, action: \.cards))) { store in
                                CardView(store: store)
                            }
                        }.padding(.horizontal)
                    }
                }
                .padding()
            }
            if let addWalletStore = store.scope(state: \.addWallet, action: \.addWallet) {
                Color.black.opacity(0.5)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        store.send(.addWalletDimmingViewTapped)
                    }
                    .transition(.opacity)
                AddWalletView(store: addWalletStore)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .animation(.easeOut, value: store.state.addWallet != nil)
        .task { store.send(.fetchAllWallets) }
    }
}

private struct SectionHeaderView: View {
    let title: String
    let action: () -> Void

    var body: some View {
        HStack {
            Text(title)
                .font(.headline)
                .bold()
            Spacer()
            Button(action: action) {
                Image(systemName: "plus.circle.fill")
                    .font(.title2)
            }
        }
        .padding(.horizontal)
    }
}

private struct GridView: View {
    let items: [String]

    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]

    var body: some View {
        LazyVGrid(columns: columns, spacing: 16) {
            ForEach(items, id: \.self) { item in
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: 100)
                    .overlay(
                        Text(item)
                            .font(.body)
                    )
            }
        }
        .padding(.horizontal)
    }
}

private struct EmptyDatasetView: View {
    let message: String

    var body: some View {
        VStack {
            Image(systemName: "eye.slash")
                .font(.largeTitle)
                .foregroundColor(.gray)
                .padding(.bottom, 8)
            Text(message)
                .font(.body)
                .foregroundColor(.gray)
        }
        .padding(.top, 50)
    }
}

#if DEBUG

#Preview("light") {
    NavigationStack {
        WalletsView(
            store: Store(initialState: Wallets.State()) {
                Wallets()
            }
        )
    }
    .environment(\.colorScheme, .light)
}

#Preview("dark") {
    NavigationStack {
        WalletsView(
            store: Store(initialState: Wallets.State()) {
                Wallets()
            }
        )
    }
    .environment(\.colorScheme, .dark)
}

#endif
