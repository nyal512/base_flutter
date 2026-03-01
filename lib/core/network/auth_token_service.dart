import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthTokenService {
  String? get accessToken;
  String? get refreshToken;

  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  });

  Future<void> clearTokens();

  /// Gọi API refresh token và trả về access token mới.
  /// Trả về null nếu refresh thất bại (session hết hạn).
  Future<String?> refreshAccessToken();
}

class AuthTokenServiceImpl implements AuthTokenService {
  final SharedPreferences _prefs;
  final Dio _refreshDio;

  static const _accessTokenKey = 'ACCESS_TOKEN';
  static const _refreshTokenKey = 'REFRESH_TOKEN';

  String? _cachedAccessToken;
  String? _cachedRefreshToken;

  /// [baseUrl]: dùng để gọi endpoint refresh token.
  /// [refreshEndpoint]: đường dẫn API refresh, mặc định '/auth/refresh'.
  AuthTokenServiceImpl({
    required SharedPreferences prefs,
    required String baseUrl,
    String refreshEndpoint = '/auth/refresh',
  })  : _prefs = prefs,
        // Dio riêng biệt, KHÔNG có interceptor → tránh vòng lặp vô hạn khi refresh
        _refreshDio = Dio(
          BaseOptions(
            baseUrl: baseUrl,
            connectTimeout: const Duration(seconds: 15),
            receiveTimeout: const Duration(seconds: 15),
          ),
        ) {
    // Load token từ storage khi khởi tạo
    _cachedAccessToken = _prefs.getString(_accessTokenKey);
    _cachedRefreshToken = _prefs.getString(_refreshTokenKey);
  }

  @override
  String? get accessToken => _cachedAccessToken;

  @override
  String? get refreshToken => _cachedRefreshToken;

  @override
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    _cachedAccessToken = accessToken;
    _cachedRefreshToken = refreshToken;
    await Future.wait([
      _prefs.setString(_accessTokenKey, accessToken),
      _prefs.setString(_refreshTokenKey, refreshToken),
    ]);
  }

  @override
  Future<void> clearTokens() async {
    _cachedAccessToken = null;
    _cachedRefreshToken = null;
    await Future.wait([
      _prefs.remove(_accessTokenKey),
      _prefs.remove(_refreshTokenKey),
    ]);
  }

  @override
  Future<String?> refreshAccessToken() async {
    if (_cachedRefreshToken == null) return null;
    try {
      final response = await _refreshDio.post(
        '/auth/refresh',
        data: {'refresh_token': _cachedRefreshToken},
      );
      final newAccess = response.data['access_token'] as String;
      final newRefresh = response.data['refresh_token'] as String? ?? _cachedRefreshToken!;
      await saveTokens(accessToken: newAccess, refreshToken: newRefresh);
      return newAccess;
    } catch (_) {
      // Refresh thất bại → xoá token, buộc user đăng nhập lại
      await clearTokens();
      return null;
    }
  }
}
