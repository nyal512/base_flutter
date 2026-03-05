import 'package:logger/logger.dart';

/// Singleton Logger used throughout the app.
/// Use this instead of creating a new Logger instance in each class.
///
/// Example usage:
/// ```dart
/// AppLogger.i('Request success');
/// AppLogger.e('Something went wrong', error: e, stackTrace: st);
/// ```
class AppLogger {
  AppLogger._();

  static final Logger _instance = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 8,
      lineLength: 100,
      colors: true,
      printEmojis: true,
    ),
  );

  static Logger get instance => _instance;

  static void d(dynamic message) => _instance.d(message);
  static void i(dynamic message) => _instance.i(message);
  static void w(dynamic message) => _instance.w(message);
  static void e(
    dynamic message, {
    DateTime? time,
    Object? error,
    StackTrace? stackTrace,
  }) =>
      _instance.e(message, time: time, error: error, stackTrace: stackTrace);
}
