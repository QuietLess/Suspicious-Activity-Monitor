import FirebaseFirestore
import Firebase

class FirestoreManager {
    private let db = Firestore.firestore()

    // Fetch all activity logs
    func fetchActivityLogs(completion: @escaping ([LogEntry]?, Error?) -> Void) {
        db.collection("activityLogs").order(by: "timestamp", descending: true).getDocuments { snapshot, error in
            if let error = error {
                completion(nil, error)
                return
            }

            let logs = snapshot?.documents.compactMap { document -> LogEntry? in
                guard let date = document["date"] as? String,
                      let object = document["object"] as? String else {
                    return nil
                }

                // Assume screenshots are stored as URLs in Firestore and download them
                let screenshotName = document["screenshot"] as? String ?? ""
                guard let screenshot = UIImage(named: screenshotName) else {
                    return nil
                }

                return LogEntry(date: date, object: object, screenshot: screenshot)
            }
            completion(logs, nil)
        }
    }
}
