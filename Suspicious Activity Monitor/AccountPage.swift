import SwiftUI
import FirebaseDatabase

struct AccountPage: View {
    @Binding var isLoggedIn: Bool
    var email: String
    @State private var cameraID = ""
    @State private var cameraPassword = ""
    @State private var linkedCameras: [String: String] = [:]
    @State private var showError = false
    @State private var errorMessage = ""

    var body: some View {
        VStack(spacing: 20) {
            Text("Account Settings")
                .font(.largeTitle)
                .bold()

            Text("Logged in as: \(email)")
                .font(.headline)

            Divider()

            TextField("Camera ID", text: $cameraID)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none)

            SecureField("Camera Password", text: $cameraPassword)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            Button(action: linkCamera) {
                Text("Link Camera")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.green)
                    .cornerRadius(10)
            }

            List {
                ForEach(linkedCameras.keys.sorted(), id: \.self) { cameraID in
                    HStack {
                        Text(cameraID)
                        Spacer()
                        Button(action: { unlinkCamera(cameraID: cameraID) }) {
                            Text("Unlink")
                                .foregroundColor(.red)
                        }
                    }
                }
            }

            Divider()

            Button(action: logout) {
                Text("Log Out")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.red)
                    .cornerRadius(10)
            }

            if showError {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
            }
        }
        .padding()
        .onAppear {
            fetchLinkedCameras()
        }
    }

    private func logout() {
        isLoggedIn = false
    }

    private func linkCamera() {
        guard !cameraID.isEmpty, !cameraPassword.isEmpty else {
            showError = true
            errorMessage = "Please enter both Camera ID and Password."
            return
        }

        let databaseRef = Database.database().reference()
        let sanitizedEmail = safeFirebaseKey(from: email)
        databaseRef.child("cameras").child(cameraID).observeSingleEvent(of: .value) { snapshot in
            guard let data = snapshot.value as? [String: Any],
                  let password = data["password"] as? String,
                  let url = data["url"] as? String else {
                showError = true
                errorMessage = "Invalid Camera ID."
                return
            }

            if password == cameraPassword {
                databaseRef.child("users").child(sanitizedEmail).child("linked_cameras").child(cameraID).setValue(url) { error, _ in
                    if let error = error {
                        showError = true
                        errorMessage = "Error linking camera: \(error.localizedDescription)"
                    } else {
                        fetchLinkedCameras()
                        showError = false
                    }
                }
            } else {
                showError = true
                errorMessage = "Incorrect camera password."
            }
        }
    }

    private func unlinkCamera(cameraID: String) {
        let databaseRef = Database.database().reference()
        let sanitizedEmail = safeFirebaseKey(from: email)
        databaseRef.child("users").child(sanitizedEmail).child("linked_cameras").child(cameraID).removeValue { error, _ in
            if let error = error {
                showError = true
                errorMessage = "Error unlinking camera: \(error.localizedDescription)"
            } else {
                fetchLinkedCameras()
                showError = false
            }
        }
    }

    private func fetchLinkedCameras() {
        let databaseRef = Database.database().reference()
        let sanitizedEmail = safeFirebaseKey(from: email)
        databaseRef.child("users").child(sanitizedEmail).child("linked_cameras").observeSingleEvent(of: .value) { snapshot in
            DispatchQueue.main.async {
                if let cameras = snapshot.value as? [String: String] {
                    linkedCameras = cameras
                } else {
                    linkedCameras = [:]
                }
            }
        }
    }

    private func safeFirebaseKey(from email: String) -> String {
        return email.replacingOccurrences(of: ".", with: ",")
    }
}
