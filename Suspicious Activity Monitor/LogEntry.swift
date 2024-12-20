import Foundation

struct LogEntry: Codable {
    let date: String
    let object: String
    let photoBase64: String // Base64-encoded photo
}