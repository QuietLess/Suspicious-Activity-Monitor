import FirebaseDatabase
import Foundation

class FirebaseManager {
    private let databaseRef = Database.database().reference()

    func fetchLogEntries(completion: @escaping ([LogEntry]?, Error?) -> Void) {
        databaseRef.child("logs").observeSingleEvent(of: .value) { snapshot in
            var fetchedLogs: [LogEntry] = []

            // Traverse through object types like "Knife" and "Pistol"
            for child in snapshot.children {
                if let objectSnapshot = child as? DataSnapshot {
                    let objectType = objectSnapshot.key // Object type (e.g., "Knife", "Pistol")

                    for innerChild in objectSnapshot.children {
                        if let logSnapshot = innerChild as? DataSnapshot,
                           let data = logSnapshot.value as? [String: Any],
                           let date = data["date"] as? String,
                           let confidence = data["confidence"] as? Double,
                           let photoBase64 = data["photoBase64"] as? String {
                            let logEntry = LogEntry(
                                id: logSnapshot.key,
                                date: date,
                                object: objectType,
                                confidence: confidence,
                                photoBase64: photoBase64
                            )
                            fetchedLogs.append(logEntry)
                        }
                    }
                }
            }

            DispatchQueue.main.async {
                completion(fetchedLogs, nil)
            }
        } withCancel: { error in
            DispatchQueue.main.async {
                completion(nil, error)
            }
        }
    }
}
