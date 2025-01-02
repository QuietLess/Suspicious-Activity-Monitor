import SwiftUI
import FirebaseAuth

struct ChangePasswordView: View {
    @State private var currentPassword = ""
    @State private var newPassword = ""
    @State private var showError = false
    @State private var errorMessage = ""

    var body: some View {
        VStack(spacing: 20) {
            Text("Change Password")
                .font(.largeTitle)
                .bold()

            SecureField("Current Password", text: $currentPassword)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            SecureField("New Password", text: $newPassword)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            Button(action: changePassword) {
                Text("Update Password")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
            }

            if showError {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
            }
        }
        .padding()
    }

    private func changePassword() {
        guard !newPassword.isEmpty && newPassword.count >= 6 else {
            showError = true
            errorMessage = "New password must be at least 6 characters long."
            return
        }

        Auth.auth().currentUser?.updatePassword(to: newPassword) { error in
            if let error = error {
                showError = true
                errorMessage = "Error changing password: \(error.localizedDescription)"
            } else {
                showError = false
                errorMessage = ""
            }
        }
    }
}