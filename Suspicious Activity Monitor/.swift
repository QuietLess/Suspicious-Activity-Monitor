//
//  LogEntry.swift
//  Suspicious Activity Monitor
//
//  Created by Yağız Efe Atasever on 21.12.2024.
//


import Foundation

struct LogEntry: Codable {
    let date: String
    let object: String
    let photoBase64: String // Base64-encoded photo
}