import Dependencies

public struct AddressGenerator: Sendable {
    public enum Source: Sendable {
        case seed(String)
        case privateKey(String)
    }

    public var generate: @Sendable (Source?) async throws -> String

    public init(
        generate: @escaping @Sendable (Source?) async throws -> String
    ) {
        self.generate = generate
    }
}

extension AddressGenerator: TestDependencyKey {
    public static var testValue: AddressGenerator {
        Self(
            generate: { source in
                "testAccontAddress"
            }
        )
    }
}
