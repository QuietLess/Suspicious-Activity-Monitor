//
//  LogsView.swift
//  Suspicious Activity Monitor
//
//  Created by Yağız Efe Atasever on 19.12.2024.
//

import SwiftUI
import FirebaseDatabase

struct LogsView: View {
    @State private var logEntries: [LogEntry] = []
    @State private var isLoading = true
    @State private var selectedImage: UIImage? = nil
    @State private var isFullScreen = false
    private let firebaseManager = FirebaseManager()

    var body: some View {
        NavigationView {
            VStack {
                if isLoading {
                    ProgressView("Loading logs...")
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding()
                } else {
                    List {
                        ForEach(logEntries) { log in
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Date: \(log.date)")
                                    .font(.headline)
                                Text("Object: \(log.object)")
                                    .font(.subheadline)
                                Text("Confidence: \(String(format: "%.2f", log.confidence))")
                                    .font(.caption)

                                if let image = decodeImage(from: log.photoBase64) {
                                    Button(action: {
                                        selectedImage = image
                                        isFullScreen = true
                                    }) {
                                        Image(uiImage: image)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(height: 150)
                                            .cornerRadius(10)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                } else {
                                    Text("Image not available")
                                        .foregroundColor(.red)
                                        .font(.caption)
                                }
                            }
                            .padding(.vertical, 10)
                        }
                        .onDelete(perform: deleteLog) // Add swipe-to-delete functionality
                    }
                }
            }
            .onAppear {
                fetchLogs()
            }
            .navigationTitle("Activity Logs")
            .sheet(isPresented: $isFullScreen) {
                if let selectedImage = selectedImage {
                    FullScreenImageView(image: selectedImage)
                }
            }
            .toolbar {
                EditButton() // Enable edit mode for deleting
            }
        }
    }

    private func fetchLogs() {
        firebaseManager.fetchLogEntries { logs, error in
            if let logs = logs {
                self.logEntries = logs
            } else if let error = error {
                print("Error fetching logs: \(error.localizedDescription)")
            }
            isLoading = false
        }
    }

    private func deleteLog(at offsets: IndexSet) {
        offsets.forEach { index in
            let logToDelete = logEntries[index]
            let objectType = logToDelete.object
            let logID = logToDelete.id

            let databaseRef = Database.database().reference().child("logs").child(objectType).child(logID)
            databaseRef.removeValue { error, _ in
                if let error = error {
                    print("Error deleting log: \(error.localizedDescription)")
                } else {
                    print("Log deleted successfully.")
                }
            }
        }
        logEntries.remove(atOffsets: offsets) // Remove the log from the local list
    }

    private func decodeImage(from base64String: String) -> UIImage? {
        guard let imageData = Data(base64Encoded: base64String) else {
            print("Failed to decode Base64 string")
            return nil
        }
        return UIImage(data: imageData)
    }
}
