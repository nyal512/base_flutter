import '../../core/error/failure.dart';
import '../../core/utils/result.dart';
import '../entities/post.dart';

abstract class PostRepository {
  Future<Result<List<Post>, Failure>> getPosts();
}
