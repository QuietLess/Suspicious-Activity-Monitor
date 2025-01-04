import FirebaseAuth
import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var showError = false
    @State private var errorMessage = ""
    @State private var failedAttempts = 0 // Track failed attempts locally
    @State private var isLockedOut = false // Lock out the user after too many attempts
    @Binding var isLoggedIn: Bool
    @Binding var userEmail: String

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Login")
                    .font(.largeTitle)
                    .bold()

                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)

                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                Button(action: login) {
                    Text("Login")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(isLockedOut ? Color.gray : Color.blue)
                        .cornerRadius(10)
                }
                .disabled(isLockedOut)

                NavigationLink(
                    destination: RegistrationView(isLoggedIn: $isLoggedIn, userEmail: $userEmail)
                ) {
                    Text("Don't have an account? Register")
                        .foregroundColor(.blue)
                }

                if showError {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                }
            }
            .padding()
            .navigationTitle("Login")
        }
    }

    private func login() {
        guard !email.isEmpty, !password.isEmpty else {
            showError = true
            errorMessage = "Please enter email and password."
            return
        }

        // Check if user is locked out
        if isLockedOut {
            showError = true
            errorMessage = "Too many failed attempts. Please try again later."
            return
        }

        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error as NSError? {
                handleAuthError(error)
            } else {
                // Reset failed attempts on successful login
                failedAttempts = 0
                isLoggedIn = true
                userEmail = email
                showError = false
            }
        }
    }

    private func handleAuthError(_ error: NSError) {
        switch AuthErrorCode(rawValue: error.code) {
        case .wrongPassword:
            failedAttempts += 1
            if failedAttempts >= 5 {
                lockOutUser()
            } else {
                errorMessage = "Incorrect password. \(5 - failedAttempts) attempts remaining."
            }
        case .invalidEmail:
            errorMessage = "Invalid email address."
        case .userNotFound:
            errorMessage = "No user found with this email."
        default:
            errorMessage = error.localizedDescription
        }
        showError = true
    }

    private func lockOutUser() {
        isLockedOut = true
        errorMessage = "Too many failed attempts. Please wait 30 seconds."

        // Automatically unlock after 30 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 30) {
            isLockedOut = false
            failedAttempts = 0
        }
    }
}
