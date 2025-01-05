//
//  Suspicious_Activity_MonitorApp.swift
//  Suspicious Activity Monitor
//
//  Created by Yağız Efe Atasever on 19.12.2024.
//

import SwiftUI
import FirebaseCore
import FirebaseDatabase
import UserNotifications

@main
struct Suspicious_Activity_MonitorApp: App {
    @State private var isLoggedIn = false // Track login state
    @State private var userEmail = "" // Store the logged-in user's email

    init() {
        // Configure Firebase burada
        FirebaseApp.configure()
        requestNotificationPermission()
        //sendTestNotification()
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

    // iOS her şeyde olduğu gibi notif atmak için de kullanıcıdan izin istiyor.
    //bu kodu böyle tek yazınca çalışmıyor. XCode uygulama ayarlarında "Signing&Capabilities kısmında
    //"remote notifications" ayarını da açmamız gerekiyor. Anladık ki swift, tahmin ettiğimizden çok daha fazla şekilde XCode ile entegre
    //bir dil.
    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Notification permission error: \(error.localizedDescription)")
            } else {
                print("Notification permission granted: \(granted)")
            }
        }
    }

    // bu test notificatioun fonksiyonu.
    //apple developer hesabı açamadığımız için aşırı kullanışlı push notificationları, firebase'e entegre şekilde kullanamadık
    //onun yerine kendimiz manuel bir local notif sistemi yazdık
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

    // notifler db bazlı olduğu için db'deki pistol ve knife loglarına bakmamız lazım düzenli olarak
    //yeni log fark edildiği anda notif yollayabilelim
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

    // yeni obje db'ye loglandığında notif yolluyoruz
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
