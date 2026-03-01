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

  @override
  void init() {
    super.init();
    fetchPosts();
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

  /// Logic khi nhấn vào một post — có thể điều hướng tại đây.
  void onPostOpen(int id) {
    // Navigation: context.go('/details/$id')
  }
}
