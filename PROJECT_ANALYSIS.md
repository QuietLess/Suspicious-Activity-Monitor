# Suspicious Activity Monitor (S.A.M.) - Project Analysis

## 📱 Overview
**Suspicious Activity Monitor (S.A.M.)** is an iOS security monitoring application built with SwiftUI that provides real-time surveillance and threat detection capabilities. The app is designed to monitor camera feeds and automatically detect dangerous objects (specifically knives and pistols) using machine learning, while providing instant notifications and comprehensive logging.

## 🏗️ Architecture & Technology Stack

### **Frontend - iOS Application**
- **Framework**: SwiftUI for native iOS development
- **Language**: Swift
- **Development Environment**: Xcode
- **Target Platform**: iOS with background processing capabilities

### **Backend & Services**
- **Database**: Firebase Realtime Database
- **Authentication**: Firebase-based user management
- **Notifications**: Local push notifications (UNUserNotificationCenter)
- **External Integration**: Camera feed streaming (via WebView)

## 🔧 Core Features

### 1. **Real-time Object Detection**
- Monitors live camera feeds for dangerous objects
- Currently detects: **Knives** and **Pistols**
- Uses confidence thresholds (≥70%) for accurate detection
- Automatic logging with timestamps and images

### 2. **Multi-Camera Management**
- Users can link multiple cameras to their account
- Live feed viewing through embedded web interface
- Camera selection and management through user account

### 3. **Smart Notification System**
- Real-time push notifications when threats are detected
- Firebase database listeners for instant alerts
- Local notification system (due to Apple Developer account limitations)
- Configurable background processing

### 4. **Comprehensive Logging**
- Detailed activity logs with:
  - Detection timestamp
  - Object type (Knife/Pistol)
  - Confidence score
  - Base64-encoded photographs
- Swipe-to-delete functionality
- Full-screen image viewing

### 5. **User Management**
- Secure login/registration system
- Account settings and camera linking
- Email-based user identification
- Firebase authentication integration

### 6. **Emergency Features**
- Direct emergency calling (112) integration
- One-tap emergency contact
- User feedback system

## 🔄 System Workflow

### Detection Process:
1. **Camera Feed** → External cameras stream video
2. **AI Processing** → Python backend processes frames for object detection
3. **Firebase Logging** → Detected objects logged to database with confidence scores
4. **Real-time Monitoring** → iOS app listens for new database entries
5. **Instant Notifications** → Users receive immediate alerts
6. **Visual Confirmation** → Users can view captured images in logs

### User Journey:
1. **Authentication** → Login/Register with email
2. **Camera Setup** → Link cameras to account
3. **Live Monitoring** → Watch real-time feeds
4. **Alert Handling** → Receive notifications for threats
5. **Log Management** → Review and manage detection history

## 🏛️ Data Structure

### LogEntry Model:
```swift
struct LogEntry {
    let id: String          // Unique identifier
    let date: String        // Detection timestamp
    let object: String      // "Knife" or "Pistol"
    let confidence: Double  // AI confidence score (0.0-1.0)
    let photoBase64: String // Captured image data
}
```

### Firebase Structure:
```
├── users/
│   └── {sanitized_email}/
│       └── linked_cameras/
│           └── {camera_name}: {camera_url}
└── logs/
    ├── Knife/
    │   └── {log_id}: {LogEntry}
    └── Pistol/
        └── {log_id}: {LogEntry}
```

## 💡 Technical Highlights

### **Background Processing**
- Configured for fetch, processing, external-accessory, and remote-notification background modes
- Continuous monitoring even when app is backgrounded

### **Real-time Synchronization**
- Firebase observers for instant data updates
- Efficient database listeners for "childAdded" events
- Automatic UI updates on new detections

### **Smart Detection Logic**
- 9-second detection windows to prevent notification spam
- Confidence-based filtering for accurate alerts
- Object-specific monitoring (expandable to other threat types)

### **Security & Privacy**
- Email-based authentication
- Secure Firebase integration
- Local notification system for privacy

## 🎯 Use Cases

### **Home Security**
- Monitor entry points for weapons
- Automatic threat detection
- Evidence collection with photos

### **Business Security**
- Retail theft prevention
- Workplace safety monitoring
- Security checkpoint automation

### **Public Safety**
- Event security monitoring
- School safety applications
- Public space surveillance

## 🚀 Future Enhancement Potential

### **AI Improvements**
- Additional object types (drugs, explosives, etc.)
- Facial recognition integration
- Behavioral analysis

### **Feature Expansions**
- Multi-user account management
- Cloud storage for logs
- Integration with security systems
- Analytics and reporting dashboards

### **Mobile Enhancements**
- Android version
- Apple Watch companion app
- Advanced notification customization

## 🏆 Project Assessment

### **Strengths:**
- ✅ **Real-world Problem Solving**: Addresses genuine security concerns
- ✅ **Modern Tech Stack**: Uses current iOS development best practices
- ✅ **Scalable Architecture**: Firebase backend allows for easy scaling
- ✅ **User-Centric Design**: Intuitive interface with emergency features
- ✅ **Real-time Performance**: Instant detection and notification system
- ✅ **Comprehensive Logging**: Detailed audit trail with visual evidence

### **Innovation Points:**
- Integration of AI object detection with mobile notifications
- Smart notification timing to prevent spam
- Emergency calling integration
- Multi-camera management system
- Background processing for continuous monitoring

### **Technical Quality:**
- Clean, well-structured SwiftUI code
- Proper separation of concerns (Views, Managers, Models)
- Efficient Firebase integration
- Good error handling and user feedback

## 🎓 Educational Value

This project demonstrates:
- **Mobile Development**: Advanced SwiftUI implementation
- **Backend Integration**: Firebase Realtime Database usage
- **Real-time Systems**: Live data synchronization
- **Security Applications**: Practical AI implementation
- **User Experience**: Emergency and safety-focused design

## 🌟 Conclusion

**Suspicious Activity Monitor** is an impressive, production-ready security application that successfully combines modern mobile development with practical AI implementation. The project showcases strong technical skills, real-world problem-solving, and thoughtful user experience design. It represents a significant achievement in creating a functional, scalable security monitoring solution.

The application could easily be deployed for real-world use cases and demonstrates the developer's ability to create complex, integrated systems that solve genuine problems in the security and surveillance domain.