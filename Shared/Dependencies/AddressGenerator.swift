import Dependencies
import Foundation
import KeychainAccess
import Repository
import stellarsdk

extension AddressGenerator: @retroactive DependencyKey {
    private static let keychain = Keychain(service: Bundle.main.bundleIdentifier!)

    public static let liveValue = Self(
        generate: { source in
            switch source {
            case let .seed(seed):
                let keyPair = try WalletUtils.createKeyPair(mnemonic: seed, passphrase: nil, index: 0)
                keychain[keyPair.accountId] = keyPair.secretSeed
                return keyPair.accountId
            case let .privateKey(privateKey):
                let keyPair = try stellarsdk.KeyPair(secretSeed: privateKey)
                keychain[keyPair.accountId] = keyPair.secretSeed
                return keyPair.accountId
            case .none:
                let keyPair = try stellarsdk.KeyPair.generateRandomKeyPair()
                keychain[keyPair.accountId] = keyPair.secretSeed
                return keyPair.accountId
            }
        }
    )
}
