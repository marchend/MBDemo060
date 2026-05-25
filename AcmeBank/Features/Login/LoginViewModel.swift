import Foundation

/// ViewModel for the Login screen.
///
/// Holds all mutable login-form state and exposes `signIn()` which
/// validates inputs and delegates to the injected `onSignIn` closure.
/// Real async Okta integration is wired in the companion Okta story;
/// this implementation handles the UI state machine only.
@MainActor
final class LoginViewModel: ObservableObject {
    // MARK: - Published state

    @Published var username: String = ""
    @Published var password: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil

    // MARK: - Dependencies

    /// Injected sign-in handler. Defaults to a no-op for previews and tests
    /// that don't care about the callback invocation.
    let onSignIn: (String, String) -> Void

    // MARK: - Init

    init(onSignIn: @escaping (String, String) -> Void = { _, _ in }) {
        self.onSignIn = onSignIn
    }

    // MARK: - Actions

    /// Validate inputs and invoke the sign-in handler.
    ///
    /// Guards that both `username` and `password` are non-empty before
    /// calling `onSignIn`. Sets `isLoading = true` for the duration of
    /// the call, then resets it to `false` immediately (stub behaviour;
    /// real async lifecycle arrives in the Okta integration story).
    func signIn() {
        guard !username.trimmingCharacters(in: .whitespaces).isEmpty else {
            errorMessage = "Username is required."
            return
        }
        guard !password.isEmpty else {
            errorMessage = "Password is required."
            return
        }

        errorMessage = nil
        isLoading = true
        onSignIn(username, password)
        isLoading = false
    }
}
