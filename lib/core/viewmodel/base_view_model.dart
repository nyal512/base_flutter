import 'package:flutter/foundation.dart';

/// Base class cho tất cả ViewModel trong mô hình MVVM.
/// Mọi ViewModel phải extends class này.
/// Dùng [ChangeNotifier] để View tự động rebuild khi state thay đổi.
abstract class BaseViewModel extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasError => _errorMessage != null;

  /// Cập nhật trạng thái loading và thông báo cho View rebuild.
  @protected
  void setLoading(bool value) {
    if (_isLoading == value) return;
    _isLoading = value;
    notifyListeners();
  }

  /// Set thông báo lỗi và thông báo cho View rebuild.
  @protected
  void setError(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  /// Xóa lỗi hiện tại.
  @protected
  void clearError() => setError(null);

  /// Gọi khi Widget được khởi tạo (initState).
  @mustCallSuper
  void init() {}

  /// Gọi khi Widget bị dispose. ChangeNotifier.dispose() tự dọn listeners.
  @override
  @mustCallSuper
  void dispose() {
    super.dispose();
  }
}
