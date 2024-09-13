import Dependencies
import Domain

public struct WalletsRepository: Sendable {
    public var fetchAll: @Sendable () async throws -> [Wallet]
    public var append: @Sendable (Wallet) async throws -> Void

    public init(
        fetchAll: @escaping @Sendable () async throws -> [Wallet],
        append: @escaping @Sendable (Wallet) async throws -> Void
    ) {
        self.append = append
        self.fetchAll = fetchAll
    }
}

extension WalletsRepository: TestDependencyKey {
    public static var testValue: WalletsRepository {
        Self(
            fetchAll: {
                []
            },
            append: { wallet in
            }
        )
    }
}
