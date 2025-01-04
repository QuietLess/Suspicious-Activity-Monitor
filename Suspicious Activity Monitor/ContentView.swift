import SwiftUI

struct ContentView: View {
    @Binding var isLoggedIn: Bool
    @Binding var userEmail: String

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                NavigationLink(destination: LogsView()) {
                    Text("Activity Logs")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .cornerRadius(10)
                }

                NavigationLink(destination: LiveFeedView(email: userEmail)) {
                    Text("Live Feed")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                }

                NavigationLink(
                    destination: AccountPage(isLoggedIn: $isLoggedIn, email: userEmail)
                ) {
                    Text("Account Settings")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.orange)
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
        let phoneNumber = "tel://05078682320" // 112yi arayıp durmayalım diye tolgayı arıyoruz ama atolga sizi kurtaramaz.
        if let url = URL(string: phoneNumber), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        } else {
            print("Cannot make a phone call on this device.")
        }
    }
}
