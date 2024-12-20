import SwiftUI

struct LiveFeedView: View {
    let streamURL: URL

    var body: some View {
        WebView(url: streamURL) // Display VDO.Ninja stream
            .edgesIgnoringSafeArea(.all) // Make it full-screen
    }
}

struct ContentView: View {
    var body: some View {
        // Your VDO.Ninja room URL
        let streamURL = URL(string: "https://vdo.ninja/?room=yourRoomName&hash=yourHashCode")!

        // Display the live stream in the LiveFeedView
        LiveFeedView(streamURL: streamURL)
    }
}
