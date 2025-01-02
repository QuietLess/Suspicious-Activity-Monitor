//
//  Suspicious_Activity_MonitorApp.swift
//  Suspicious Activity Monitor
//
//  Created by Yağız Efe Atasever on 20.12.2024.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import FirebaseDatabase
import UserNotifications

@main
struct Suspicious_Activity_MonitorApp: App {
    init() {
        // Configure Firebase
        FirebaseApp.configure()
        // Request notification permissions
        requestNotificationPermission()
        // Send a test notification to verify functionality
        sendTestNotification()
        // Set up Firebase observer for logs
        setupFirebaseObserver()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }

    private func requestNotificationPermission() {
        print("Requesting notification permission...")

        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Notification permission error: \(error.localizedDescription)")
            } else {
                print("Notification permission granted: \(granted)")
            }
        }
    }

    private func sendTestNotification() {
        print("Sending a test notification...")
        let content = UNMutableNotificationContent()
        content.title = "Test Notification"
        content.body = "This is a test notification to verify local notifications."
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error sending test notification: \(error.localizedDescription)")
            } else {
                print("Test notification sent successfully!")
            }
        }
    }

    private func setupFirebaseObserver() {
        let databaseRef = Database.database().reference().child("logs")
        print("Setting up Firebase observer for Knife and Pistol logs...")

        ["Knife", "Pistol"].forEach { objectType in
            databaseRef.child(objectType).observe(.childAdded) { snapshot in
                print("New \(objectType) log detected: \(snapshot)")

                if snapshot.exists() {
                    print("Snapshot exists for \(objectType): \(snapshot.key)")

                    if let data = snapshot.value as? [String: Any] {
                        print("Raw data for \(objectType): \(data)")

                        if let date = data["date"] as? String {
                            print("Extracted date for \(objectType): \(date)")

                            // Trigger a local notification
                            sendNotification(objectType: objectType, date: date)
                        } else {
                            print("Error: Could not extract 'date' for \(objectType)")
                        }
                    } else {
                        print("Error: Snapshot value could not be cast to [String: Any]")
                    }
                } else {
                    print("Error: Snapshot does not exist for \(objectType)")
                }
            }
        }
    }

    private func sendNotification(objectType: String, date: String) {
        print("Preparing to send notification for \(objectType) detected on \(date)")

        let content = UNMutableNotificationContent()
        content.title = "New \(objectType) Log Detected!"
        content.body = "Detected on \(date)"
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error sending notification: \(error.localizedDescription)")
            } else {
                print("Notification sent successfully for \(objectType)!")
            }
        }
    }
}
