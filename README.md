# Suspicious-Activity-Monitor

Turns any spare webcam into an **edge‑AI security system** that spots weapons in real time and alerts your phone. Made with home security in mind.

| Module | Tech |
| ------ | ---- |
| **iOS app** | Swift 5 · SwiftUI 3 · Combine · Firebase Auth/Firestore/Storage |
| **Edge server** | Python 3.11 · Flask · OpenCV · PyTorch · Ultralytics **YOLOv11** |
| **Cloud** | Firebase (Firestore + Storage) |

---

## ✨ Features

* **Live stream** – iOS app plays the camera feed served over LAN.  
* **Threat detection** – YOLOv11 flags knives, guns, etc.; on a hit it freezes the frame, encodes it to Base64, and uploads metadata + image to Firestore / Storage.  
* **Instant alerts** – in‑app toast, vibration, and evidence gallery.  
* **Emergency call** – one‑tap dial to 911 (US) or 112 (TR).  
* **Admin tools** – review / delete events, tweak model confidence threshold on the fly.

---

## Architecture

```
        ┌──────────────┐
        │  iOS  App    │
        │  SwiftUI     │
        └─────┬────────┘
              ▲ 
              │ 
        ┌─────┴────────┐
        │  Flask Edge  │  ← Python 3.11
        │   Server     │
        ├───YOLOv11────┤
        │   OpenCV     │
        └─────┬────────┘
              │ Firebase Admin SDK
 (Firebase Realtime Database) ▼
       ┌───────────────┐
       │   Firebase    │
       └───────────────┘

```

---

## Quick Start

### 1 · Clone

```bash
git clone https://github.com/EEXimium/Suspicious-Activity-Monitor.git
cd Suspicious-Activity-Monitor
```

### 2 · Edge server

```bash
cd pythonProject
python -m venv .venv && source .venv/bin/activate
pip install -r requirements.txt      # Flask, OpenCV, torch, ultralytics, …
python download_weights.py           # grabs YOLOv11 weights (~50 MB)
export GOOGLE_APPLICATION_CREDENTIALS=serviceAccount.json
python server.py
```

### 3 · Firebase

1. Create a Firebase project → enable **Firestore** and **Storage**.  
2. Add an iOS app → download **`GoogleService-Info.plist`** → drop it into Xcode root.  
3. Generate a **service‑account JSON** and save it as `pythonProject/serviceAccount.json`.
4. Add your camera link from the python code to the Firebase Database with a password under /Cameras

### 4 · iOS app

```text
open "Suspicious Activity Monitor.xcodeproj"
```

```
⌘ + R   # build & run on a real device and/or the emulator via XCode
```

---

## Authors

| Name | GitHub |
| ---- | ------ |
| Efe Atasever | [@EEXimium](https://github.com/EEXimium) |
| Tolga Değirmenci | [@QuietLess](https://github.com/QuietLess) |

---

## License

This project is licensed under the **MIT License**.  
See the full text in the [`LICENSE`](LICENSE) file.

---

## Acknowledgements

* **Ultralytics YOLOv11** – real‑time object detection  
* **Firebase** – effortless backend & storage  
* **Apple SwiftUI / Combine** – declarative UI & reactive data flow
