import ComposableArchitecture
import SwiftUI

@main
struct YouStodialApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                WalletsView(store: Store(initialState: Wallets.State()) {
                        Wallets()
                    }
                )
            }
        }
    }
}
