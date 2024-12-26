//
//  FullScreenImageView.swift
//  Suspicious Activity Monitor
//
//  Created by Yağız Efe Atasever on 19.12.2024.
//


import SwiftUI

struct FullScreenImageView: View {
    let image: UIImage
    @Environment(\.dismiss) var dismiss

    @State private var scale: CGFloat = 1.0  // For pinch-to-zoom
    @State private var offset = CGSize.zero // For drag-to-dismiss

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()  // Background color

            Image(uiImage: image)
                .resizable()
                .scaledToFit()
                .scaleEffect(scale)
                .offset(offset)
                .gesture(
                    DragGesture()
                        .onChanged { gesture in
                            offset = gesture.translation
                        }
                        .onEnded { _ in
                            if abs(offset.height) > 150 {  // Drag threshold
                                dismiss()
                            } else {
                                offset = .zero  // Snap back if below threshold
                            }
                        }
                )
                .gesture(
                    MagnificationGesture()
                        .onChanged { value in
                            scale = value.magnitude
                        }
                        .onEnded { _ in
                            if scale < 1.0 { scale = 1.0 }  // Reset zoom level if too small
                        }
                )
        }
    }
}
