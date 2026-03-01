import '../../core/error/failure.dart';
import '../../core/usecases/usecase.dart';
import '../../core/utils/result.dart';
import '../entities/post.dart';
import '../repositories/post_repository.dart';

class GetPosts implements UseCase<List<Post>, NoParams> {
  final PostRepository repository;

  GetPosts(this.repository);

  @override
  Future<Result<List<Post>, Failure>> call(NoParams params) async {
    return await repository.getPosts();
  }
}
