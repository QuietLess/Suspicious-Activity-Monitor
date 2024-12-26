//
//  LogEntry.swift
//  Suspicious Activity Monitor
//
//  Created by Yağız Efe Atasever on 21.12.2024.
//


import Foundation

//struct LogEntry: Codable {
    //let date: String
    //let object: String
    //let photoBase64: String // Base64-encoded photo
//}

struct LogEntry: Identifiable, Codable {
    let id: String          // Random ID under each object type
    let date: String        // Timestamp of detection
    let object: String      // Object type (e.g., "Knife", "Pistol")
    let confidence: Double  // Confidence score
    let photoBase64: String // Base64-encoded image
}
