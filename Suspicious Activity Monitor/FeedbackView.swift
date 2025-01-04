import SwiftUI
import FirebaseDatabase

struct FeedbackView: View {
    let email: String
    @State private var feedbackText = ""
    @State private var showSuccessMessage = false
    @State private var showErrorMessage = false

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Send Feedback")
                    .font(.largeTitle)
                    .bold()

                TextField("Enter your feedback here", text: $feedbackText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(height: 100)
                    .padding()

                Button(action: sendFeedback) {
                    Text("Submit Feedback")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .cornerRadius(10)
                }

                if showSuccessMessage {
                    Text("Feedback submitted successfully!")
                        .foregroundColor(.green)
                        .font(.subheadline)
                }

                if showErrorMessage {
                    Text("Failed to submit feedback. Please try again.")
                        .foregroundColor(.red)
                        .font(.subheadline)
                }
            }
            .padding()
            .navigationTitle("Feedback")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") {
                        hideKeyboard()
                        showSuccessMessage = false
                        showErrorMessage = false
                        feedbackText = ""
                    }
                }
            }
        }
    }

    private func sendFeedback() {
        guard !feedbackText.isEmpty else {
            showErrorMessage = true
            return
        }

        let databaseRef = Database.database().reference().child("feedback")
        let feedbackID = UUID().uuidString

        let feedbackData: [String: Any] = [
            "user": email,
            "feedback": feedbackText,
            "timestamp": Date().timeIntervalSince1970
        ]

        databaseRef.child(feedbackID).setValue(feedbackData) { error, _ in
            if let error = error {
                print("Error submitting feedback: \(error.localizedDescription)")
                showErrorMessage = true
            } else {
                showSuccessMessage = true
                feedbackText = ""
            }
        }
    }

    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}