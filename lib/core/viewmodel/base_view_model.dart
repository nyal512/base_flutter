/// Base class cho các ViewModel trong mô hình MVVM.
/// ViewModel quản lý UI Logic và kết nối View với Business Logic (Bloc).
abstract class BaseViewModel {
  /// Hàm khởi tạo, có thể dùng để subcribe streams hoặc init controllers.
  void init() {}

  /// Hàm dispose để giải phóng tài nguyên.
  void dispose() {}
}
