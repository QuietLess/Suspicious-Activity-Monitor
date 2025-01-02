import SwiftUI

struct CameraSelectionView: View {
    let linkedCameras: [String: String] // Camera ID and URL
    @Binding var selectedCameraID: String? // Selected camera ID

    var body: some View {
        NavigationView {
            List {
                ForEach(linkedCameras.keys.sorted(), id: \.self) { cameraID in
                    Button(action: {
                        selectedCameraID = cameraID
                    }) {
                        HStack {
                            Text(cameraID)
                            if selectedCameraID == cameraID {
                                Spacer()
                                Image(systemName: "checkmark")
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Select a Camera")
            .navigationBarItems(trailing: Button("Done") {
                // Close the sheet
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            })
        }
    }
}