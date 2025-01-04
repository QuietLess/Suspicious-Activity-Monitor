import SwiftUI

struct CameraSelectionView: View {
    let cameraOptions: [String: String]
    let onSelect: (URL) -> Void

    var body: some View {
        NavigationView {
            List(cameraOptions.keys.sorted(), id: \.self) { cameraName in
                if let urlString = cameraOptions[cameraName], let url = URL(string: urlString) {
                    Button(action: {
                        onSelect(url)
                    }) {
                        Text(cameraName)
                    }
                }
            }
            .navigationTitle("Select a Camera")
        }
    }
}
