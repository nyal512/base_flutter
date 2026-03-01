import 'package:flutter_dotenv/flutter_dotenv.dart';

enum AppEnvironment { dev, staging, production }

/// Quản lý cấu hình theo môi trường (dev / staging / production).
/// Được khởi tạo 1 lần từ .env và dùng toàn app qua [AppConfig.instance].
class AppConfig {
  static AppConfig? _instance;

  final AppEnvironment environment;
  final String baseUrl;
  final bool enableLogging;
  final Duration connectTimeout;
  final Duration receiveTimeout;

  AppConfig._({
    required this.environment,
    required this.baseUrl,
    required this.enableLogging,
    required this.connectTimeout,
    required this.receiveTimeout,
  });

  /// Khởi tạo AppConfig từ biến môi trường trong .env.
  /// Gọi 1 lần duy nhất trong main() sau khi dotenv đã load.
  static void initialize() {
    final env = dotenv.env['ENVIRONMENT'] ?? 'dev';
    switch (env) {
      case 'production':
        _instance = AppConfig._(
          environment: AppEnvironment.production,
          baseUrl: dotenv.env['BASE_URL'] ?? 'https://api.production.com',
          enableLogging: false,
          connectTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(seconds: 15),
        );
      case 'staging':
        _instance = AppConfig._(
          environment: AppEnvironment.staging,
          baseUrl: dotenv.env['BASE_URL'] ?? 'https://api.staging.com',
          enableLogging: true,
          connectTimeout: const Duration(seconds: 20),
          receiveTimeout: const Duration(seconds: 20),
        );
      default: // dev
        _instance = AppConfig._(
          environment: AppEnvironment.dev,
          baseUrl: dotenv.env['BASE_URL'] ?? 'https://jsonplaceholder.typicode.com',
          enableLogging: true,
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
        );
    }
  }

  /// Truy cập AppConfig đã được khởi tạo.
  static AppConfig get instance {
    assert(_instance != null,
        'AppConfig chưa được khởi tạo. Gọi AppConfig.initialize() trong main() trước.');
    return _instance!;
  }

  bool get isProduction => environment == AppEnvironment.production;
  bool get isDev => environment == AppEnvironment.dev;
  bool get isStaging => environment == AppEnvironment.staging;
}
