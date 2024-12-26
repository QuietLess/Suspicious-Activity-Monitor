//
//  LogsView.swift
//  Suspicious Activity Monitor
//
//  Created by Yağız Efe Atasever on 19.12.2024.
//

import SwiftUI

struct LogsView: View {
    @State private var logEntries: [LogEntry] = []
    @State private var isLoading = true
    @State private var selectedImage: UIImage? = nil  // Image for full-screen view
    @State private var isFullScreen = false          // Toggle for full-screen view
    private let firebaseManager = FirebaseManager()

    var body: some View {
        NavigationView {
            VStack {
                if isLoading {
                    ProgressView("Loading logs...")
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding()
                } else {
                    List(logEntries) { log in
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

    private func decodeImage(from base64String: String) -> UIImage? {
        guard let imageData = Data(base64Encoded: base64String) else {
            print("Failed to decode Base64 string")
            return nil
        }
        return UIImage(data: imageData)
    }
}
