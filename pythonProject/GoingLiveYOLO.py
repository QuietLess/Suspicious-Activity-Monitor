from flask import Flask, Response
import cv2
from ultralytics import YOLO
import base64
import firebase_admin
from firebase_admin import credentials, db
from datetime import datetime, timedelta

app = Flask(__name__)

model = YOLO('runs/detect/train28/weights/best.pt')

# firebase link burda
cred = credentials.Certificate(
    "/Users/yataseve/PycharmProjects/pythonProject/suspicious-activity-monitor-db-firebase-adminsdk-1dhl7-53d3d352c1.json")  # admin json dosyası
firebase_admin.initialize_app(cred, {
    'databaseURL': 'https://suspicious-activity-monitor-db-default-rtdb.europe-west1.firebasedatabase.app/'
})

database_ref = db.reference('logs')  # databasedeki logs klasörüne gidiyoruz

camera = cv2.VideoCapture(1)

DETECTION_WINDOW = 10

last_detection_times = {}
top_detections = {}


def save_frame_to_firebase(frame, detected_object, confidence):
    try:
        print("Converting frame to JPEG format...")
        _, buffer = cv2.imencode('.jpg', frame, [cv2.IMWRITE_JPEG_QUALITY, 50])
        frame_bytes = buffer.tobytes()

        print("Encoding image to Base64...")
        base64_image = base64.b64encode(frame_bytes).decode('utf-8')
        print(f"Base64 encoding successful. Size: {len(base64_image)} bytes")

        current_time = datetime.now()

        # eğer 10 saniyelik intervaldaysa skiple
        if detected_object in last_detection_times:
            time_since_last_detection = (current_time - last_detection_times[detected_object]).total_seconds()
            if time_since_last_detection < DETECTION_WINDOW:
                print(
                    f"Skipping logging for {detected_object}. Time since last detection: {time_since_last_detection:.2f}s")
                return

        # değilse logla
        log_entry = {
            "date": current_time.isoformat(),
            "confidence": confidence,
            "photoBase64": base64_image
        }

        # logladığını olması gereken noda yükle (olması gereken nod = logs'un altında hangi objeyse onun klasörü)
        object_ref = database_ref.child(detected_object)
        object_ref.push(log_entry)

        print(f"Log for {detected_object} saved successfully: {log_entry}")

        # last detection time'ı updateliyorum
        last_detection_times[detected_object] = current_time

    except Exception as e:
        print(f"Error in save_frame_to_firebase: {e}")


def log_new_detection(current_time, detected_object, confidence, base64_image):
    detection_entry = {
        "date": current_time.isoformat(),
        "object": detected_object,
        "confidence": confidence,
        "photoBase64": base64_image
    }
    new_entry_ref = database_ref.push(detection_entry)
    print(f"New detection logged: {detection_entry}")


# -------update ongoing detection sistemini iptal ettim kullanmıyorum ama fonksiyon dursun şimdilik
# def update_ongoing_detection(current_time, detected_object, confidence, base64_image):

# detection_entry = {
# "date": current_time.isoformat(),
# "confidence": confidence,
# "photoBase64": base64_image
# }
# database_ref.child(detected_object).push(detection_entry)
# print(f"Ongoing detection updated: {detection_entry}")

CONFIDENCE_THRESHOLD = 0.7


def generate_frames():
    while True:
        success, frame = camera.read()
        if not success or frame is None:
            print("Failed to capture frame from camera.")
            break
        else:
            print("Captured frame shape:", frame.shape)

            results = model(frame)

            for result in results:
                for box in result.boxes:
                    class_id = int(box.cls[0])
                    class_name = model.names[class_id]
                    confidence = float(box.conf[0])
                    print(f"Detected class: {class_name} with confidence {confidence:.2f}")

                    if class_name in ['Pistol', 'Knife', 'Rifle', 'Stick-Rod'] and confidence > CONFIDENCE_THRESHOLD:
                        print(f"High-confidence detection: {class_name} ({confidence:.2f})")
                        save_frame_to_firebase(frame, class_name, confidence)

            # frame'i anotateliyorum
            annotated_frame = results[0].plot()

            # Encodeluyorum
            _, buffer = cv2.imencode('.jpg', annotated_frame)
            frame = buffer.tobytes()

            yield (b'--frame\r\n'
                   b'Content-Type: image/jpeg\r\n\r\n' + frame + b'\r\n')


@app.route('/video_feed')
def video_feed():
    return Response(generate_frames(), mimetype='multipart/x-mixed-replace; boundary=frame')


@app.route('/')
def index():
    return "YOLOv8 Live Stream is Live! Access the stream at /video_feed"


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)

    print("YOLO Class Names:", model.names)
