import XCTest
@testable import AcmeBank

@MainActor
final class LoginViewModelTests: XCTestCase {

    // MARK: - signIn calls onSignIn closure

    func test_signIn_callsOnSignInClosure() {
        var receivedUsername: String?
        var receivedPassword: String?
        let expectation = expectation(description: "onSignIn called")

        let viewModel = LoginViewModel { username, password in
            receivedUsername = username
            receivedPassword = password
            expectation.fulfill()
        }
        viewModel.username = "testuser@acmebank.com"
        viewModel.password = "p@ssw0rd"

        viewModel.signIn()

        waitForExpectations(timeout: 1)
        XCTAssertEqual(receivedUsername, "testuser@acmebank.com",
                       "onSignIn must receive the correct username")
        XCTAssertEqual(receivedPassword, "p@ssw0rd",
                       "onSignIn must receive the correct password")
    }

    // MARK: - Empty username guard

    func test_signIn_emptyUsername_doesNotCallClosure() {
        var closureCalled = false
        let viewModel = LoginViewModel { _, _ in closureCalled = true }
        viewModel.username = ""        // empty
        viewModel.password = "secret"

        viewModel.signIn()

        XCTAssertFalse(closureCalled,
                       "onSignIn must NOT be called when username is empty")
    }

    func test_signIn_whitespaceOnlyUsername_doesNotCallClosure() {
        var closureCalled = false
        let viewModel = LoginViewModel { _, _ in closureCalled = true }
        viewModel.username = "   "    // whitespace only
        viewModel.password = "secret"

        viewModel.signIn()

        XCTAssertFalse(closureCalled,
                       "onSignIn must NOT be called when username is whitespace only")
    }

    // MARK: - Empty password guard

    func test_signIn_emptyPassword_doesNotCallClosure() {
        var closureCalled = false
        let viewModel = LoginViewModel { _, _ in closureCalled = true }
        viewModel.username = "user@acmebank.com"
        viewModel.password = ""       // empty

        viewModel.signIn()

        XCTAssertFalse(closureCalled,
                       "onSignIn must NOT be called when password is empty")
    }

    // MARK: - isLoading lifecycle

    func test_signIn_setsIsLoadingTrue_thenResetsToFalse() {
        // Capture isLoading at the moment the closure fires.
        // Two-step declaration so the closure can weakly capture `viewModel`
        // — the capture list is evaluated as part of the initializer, so
        // `viewModel` must already be in scope before the closure literal.
        var isLoadingDuringSignIn: Bool?
        let expectation = expectation(description: "onSignIn called")

        var viewModel: LoginViewModel!
        viewModel = LoginViewModel { [weak viewModel] _, _ in
            isLoadingDuringSignIn = viewModel?.isLoading
            expectation.fulfill()
        }
        viewModel.username = "user@acmebank.com"
        viewModel.password = "secret"

        viewModel.signIn()

        waitForExpectations(timeout: 1)
        XCTAssertEqual(isLoadingDuringSignIn, true,
                       "isLoading must be true when onSignIn fires")
        XCTAssertFalse(viewModel.isLoading,
                       "isLoading must be reset to false after the stub call completes")
    }

    // MARK: - Error message on validation failure

    func test_signIn_emptyUsername_setsErrorMessage() {
        let viewModel = LoginViewModel()
        viewModel.username = ""
        viewModel.password = "secret"

        viewModel.signIn()

        XCTAssertNotNil(viewModel.errorMessage,
                        "errorMessage must be non-nil after a validation failure")
    }

    func test_signIn_emptyPassword_setsErrorMessage() {
        let viewModel = LoginViewModel()
        viewModel.username = "user@acmebank.com"
        viewModel.password = ""

        viewModel.signIn()

        XCTAssertNotNil(viewModel.errorMessage,
                        "errorMessage must be non-nil after a validation failure")
    }

    // MARK: - Error cleared on successful signIn

    func test_signIn_validCredentials_clearsErrorMessage() {
        let viewModel = LoginViewModel { _, _ in }
        viewModel.username = "user@acmebank.com"
        viewModel.password = "secret"
        viewModel.errorMessage = "Previous error"

        viewModel.signIn()

        XCTAssertNil(viewModel.errorMessage,
                     "errorMessage must be cleared when signIn succeeds validation")
    }
}
