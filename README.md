# PDF Editor Flutter App

A professional Flutter demonstration client consuming the FastAPI PDF Editor backend APIs for **PDF Translation** and **PDF Watermarking**.

---

## Features

1. **Translate PDF**:
   - Select a PDF file from your device.
   - Choose source and target languages (e.g., English `en`, Bangla `bn`).
   - Submit via `POST /api/translate-pdf` (multipart form-data).
   - View loading progress, preview the translated PDF, and download/save the resulting PDF.

2. **Watermark PDF**:
   - Select a PDF file from your device.
   - Enter custom watermark text (e.g., `CONFIDENTIAL`).
   - Select position from the exact set (`top-left`, `top-center`, `top-right`, `center`, `bottom-left`, `bottom-center`, `bottom-right`).
   - Configure opacity (0.0 to 1.0) using an interactive slider.
   - Choose watermark color via Hex (`#RRGGBB`) input or swatches.
   - Submit via `POST /editor/pdf/watermark` (multipart form-data).
   - Preview and download the watermarked PDF.

---

## Architecture & Tech Stack

- **Framework**: Flutter (Dart)
- **Architecture**: Feature-first clean architecture (`translate_pdf`, `watermark_pdf`).
- **State Management**: `flutter_bloc` (`Cubit`) + `equatable`.
- **Networking**: `Dio` with robust timeout configuration and centralized error mapping (`AppFailure`).
- **PDF Handling**: `file_picker` (selection/saving), `path_provider` (temp storage), and `pdfrx` (in-app preview).

---

## Getting Started

### Prerequisites
- Flutter SDK (stable channel)
- Dart SDK
- Running FastAPI backend server (`http://localhost:8000`)

### Setup & Run
1. Clone the repository and navigate to the project directory:
   ```bash
   cd pdf_editor_app
   ```
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Run the application:
   - **Desktop / Web / Emulator**:
     ```bash
     flutter run
     ```
   - **Physical Android Device**:
     Ensure ADB port forwarding is active for your backend:
     ```bash
     adb reverse tcp:8000 tcp:8000
     flutter run
     ```
   - **Custom Backend URL**:
     ```bash
     flutter run --dart-define=API_BASE_URL=http://<your-server-ip>:8000
     ```

---

## Running Tests & Quality Checks

- **Run Unit & Widget Tests**:
  ```bash
  flutter test
  ```
- **Run Static Analysis**:
  ```bash
  flutter analyze
  ```
- **Format Code**:
  ```bash
  dart format .
  ```

---

## Known Limitations

- Requires active connection to the FastAPI backend server.
- Large PDFs may be subject to backend memory and network timeout limits.
