import 'package:flutter/material.dart';
import '../../../widgets/save_dialogs.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/viewmodel/base_view_model.dart';
import '../../../../domain/entities/post.dart';
import '../../../../domain/usecases/get_posts.dart';

/// ViewModel cho HomeScreen.
/// Tự quản lý trạng thái UI: danh sách posts, loading, lỗi.
/// Gọi thẳng UseCase mà không cần Bloc làm trung gian.
class HomeViewModel extends BaseViewModel {
  final GetPosts _getPosts;

  HomeViewModel({required GetPosts getPosts}) : _getPosts = getPosts;

  List<Post> _posts = [];
  List<Post> get posts => _posts;

  // Form State
  int _salesMethod = 0; // 0: Sequential, 1: Single, 2: Bulk
  int _inactivityMode = 0; // 0: No limit, 1: Limit
  String _inactivitySeconds = '10';
  final List<String> _inactivityOptions = ['10', '20', '30', '40', '50', '60', '70', '80', '90'];
  String _consumptionTax = '';
  String _reducedTax = '';
  int _eraMode = 0; // 0: AD, 1: Japanese Era
  String _eraBaseYear = '';
  String _eraMark = '';

  // Getters
  int get salesMethod => _salesMethod;
  int get inactivityMode => _inactivityMode;
  String get inactivitySeconds => _inactivitySeconds;
  List<String> get inactivityOptions => _inactivityOptions;
  String get consumptionTax => _consumptionTax;
  String get reducedTax => _reducedTax;
  int get eraMode => _eraMode;
  String get eraBaseYear => _eraBaseYear;
  String get eraMark => _eraMark;

  // Setters/Updaters
  void setSalesMethod(int value) {
    _salesMethod = value;
    notifyListeners();
  }

  void setInactivityMode(int value) {
    _inactivityMode = value;
    notifyListeners();
  }

  void setInactivitySeconds(String value) {
    _inactivitySeconds = value;
    notifyListeners();
  }

  void setConsumptionTax(String value) {
    _consumptionTax = value;
    notifyListeners();
  }

  void setReducedTax(String value) {
    _reducedTax = value;
    notifyListeners();
  }

  void setEraMode(int value) {
    _eraMode = value;
    notifyListeners();
  }

  void setEraBaseYear(String value) {
    _eraBaseYear = value;
    notifyListeners();
  }

  void setEraMark(String value) {
    _eraMark = value;
    notifyListeners();
  }

  @override
  void init() {
    super.init();
    fetchPosts();
  }

  @override
  void dispose() {
    // Keep dispose if needed
    super.dispose();
  }

  /// Gọi API lấy danh sách posts.
  Future<void> fetchPosts() async {
    setLoading(true);
    clearError();

    final result = await _getPosts(NoParams());

    result.fold(
      (failure) => setError(failure.message),
      (posts) => _posts = posts,
    );

    setLoading(false);
  }

  /// Hàm xử lý khi user nhấn Retry.
  void onRetry() => fetchPosts();

  /// Logic lưu dữ liệu form.
  void onSave(BuildContext context) async {
    // Show first dialog: SaveTargetDialog
    final bool? targetResult = await showDialog<bool>(
      context: context,
      builder: (context) => const SaveTargetDialog(),
    );

    if (targetResult == true) {
      // Show second dialog: SaveDataSetDialog
      if (!context.mounted) return;
      final int? dataSetResult = await showDialog<int>(
        context: context,
        builder: (context) => const SaveDataSetDialog(),
      );

      if (dataSetResult != null) {
        debugPrint('Saving Home Form Data to DataSet ${dataSetResult + 1}...');
        // Finalize save logic
      }
    }
  }

  /// Logic khi nhấn vào một post — có thể điều hướng tại đây.
  void onPostOpen(int id) {
    // Navigation: context.go('/details/$id')
  }
}
