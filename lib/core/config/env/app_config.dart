
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

  /// Initializes AppConfig from environment variables provided at build time.
  /// Uses --dart-define-from-file=.env.xxx
  static void initialize() {
    const envStr = String.fromEnvironment('ENVIRONMENT', defaultValue: 'dev');
    const baseUrl = String.fromEnvironment('BASE_URL',
        defaultValue: 'https://jsonplaceholder.typicode.com');
    const logging = String.fromEnvironment('ENABLE_LOGGING', defaultValue: 'true') == 'true';

    final env = AppEnvironment.values.firstWhere(
      (e) => e.name == envStr,
      orElse: () => AppEnvironment.dev,
    );

    switch (env) {
      case AppEnvironment.production:
        _instance = AppConfig._(
          environment: AppEnvironment.production,
          baseUrl: baseUrl,
          enableLogging: logging,
          connectTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(seconds: 15),
        );
      case AppEnvironment.staging:
        _instance = AppConfig._(
          environment: AppEnvironment.staging,
          baseUrl: baseUrl,
          enableLogging: logging,
          connectTimeout: const Duration(seconds: 20),
          receiveTimeout: const Duration(seconds: 20),
        );
      case AppEnvironment.dev:
        _instance = AppConfig._(
          environment: AppEnvironment.dev,
          baseUrl: baseUrl,
          enableLogging: logging,
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
