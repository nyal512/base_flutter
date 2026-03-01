import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

import 'auth_token_service.dart';

class ApiInterceptor extends Interceptor {
  final AuthTokenService _tokenService;
  final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 5,
      lineLength: 100,
      colors: true,
      printEmojis: true,
    ),
  );

  bool _isRefreshing = false;

  /// Queue các requests đang chờ refresh token hoàn tất.
  final List<({RequestOptions options, ErrorInterceptorHandler handler})> _pendingQueue = [];

  ApiInterceptor({required AuthTokenService tokenService})
      : _tokenService = tokenService;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _logger.i('REQUEST[${options.method}] => PATH: ${options.path}');

    final token = _tokenService.accessToken;
    if (token != null && options.headers['Authorization'] == null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _logger.i(
        'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
    super.onResponse(response, handler);
  }

  @override
  Future<void> onError(
      DioException err, ErrorInterceptorHandler handler) async {
    _logger.e(
      'ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}',
      error: err.error,
      stackTrace: err.stackTrace,
    );

    if (err.response?.statusCode == 401) {
      if (!_isRefreshing) {
        _isRefreshing = true;
        _logger.w('401 gặp phải → bắt đầu refresh token...');

        final newToken = await _tokenService.refreshAccessToken();
        _isRefreshing = false;

        if (newToken != null) {
          _logger.i('Refresh token thành công → retry request gốc và queue.');
          // Retry request gốc với token mới
          err.requestOptions.headers['Authorization'] = 'Bearer $newToken';
          try {
            // Dùng fetch trực tiếp với options đã có đầy đủ baseUrl + path
            final retryResponse = await Dio().fetch(err.requestOptions);
            _resolveQueue(newToken);
            handler.resolve(retryResponse);
          } catch (retryError) {
            _rejectQueue(err);
            handler.next(err);
          }
        } else {
          // Refresh thất bại → toàn bộ queue bị reject
          _logger.e('Refresh token thất bại → session hết hạn.');
          _rejectQueue(err);
          handler.next(err);
        }
      } else {
        // Đang refresh → queue request lại
        _logger.w('Đang refresh → xếp hàng request: ${err.requestOptions.path}');
        _pendingQueue.add((options: err.requestOptions, handler: handler));
        return;
      }
      return;
    }

    super.onError(err, handler);
  }

  /// Retry tất cả request trong queue với token mới.
  void _resolveQueue(String newToken) {
    final queue = List.of(_pendingQueue);
    _pendingQueue.clear();
    for (final item in queue) {
      item.options.headers['Authorization'] = 'Bearer $newToken';
      Dio().fetch(item.options).then(
        (res) => item.handler.resolve(res),
        onError: (e) => item.handler.reject(e as DioException),
      );
    }
  }

  /// Reject tất cả request trong queue.
  void _rejectQueue(DioException err) {
    final queue = List.of(_pendingQueue);
    _pendingQueue.clear();
    for (final item in queue) {
      item.handler.next(err);
    }
  }
}
