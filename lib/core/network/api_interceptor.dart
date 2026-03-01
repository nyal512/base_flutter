import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

class ApiInterceptor extends Interceptor {
  final Logger logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 5,
      lineLength: 80,
      colors: true,
      printEmojis: true,
    ),
  );

  String? _accessToken;
  bool _isRefreshing = false;
  final List<Map<String, dynamic>> _requestsQueue = [];

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    logger.i('REQUEST[${options.method}] => PATH: ${options.path}');
    
    // Giả lập lấy Token
    _accessToken ??= 'mock_token_abc123';
    
    if (_accessToken != null && options.headers['Authorization'] == null) {
      options.headers['Authorization'] = 'Bearer $_accessToken';
    }

    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    logger.i(
        'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
    super.onResponse(response, handler);
  }

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    logger.e(
      'ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}',
      error: err.error,
      stackTrace: err.stackTrace,
    );

    if (err.response?.statusCode == 401) {
      // 401 Unauthorized => Cần refresh token
      final RequestOptions options = err.requestOptions;
      
      if (!_isRefreshing) {
        _isRefreshing = true;
        try {
          // Gọi API refresh token (Mock async)
          logger.w('Bắt đầu thử refresh token...');
          await Future.delayed(const Duration(seconds: 2));
          _accessToken = 'new_mock_token_xyz987';
          logger.w('Đã lấy Token mới: $_accessToken');

          // Sau khi có token mới, gỡ lại Request lỗi
          options.headers['Authorization'] = 'Bearer $_accessToken';
          final Dio dioRetry = Dio();
          final response = await dioRetry.fetch(options);
          
          _isRefreshing = false;
          
          // Thực thi các Request xếp hàng
          for (var requestInfo in _requestsQueue) {
            final RequestOptions qOptions = requestInfo['options'];
            final ErrorInterceptorHandler qHandler = requestInfo['handler'];
            
            qOptions.headers['Authorization'] = 'Bearer $_accessToken';
            dioRetry.fetch(qOptions).then(
              (res) => qHandler.resolve(res),
              onError: (e) => qHandler.reject(e as DioException),
            );
          }
          _requestsQueue.clear();

          return handler.resolve(response);
        } catch (e) {
          _isRefreshing = false;
          _requestsQueue.clear();
          return handler.next(err);
        }
      } else {
        // Nếu đang refresh, gom Request này vào hàng đợi
        logger.w('Thêm vào hàng đợi Request: ${options.path}');
        _requestsQueue.add({'options': options, 'handler': handler});
        return; 
      }
    }

    super.onError(err, handler);
  }
}
