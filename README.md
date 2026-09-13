# PDF Editor — Flutter Client

Demonstration Flutter application that consumes the FastAPI PDF Editor APIs:

- **Translate PDF** — `POST /api/translate-pdf`
- **Watermark PDF** — `POST /editor/pdf/watermark`

Built as a clean, feature-based, testable client for the Python + Flutter Developer practical coding assessment.

## Features

- Select a PDF and translate between English (en) and Bangla (bn)
- Apply a text watermark with position, opacity, and color controls
- Clear loading, success, and error states
- In-app PDF preview
- Configurable backend base URL
- Unit tests with mocked API
- GitHub Actions CI (format, analyze, test)

## Architecture

```text
lib/
├── app/                 # MaterialApp, theme, routing
├── core/                # network, config, files, shared widgets, errors
└── features/
    ├── home/
    ├── translate_pdf/   # data → domain → presentation
    └── watermark_pdf/   # data → domain → presentation
```

- **State management**: Bloc (Cubit)
- **HTTP**: Dio (multipart + binary PDF responses)
- **PDF preview**: pdfrx

## Requirements

- Flutter 3.24+ / Dart 3.5+
- A running FastAPI backend implementing the contract below

## Setup

```bash
git clone <repo>
cd pdf_editor_app
flutter pub get
```

## Configure Backend URL

Default: `http://localhost:8000`

Override at run time:

```bash
# Desktop / web
flutter run --dart-define=API_BASE_URL=http://localhost:8000

# Android emulator (host machine)
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:8000

# Docker-hosted backend on another host
flutter run --dart-define=API_BASE_URL=http://192.168.1.10:8000
```

The value is read from `ApiConfig.baseUrl` (`lib/core/config/api_config.dart`).

## Run

```bash
flutter run
```

## Test

```bash
flutter test
dart format --set-exit-if-changed .
flutter analyze
```

## API Endpoints Consumed

### Translate
```text
POST /api/translate-pdf
multipart: file, source_language, target_language
→ application/pdf
```

### Watermark
```text
POST /editor/pdf/watermark
multipart: file, text, position, opacity, color
→ application/pdf
```

- **Position values (exact)**:
  `top-left` | `top-center` | `top-right` | `center` | `bottom-left` | `bottom-center` | `bottom-right`
- **Color format**: `#RRGGBB`

## Project Plans

See `plans/` for requirements, design, tasks, tests, and acceptance checklist.

## CI/CD

GitHub Actions workflow (`.github/workflows/ci.yml`) runs:
- `flutter pub get`
- Format check
- `flutter analyze`
- `flutter test`
- Smoke web build

## Known Limitations

- Depends on backend availability and supported languages.
- Large PDFs may hit network or memory limits.
- In-app preview quality depends on `pdfrx` and the platform.
- No offline history or authentication (out of scope for the assessment).


