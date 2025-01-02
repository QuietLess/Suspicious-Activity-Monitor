import SwiftUI
import FirebaseAuth
import FirebaseDatabase

struct CameraManagementView: View {
    @State private var cameraID = ""
    @State private var cameraPassword = ""
    @State private var linkedCameras: [String: String] = [:] // Camera ID and URL
    @State private var showError = false
    @State private var errorMessage = ""

    var body: some View {
        VStack(spacing: 20) {
            Text("Manage Cameras")
                .font(.largeTitle)
                .bold()

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

            if showError {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
            }
        }
        .padding()
        .onAppear(perform: fetchLinkedCameras)
    }

    private func linkCamera() {
        guard !cameraID.isEmpty && !cameraPassword.isEmpty else {
            showError = true
            errorMessage = "Please enter both Camera ID and Password."
            return
        }

        let databaseRef = Database.database().reference()

        // Validate camera credentials
        databaseRef.child("cameras").child(cameraID).observeSingleEvent(of: .value) { snapshot in
            guard let data = snapshot.value as? [String: Any],
                  let password = data["password"] as? String,
                  let url = data["url"] as? String else {
                showError = true
                errorMessage = "Invalid Camera ID."
                return
            }

            if password == cameraPassword {
                // Link camera to user
                guard let userID = Auth.auth().currentUser?.uid else { return }
                databaseRef.child("users").child(userID).child("cameras").child(cameraID).setValue(url) { error, _ in
                    if let error = error {
                        showError = true
                        errorMessage = "Error linking camera: \(error.localizedDescription)"
                    } else {
                        showError = false
                        errorMessage = ""
                        fetchLinkedCameras() // Refresh linked cameras
                    }
                }
            } else {
                showError = true
                errorMessage = "Incorrect camera password."
            }
        }
    }

    private func unlinkCamera(cameraID: String) {
        guard let userID = Auth.auth().currentUser?.uid else { return }

        let databaseRef = Database.database().reference()
        databaseRef.child("users").child(userID).child("cameras").child(cameraID).removeValue { error, _ in
            if let error = error {
                showError = true
                errorMessage = "Error unlinking camera: \(error.localizedDescription)"
            } else {
                showError = false
                errorMessage = ""
                fetchLinkedCameras() // Refresh linked cameras
            }
        }
    }

    private func fetchLinkedCameras() {
        guard let userID = Auth.auth().currentUser?.uid else { return }

        let databaseRef = Database.database().reference().child("users").child(userID).child("cameras")
        databaseRef.observeSingleEvent(of: .value) { snapshot in
            if let cameras = snapshot.value as? [String: String] {
                linkedCameras = cameras
            }
        }
    }
}