import '../../core/error/exception.dart';
import '../../core/error/failure.dart';
import '../../core/network/network_info.dart';
import '../../core/utils/result.dart';
import '../../domain/entities/post.dart';
import '../../domain/repositories/post_repository.dart';
import '../datasources/post_remote_data_source.dart';
import '../datasources/post_local_data_source.dart';

class PostRepositoryImpl implements PostRepository {
  final PostRemoteDataSource remoteDataSource;
  final PostLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  PostRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Result<List<Post>, Failure>> getPosts() async {
    if (await networkInfo.isConnected) {
      // Online -> fetch from server and cache
      try {
        final remotePosts = await remoteDataSource.getPosts();
        await localDataSource.cachePosts(remotePosts);
        return Success(remotePosts);
      } on ServerException catch (e) {
        return FailureResult(ServerFailure(e.message));
      } catch (e) {
        return FailureResult(ServerFailure('Unknown error: $e'));
      }
    } else {
      // Offline -> search in cache
      try {
        final localPosts = await localDataSource.getLastPosts();
        return Success(localPosts);
      } on CacheException {
        return const FailureResult(
          NetworkFailure('No internet connection and no cached data available'),
        );
      }
    }
  }
}
