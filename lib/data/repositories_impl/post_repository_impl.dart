import '../../core/error/exception.dart';
import '../../core/error/failure.dart';
import '../../core/utils/result.dart';
import '../../domain/entities/post.dart';
import '../../domain/repositories/post_repository.dart';
import '../datasources/post_remote_data_source.dart';
import '../datasources/post_local_data_source.dart';

class PostRepositoryImpl implements PostRepository {
  final PostRemoteDataSource remoteDataSource;
  final PostLocalDataSource localDataSource;

  PostRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Result<List<Post>, Failure>> getPosts() async {
    try {
      // 1. Lấy dữ liệu từ Internet
      final remotePosts = await remoteDataSource.getPosts();
      
      // 2. Cache lại dữ liệu mới nhất
      await localDataSource.cachePosts(remotePosts);
      
      return Success(remotePosts);
    } on NetworkException catch (e) {
      // 3. Nếu mất kết nối, tìm dữ liệu trong Cache
      try {
        final localPosts = await localDataSource.getLastPosts();
        return Success(localPosts);
      } on CacheException {
        return FailureResult(NetworkFailure(e.message));
      }
    } on ServerException catch (e) {
      return FailureResult(ServerFailure(e.message));
    } catch (e) {
      return FailureResult(ServerFailure('Lỗi không xác định: $e'));
    }
  }
}
