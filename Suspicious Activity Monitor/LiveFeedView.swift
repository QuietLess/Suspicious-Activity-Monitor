//
//  LiveFeedView.swift
//  Suspicious Activity Monitor
//
//  Created by Yağız Efe Atasever on 20.12.2024.
//


import SwiftUI
import FirebaseDatabase

struct LiveFeedView: View {
    let streamURL: URL
    @State private var isDetected: Bool = false // Tracks detection state
    @State private var detectedObject: String = "None" // Tracks detected object
    private let firebaseManager = FirebaseManager()

    var body: some View {
        ZStack {
            // Live feed video
            WebView(url: streamURL)
                .edgesIgnoringSafeArea(.all)

            // Detection Status Overlay
            VStack {
                HStack {
                    Spacer() // Push text to top-center
                    Text(isDetected ? "Detected: \(detectedObject)" : "Not Detected")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(isDetected ? .red : .green)
                        .padding()
                        .background(Color.black.opacity(0.7))
                        .cornerRadius(10)
                        .padding(.top, 150) // Space from the top
                    Spacer()
                }
                Spacer() // Push other content down
            }
        }
        .onAppear {
            startMonitoringDetections()
        }
    }

    private func startMonitoringDetections() {
        let databaseRef = Database.database().reference().child("logs")

        // Listen for real-time additions for both "Knife" and "Pistol"
        ["Knife", "Pistol"].forEach { objectType in
            databaseRef.child(objectType).observe(.childAdded) { snapshot in
                if let data = snapshot.value as? [String: Any],
                   let confidence = data["confidence"] as? Double,
                   confidence >= 0.7 { // Set your desired threshold here
                    DispatchQueue.main.async {
                        detectedObject = objectType
                        isDetected = true

                        // Automatically reset status after 5 seconds
                        DispatchQueue.main.asyncAfter(deadline: .now() + 9) {
                            isDetected = false
                            detectedObject = "None"
                        }
                    }
                }
            }
        }
    }
}
