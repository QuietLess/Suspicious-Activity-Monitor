import FirebaseDatabase
import UIKit

class FirebaseManager {
    private let databaseRef = Database.database().reference()

    // Save a log entry to the database
    func saveLogEntry(logEntry: LogEntry, completion: @escaping (Error?) -> Void) {
        let logData = [
            "date": logEntry.date,
            "object": logEntry.object,
            "photoBase64": logEntry.photoBase64
        ]
        databaseRef.child("logs").childByAutoId().setValue(logData) { error, _ in
            completion(error)
        }
    }

    // Fetch all log entries from the database
    func fetchLogEntries(completion: @escaping ([LogEntry]?, Error?) -> Void) {
        databaseRef.child("logs").observeSingleEvent(of: .value) { snapshot in
            guard let logs = snapshot.value as? [String: [String: String]] else {
                completion(nil, nil)
                return
            }

            let logEntries = logs.compactMap { _, value -> LogEntry? in
                guard
                    let date = value["date"],
                    let object = value["object"],
                    let photoBase64 = value["photoBase64"]
                else { return nil }

                return LogEntry(date: date, object: object, photoBase64: photoBase64)
            }
            completion(logEntries, nil)
        }
    }
}