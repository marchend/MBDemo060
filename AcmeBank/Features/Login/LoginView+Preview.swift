import SwiftUI

// MARK: - Previews

#Preview("Light Mode") {
    LoginView(viewModel: LoginViewModel())
        .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    LoginView(viewModel: LoginViewModel())
        .preferredColorScheme(.dark)
}

#Preview("Loading State") {
    let viewModel = LoginViewModel()
    viewModel.username = "user@acmebank.com"
    viewModel.password = "secret"
    viewModel.isLoading = true
    return LoginView(viewModel: viewModel)
}

#Preview("Error State") {
    let viewModel = LoginViewModel()
    viewModel.username = ""
    viewModel.errorMessage = "Username is required."
    return LoginView(viewModel: viewModel)
}
