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

@main
struct Suspicious_Activity_MonitorApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()  // Make sure this points to the correct root view
        }
    }
}

