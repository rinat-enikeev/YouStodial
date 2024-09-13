public struct Wallet: Sendable, Identifiable, Hashable, Codable {
    public var id: String { address }
    public var address: String
    public var name: String
    public var color: Colour
    public var emoji: String

    public init(address: String, name: String, color: Colour, emoji: String) {
        self.address = address
        self.name = name
        self.color = color
        self.emoji = emoji
    }
}
