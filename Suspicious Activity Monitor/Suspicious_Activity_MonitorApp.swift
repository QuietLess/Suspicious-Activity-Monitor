import SwiftUI
import FirebaseCore
import FirebaseDatabase
import UserNotifications

@main
struct Suspicious_Activity_MonitorApp: App {
    @State private var isLoggedIn = false // Track login state
    @State private var userEmail = "" // Store the logged-in user's email

    init() {
        // Configure Firebase
        FirebaseApp.configure()
        requestNotificationPermission()
        sendTestNotification()
        setupFirebaseObserver()
    }

    var body: some Scene {
        WindowGroup {
            if isLoggedIn {
                ContentView(isLoggedIn: $isLoggedIn, userEmail: $userEmail) // Pass state and email
            } else {
                LoginView(isLoggedIn: $isLoggedIn, userEmail: $userEmail) // Pass state and email
            }
        }
    }

    // Request notification permissions from the user
    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Notification permission error: \(error.localizedDescription)")
            } else {
                print("Notification permission granted: \(granted)")
            }
        }
    }

    // Send a test notification to verify functionality
    private func sendTestNotification() {
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

    // Set up Firebase observer for "Knife" and "Pistol" logs
    private func setupFirebaseObserver() {
        let databaseRef = Database.database().reference().child("logs")
        print("Setting up Firebase observer for Knife and Pistol logs...")

        ["Knife", "Pistol"].forEach { objectType in
            databaseRef.child(objectType).observe(.childAdded) { snapshot in
                guard let data = snapshot.value as? [String: Any],
                      let date = data["date"] as? String else {
                    print("Error: Invalid snapshot for \(objectType)")
                    return
                }
                print("New \(objectType) log detected: \(snapshot.key)")
                sendNotification(objectType: objectType, date: date)
            }
        }
    }

    // Send a notification when a new log is detected
    private func sendNotification(objectType: String, date: String) {
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
