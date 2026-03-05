import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/post_model.dart';
import '../../core/error/exception.dart';

const cachedPostsKey = 'CACHED_POSTS';

abstract class PostLocalDataSource {
  Future<List<PostModel>> getLastPosts();
  Future<void> cachePosts(List<PostModel> postsToCache);
}

class PostLocalDataSourceImpl implements PostLocalDataSource {
  final SharedPreferences sharedPreferences;

  PostLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> cachePosts(List<PostModel> postsToCache) {
    // Encodes List<PostModel> to JSON string
    final jsonString = json.encode(postsToCache.map((e) => e.toJson()).toList());
    return sharedPreferences.setString(cachedPostsKey, jsonString);
  }

  @override
  Future<List<PostModel>> getLastPosts() {
    final jsonString = sharedPreferences.getString(cachedPostsKey);
    if (jsonString != null) {
      final List<dynamic> jsonList = json.decode(jsonString);
      return Future.value(jsonList.map((json) => PostModel.fromJson(json)).toList());
    } else {
      throw CacheException(message: 'No data found in cache');
    }
  }
}
