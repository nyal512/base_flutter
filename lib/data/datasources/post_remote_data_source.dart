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
    final response = await apiClient.get('/posts');
    final List<dynamic> jsonList = response.data;
    return jsonList.map((json) => PostModel.fromJson(json)).toList();
  }
}
