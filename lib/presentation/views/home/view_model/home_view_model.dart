import '../../../../core/usecases/usecase.dart';
import '../../../../core/viewmodel/base_view_model.dart';
import '../../../../domain/entities/post.dart';
import '../../../../domain/usecases/get_posts.dart';

/// ViewModel for HomeScreen.
/// Manages UI state: list of posts, loading, errors, and dashboard form data.
class HomeViewModel extends BaseViewModel {
  final GetPosts _getPosts;

  HomeViewModel({required GetPosts getPosts}) : _getPosts = getPosts;

  List<Post> _posts = [];
  List<Post> get posts => _posts;

  // Form State
  int _salesMethod = 0; // 0: Sequential, 1: Single, 2: Bulk
  int _inactivityMode = 0; // 0: No limit, 1: Limit
  String _inactivitySeconds = '10 ～ 90';
  String _consumptionTax = '0 ～ 99';
  String _reducedTax = '0 ～ 99';
  int _eraMode = 0; // 0: AD, 1: Japanese Era
  String _eraBaseYear = '20 [10 ～ 90]';
  String _eraMark = 'A ～ Z';

  // Getters
  int get salesMethod => _salesMethod;
  int get inactivityMode => _inactivityMode;
  String get inactivitySeconds => _inactivitySeconds;
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

  /// Fetches the list of posts from the API.
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

  /// Retries fetching posts.
  void onRetry() => fetchPosts();

  /// Logic to save form data.
  void onSave() {
    // Implement save logic here
  }

  /// Handles clicking on a post.
  void onPostOpen(int id) {
    // Navigation: context.go('/details/$id')
  }
}
