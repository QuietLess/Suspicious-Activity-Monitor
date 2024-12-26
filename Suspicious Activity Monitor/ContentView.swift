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
            VStack {
                
                // Button to go to Activity Logs
                NavigationLink(destination: LogsView()) {
                    Text("Activity Logs")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity) // Make it look like a button
                        .background(Color.green)
                        .cornerRadius(10)
                }
                
                // Button to go to Live Feed View (VDO.Ninja)
                NavigationLink(destination: LiveFeedView(streamURL: URL(string: "http://192.168.1.105:5000/video_feed")!)) {
                    Text("Live Feed")
                        .foregroundColor(.white) // Ensure the text is visible
                        .padding()
                        .frame(maxWidth: .infinity) // Make it look like a button
                        .background(Color.blue)
                        .cornerRadius(10)
                }
            }
            .padding()
            .navigationTitle("Main Menu")
        }
    }

    
    
}

