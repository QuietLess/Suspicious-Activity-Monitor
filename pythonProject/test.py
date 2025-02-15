from ultralytics import YOLO
import cv2

# Load trained model
model = YOLO('runs/detect/train28/weights/best.pt')

# Open camera
cap = cv2.VideoCapture(0)  # 0 for webcam

while cap.isOpened():
    ret, frame = cap.read()
    if not ret:
        break

    # Run inference
    results = model(frame)

    # Display results
    annotated_frame = results[0].plot()
    cv2.imshow('YOLOv8 Live Detection', annotated_frame)

    if cv2.waitKey(1) & 0xFF == ord('q'):
        break

cap.release()
cv2.destroyAllWindows()
