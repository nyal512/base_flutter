# base_flutter
nano ~/.zshrc
source ~/.zshrc
A comprehensive Flutter starting point with Clean Architecture, MVVM, and Multi-Environment support.

## 🚀 Đa môi trường (Multi-Environment)

Dự án sử dụng cơ chế `--dart-define-from-file` để quản lý các môi trường khác nhau. Các cấu hình nằm trong các file:
- `.env.dev`: Môi trường Development (Mặc định)
- `.env.stg`: Môi trường Staging
- `.env.prod`: Môi trường Production

## 🛠 Cách Chạy và Build (Run & Build)

### 💻 Chạy với VS Code
Mở tab **Run and Debug** và chọn môi trường:
- `Base Flutter (Dev)`
- `Base Flutter (Staging)`
- `Base Flutter (Prod)`

### 📱 Chạy trực tiếp trên thiết bị (Direct Run)
Nếu bạn muốn chỉ định thiết bị cụ thể (ví dụ macOS, Windows, Chrome):
```bash
# Chạy trên macOS với môi trường Dev
flutter run -d macos --dart-define-from-file=.env.dev

# Chạy trên Chrome với môi trường Prod
flutter run -d chrome --dart-define-from-file=.env.prod
```

### ⌨️ Chạy từ Terminal (Tham số môi trường)
```bash
# Development
flutter run --dart-define-from-file=.env.dev

# Staging
flutter run --dart-define-from-file=.env.stg

# Production
flutter run --dart-define-from-file=.env.prod
```

### 📦 Lệnh Build Ứng Dụng

#### 📱 Mobile
```bash
# Android (APK)
flutter build apk --dart-define-from-file=.env.prod

# Android (App Bundle)
flutter build appbundle --dart-define-from-file=.env.prod

# iOS
flutter build ios --dart-define-from-file=.env.prod
```

#### 🖥 Desktop
```bash
# macOS
flutter build macos --dart-define-from-file=.env.prod

# Windows
flutter build windows --dart-define-from-file=.env.prod
```

#### 🌐 Web
```bash
flutter build web --dart-define-from-file=.env.prod
```

### ⚡ Build Mặc định (Direct Build)
Nếu bạn chạy lệnh build mà không kèm theo tham số `--dart-define-from-file`, hệ thống sẽ sử dụng các giá trị mặc định (**môi trường Dev**) được định nghĩa sẵn trong code:

```bash
flutter build apk
flutter build macos
flutter build windows
```

---

## 🏛 Kiến Trúc & Công Nghệ
- **Architecture**: Clean Architecture + MVVM
- **State Management**: `ChangeNotifier` & `ListenableBuilder`
- **Routing**: `go_router`
- **Networking**: `dio`
- **DI**: `get_it`
- **L10n/I18n**: `slang`
- **Logging**: `logger`
