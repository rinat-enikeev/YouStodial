import ComposableArchitecture
import Foundation

extension WalletsRepository: DependencyKey {

    public static let liveValue = Self(
        fetchAll: {
            let decoder = JSONDecoder()
            return try (UserDefaults.standard.array(forKey: walletsUDKey) as? [Data])?
                .compactMap { try decoder.decode(Wallet.self, from: $0) } ?? []
        },
        append: { wallet in
            let encoder = JSONEncoder()
            var array = UserDefaults.standard.array(forKey: walletsUDKey) ?? []
            array.append(try encoder.encode(wallet))
            UserDefaults.standard.set(array, forKey: walletsUDKey)
        }
    )
}

private let walletsUDKey = "WalletsRepository.wallets"
