//
//  LiveFeedView.swift
//  Suspicious Activity Monitor
//
//  Created by Yağız Efe Atasever on 20.12.2024.
//


import SwiftUI

struct LiveFeedView: View {
    let streamURL: URL

    var body: some View {
        WebView(url: streamURL) // Display VDO.Ninja stream
            .edgesIgnoringSafeArea(.all) // Make it full-screen
    }
}
