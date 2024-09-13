import ComposableArchitecture
import Domain
import SwiftUI

@Reducer
public struct Card {
    @ObservableState
    public struct State: Equatable, Identifiable, Sendable {
        public var id: String { wallet.id }
        var wallet: Wallet
    }

    public enum Action: BindableAction, Sendable {
        case binding(BindingAction<State>)
    }

    public var body: some Reducer<State, Action> {
        BindingReducer()
    }
}

struct CardView: View {
    @Bindable var store: StoreOf<Card>

    var body: some View {
        ZStack {
            // Background color for the card
            RoundedRectangle(cornerRadius: 8)
                .fill(store.wallet.color.color)
                .shadow(radius: 4)

            VStack {
                HStack {
                    // Emoji on the top left
                    Text(store.wallet.emoji)
                        .font(.title3)
                        .padding(.leading, 8)

                    Spacer()

                    // Circular button with 3 dots
                    Button(action: {
                        // Action for the button
                        print("3 dots button tapped")
                    }) {
                        Circle()
                            .fill(Color.white.opacity(0.2)) // Button background color
                            .frame(width: 22, height: 22) // Size of the button
                            .overlay(
                                Image(systemName: "ellipsis") // Use the SF Symbol for 3 dots
                                    .foregroundColor(.white) // Dot color
                            )
                    }
                    .padding(.trailing, 8)
                }
                .padding(.top, 8)

                Spacer()

                // Name on the bottom left
                HStack {
                    Text(store.wallet.name)
                        .font(.subheadline)
                        .foregroundColor(.white)
                        .padding(.leading, 8)

                    Spacer()
                }
                .padding(.bottom, 8)
            }
        }.aspectRatio(1.585, contentMode: .fit)
    }
}
