import SwiftUI

/// The Login screen — brand header, username / password fields,
/// primary Sign In CTA, and an inline error label.
///
/// Accepts a `LoginViewModel` via constructor injection so the view
/// can be driven from previews, unit tests, and the real app root.
struct LoginView: View {
    @ObservedObject var viewModel: LoginViewModel

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // MARK: - Brand header
                VStack(spacing: 8) {
                    Image(systemName: "building.columns.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 64, height: 64)
                        .foregroundStyle(.accent)
                        .accessibilityIdentifier("login.logo")

                    Text("AcmeBank")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .accessibilityIdentifier("login.title")

                    Text("Sign in to your account")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .accessibilityIdentifier("login.subtitle")
                }
                .padding(.top, 40)

                // MARK: - Form fields
                VStack(spacing: 16) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Username")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundStyle(.secondary)

                        TextField("Enter your username", text: $viewModel.username)
                            .textContentType(.username)
                            .keyboardType(.emailAddress)
                            .autocorrectionDisabled()
                            .textInputAutocapitalization(.never)
                            .padding(12)
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(8)
                            .accessibilityIdentifier("login.username")
                    }

                    VStack(alignment: .leading, spacing: 6) {
                        Text("Password")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundStyle(.secondary)

                        SecureField("Enter your password", text: $viewModel.password)
                            .textContentType(.password)
                            .padding(12)
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(8)
                            .accessibilityIdentifier("login.password")
                    }
                }

                // MARK: - Inline error label
                if let errorMessage = viewModel.errorMessage {
                    HStack(spacing: 8) {
                        Image(systemName: "exclamationmark.circle.fill")
                            .foregroundStyle(.red)
                        Text(errorMessage)
                            .font(.footnote)
                            .foregroundStyle(.red)
                        Spacer()
                    }
                    .padding(.horizontal, 4)
                    .accessibilityIdentifier("login.errorMessage")
                }

                // MARK: - Sign In button
                Button(action: { viewModel.signIn() }) {
                    Group {
                        if viewModel.isLoading {
                            HStack(spacing: 8) {
                                ProgressView()
                                    .tint(.white)
                                Text("Signing in…")
                            }
                        } else {
                            Text("Sign In")
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .foregroundStyle(.white)
                    .fontWeight(.semibold)
                }
                .background(viewModel.isLoading ? Color.accentColor.opacity(0.6) : Color.accentColor)
                .cornerRadius(10)
                .disabled(viewModel.isLoading)
                .accessibilityIdentifier("login.signIn")

                Spacer(minLength: 24)
            }
            .padding(.horizontal, 24)
        }
        .scrollBounceBehavior(.basedOnSize)
    }
}
