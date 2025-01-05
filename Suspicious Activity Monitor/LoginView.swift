//
//  LoginView.swift
//  Suspicious Activity Monitor
//
//  Created by Yağız Efe Atasever on 4.01.2025.
//

import FirebaseAuth
import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var showError = false
    @State private var errorMessage = ""
    @State private var failedAttempts = 0 // normalde firebase failed attemptleri kendisi track'liyor. ama firebase failed attempt sonrası
                                         // hesabı bir süreliğine kilitliyor. firebase'in bu ayarını değiştirmek için apple developer
                                        //hesabına ihtiyacımız var, o hesabı da açamıyoruz.
    @State private var isLockedOut = false // Apple dev hesabı açamadığımız için failed attempt ve lock out işlemlerini manuel yaptık
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
            if failedAttempts >= 5 { //5 deneme hakkı var
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

        // 30 saniyeliğine user'ı lock outladık
        DispatchQueue.main.asyncAfter(deadline: .now() + 30) {
            isLockedOut = false
            failedAttempts = 0
        }
    }
}
