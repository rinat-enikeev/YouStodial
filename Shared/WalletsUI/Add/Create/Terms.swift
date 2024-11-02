import ComposableArchitecture
import SwiftUI

@Reducer
public struct Terms {
    @ObservableState
    public struct State: Equatable, Sendable {
        var source: Create.Source?
        var name: String
        var color: Color
        var emoji: String
        var responsibility: Bool = false
        var legal: Bool = false
        var institution: Bool = false
        var access: Bool = false
    }

    public enum Action: BindableAction, Sendable {
        case binding(BindingAction<State>)
        case backButtonTapped(Create.Source?, String, Color, String)
        case finish(Create.Source?, String, Color, String)
    }

    public var body: some Reducer<State, Action> {
        BindingReducer()
    }
}

struct TermsView: View {
    @Bindable var store: StoreOf<Terms>

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Button("", systemImage: "chevron.left") {
                    store.send(
                        .backButtonTapped(
                            store.state.source,
                            store.state.name,
                            store.state.color,
                            store.state.emoji
                        )
                    )
                }
                .foregroundStyle(.gray)
                .font(.headline)
                Spacer()
                StepperView(totalSteps: 4, currentStep: 3, color: store.state.color)
                Spacer()
            }
            .padding(.bottom, 8)
            VStack(alignment: .leading) {
                Text("Accept Terms")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.bottom, 4)
                Text("Please read and agree to the following terms before you continue.")
                    .font(.subheadline)
                    .padding(.bottom, 8)
            }.padding()

            Spacer()

            VStack(alignment: .leading, spacing: 16) {
                // Toggle for each term
                HStack(alignment: .top) {
                    Toggle("", isOn: $store.state.responsibility)
                        .labelsHidden()
                    Text("I understand that I am solely responsible for the security and backup of my wallets.")
                        .font(.caption)
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)
                }

                HStack(alignment: .top) {
                    Toggle("", isOn: $store.state.legal)
                        .labelsHidden()
                    Text("I understand that using the app for any illegal purposes is strictly prohibited and against terms.")
                        .font(.caption)
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)
                }

                HStack(alignment: .top) {
                    Toggle("", isOn: $store.state.institution)
                        .labelsHidden()
                    Text("I understand that the app is not a bank, exchange, or centralized financial institution.")
                        .font(.caption)
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)
                }

                HStack(alignment: .top) {
                    Toggle("", isOn: $store.state.access)
                        .labelsHidden()
                    Text("I understand that if I ever lose access to my wallets, no one is liable and able to help in any way.")
                        .font(.caption)
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }

            Spacer()

            Text("By checking boxes, you agree to these terms.")
                .font(.subheadline)
                .frame(maxWidth: .infinity)

            Button(
                action: {
                    store.send(
                        .finish(
                            store.state.source,
                            store.state.name,
                            store.state.color,
                            store.state.emoji
                        )
                    )
            }) {
                Text("I Understand, Continue")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(!isAllTermsAccepted ? Color.gray : store.state.color)
                        .cornerRadius(25)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .disabled(!isAllTermsAccepted)
        }
        .padding()
        .background(Color(UIColor.systemBackground))
    }

    private var isAllTermsAccepted: Bool {
        store.state.responsibility && store.state.access && store.state.institution && store.state.legal
    }
}

#if DEBUG

#Preview("light") {
    NavigationStack {
        TermsView(
            store: Store(initialState: Terms.State(name: "test", color: .red, emoji: "😂")) {
                Terms()
            }
        )
    }
    .environment(\.colorScheme, .light)
}

#Preview("dark") {
    NavigationStack {
        TermsView(
            store: Store(initialState: Terms.State(name: "test", color: .red, emoji: "😂")) {
                Terms()
            }
        )
    }
    .environment(\.colorScheme, .dark)
}

#endif
