import Dependencies

public extension DependencyValues {
    var addressGenerator: AddressGenerator {
        get { self[AddressGenerator.self] }
        set { self[AddressGenerator.self] = newValue }
    }
    var walletsRepository: WalletsRepository {
        get { self[WalletsRepository.self] }
        set { self[WalletsRepository.self] = newValue }
    }
}
