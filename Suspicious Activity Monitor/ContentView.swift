//
//  ContentView.swift
//  Suspicious Activity Monitor
//
//  Created by Yağız Efe Atasever on 19.12.2024.
//

import SwiftUI
import UIKit

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 20) { // Added spacing for better layout
                NavigationLink(destination: LogsView()) {
                    Text("Activity Logs")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .cornerRadius(10)
                }

                NavigationLink(destination: LiveFeedView(streamURL: URL(string: "http://192.168.1.105:5000/video_feed")!)) {
                    Text("Live Feed")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                }

                Button(action: {
                    callEmergencyNumber()
                }) {
                    Text("Call Emergency 112")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.red)
                        .cornerRadius(10)
                }
            }
            .padding()
            .navigationTitle("Main Menu")
        }
    }

    private func callEmergencyNumber() {
        let phoneNumber = "tel://05078682320" //112 arayıp durmayalım diye tolganın numarası bu
        if let url = URL(string: phoneNumber), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        } else {
            print("Cannot make a phone call on this device.")
        }
    }
}

