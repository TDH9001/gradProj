# Sci Connect 🎓

A cross-platform educational mobile application built with Flutter, designed to connect students and teachers within a school or university environment. Sci Connect streamlines academic communication, scheduling, resource sharing, and collaboration — all in one place, with full Arabic/English bilingual support.

---

## 📱 Features

### For Students
- 📅 **Calendar & Scheduling** — View class schedules, events, and deadlines via an interactive calendar
- 💬 **Real-time Chat** — Messaging with teachers and peers using Firebase-powered chat bubbles
- 📂 **File Sharing** — Send, receive, and view documents (PDFs, Excel files, and more)
- 🎙️ **Voice Messages** — Record and send audio messages within chats
- 📹 **Video Playback** — Watch shared video content in-app with Chewie/VideoPlayer
- 📖 **Student Guide** — Built-in PDF viewer for accessing the student handbook
- 🔔 **Notifications** — Stay updated on new messages and academic events
- 🌐 **Bilingual UI** — Full Arabic (RTL) and English (LTR) support via `easy_localization`

### For Teachers / Admins
- 📊 **Excel Export** — Generate and export reports using the `excel` package
- 📋 **QR Code Integration** — Generate and scan QR codes for attendance or resource sharing
- 👥 **Multi-user Roles** — Role-based access distinguishing students from teachers

### General
- 🔐 **Authentication** — Firebase Auth with phone number support (`intl_phone_field`)
- ☁️ **Cloud Storage** — Firebase Storage for media and document uploads
- 📡 **Cloud Functions** — Backend logic powered by Firebase Cloud Functions (TypeScript)
- 📶 **Connectivity Awareness** — Detects network state changes with `connectivity_plus`
- 🗂️ **Local Caching** — Hive for offline data persistence

---

## 🛠️ Tech Stack

| Layer | Technology |
|---|---|
| **Framework** | Flutter (Dart) |
| **State Management** | BLoC / Provider |
| **Backend** | Firebase (Auth, Firestore, Storage, Cloud Functions) |
| **Local Storage** | Hive |
| **Navigation** | Flutter Navigator |
| **Localization** | easy_localization (AR + EN) |
| **PDF Viewer** | Syncfusion Flutter PDF Viewer |
| **Media** | AudioPlayers, VideoPlayer, Chewie |
| **File Handling** | FilePicker, FileSaver, OpenFile |

---

## 📁 Project Structure

```
gradProj/
├── lib/                    # Main Dart source code
├── assets/
│   ├── images/             # App images and icons
│   ├── translate/
│   │   ├── en.json         # English strings
│   │   └── ar.json         # Arabic strings
│   ├── chat_data.json      # Local chat seed data
│   └── pdf/
│       └── student_guide.pdf
├── functions/              # Firebase Cloud Functions (TypeScript)
├── android/                # Android platform files
├── ios/                    # iOS platform files
├── web/                    # Web platform files
├── windows/                # Windows desktop files
├── linux/                  # Linux desktop files
├── macos/                  # macOS desktop files
├── test/                   # Unit & widget tests
├── firebase.json           # Firebase project config
└── pubspec.yaml            # Flutter dependencies
```

---

## 🚀 Getting Started

### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install) `>=3.4.3`
- Dart `>=3.4.3 <4.0.0`
- A Firebase project with the following services enabled:
  - Authentication
  - Cloud Firestore
  - Firebase Storage
  - Cloud Functions

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/TDH9001/gradProj.git
   cd gradProj
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Firebase**
   - Add your `google-services.json` to `android/app/`
   - Add your `GoogleService-Info.plist` to `ios/Runner/`
   - Update `.firebaserc` with your Firebase project ID

4. **Run the app**
   ```bash
   flutter run
   ```

### Running Cloud Functions

```bash
cd functions
npm install
firebase deploy --only functions
```

---

## 🌍 Localization

The app supports Arabic and English. Language files are located in `assets/translate/`. To add a new language, create a new JSON file following the same key structure and register it in `easy_localization`.

---

## 📦 Key Dependencies

| Package | Purpose |
|---|---|
| `firebase_auth` | User authentication |
| `cloud_firestore` | Real-time database |
| `firebase_storage` | File/media storage |
| `flutter_bloc` | BLoC state management |
| `provider` | Lightweight state management |
| `hive` + `hive_flutter` | Local data persistence |
| `easy_localization` | AR/EN translations |
| `syncfusion_flutter_pdfviewer` | PDF viewing |
| `record` + `audioplayers` | Voice message recording & playback |
| `chewie` + `video_player` | Video playback |
| `qr_flutter` + `qr_code_scanner` | QR generation & scanning |
| `excel` | Excel file generation |
| `file_picker` + `file_saver` | File selection & saving |
| `flutter_screenutil` | Responsive UI sizing |
| `calendar_view` | Schedule/calendar UI |
| `google_fonts` | Custom typography |

---

## 📄 Documentation

Full project documentation and presentation slides are included in the repository root:

- `Sci-connect documentation.pdf` — Technical and functional documentation
- `Sci connect Presentation.pdf` — Project presentation deck
- `sci-connect - Made with Clipchamp.mp4` — Demo video

---

## 👥 Contributors

- Mohamed Yehia: Team leader, Primary Flutter developer, Back-end
- Sarah Medhat: Flutter developer, UI/UX, Localization, Chatbot

---

## 📃 License

This project was developed as a graduation project. All rights reserved by the contributors.
