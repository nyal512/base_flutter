import '../../core/error/exception.dart';
import '../../core/network/api_client.dart';
import '../models/post_model.dart';

abstract class PostRemoteDataSource {
  Future<List<PostModel>> getPosts();
}

class PostRemoteDataSourceImpl implements PostRemoteDataSource {
  final ApiClient apiClient;

  PostRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<PostModel>> getPosts() async {
    try {
      final response = await apiClient.get('/posts');

      final data = response.data;
      if (data == null || data is! List) {
        throw ServerException(
          message: 'Dữ liệu trả về không hợp lệ',
          statusCode: response.statusCode,
        );
      }

      return data
          .map((json) => PostModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on ServerException {
      rethrow;
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw ServerException(message: 'Lỗi parse dữ liệu: $e');
    }
  }
}
