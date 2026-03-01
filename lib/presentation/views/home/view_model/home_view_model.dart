import 'package:flutter/material.dart';
import '../../../../core/viewmodel/base_view_model.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';

/// ViewModel cho HomeScreen.
/// Nó 'sở hữu' HomeBloc và cung cấp các hàm tiện ích cho View.
class HomeViewModel extends BaseViewModel {
  final HomeBloc bloc;

  HomeViewModel({required this.bloc});

  @override
  void init() {
    super.init();
    fetchPosts();
  }

  /// Gọi API lấy danh sách posts.
  void fetchPosts() {
    bloc.add(FetchPostsEvent());
  }

  /// Hàm xử lý khi user nhấn Retry.
  void onRetry() {
    fetchPosts();
  }

  /// Logic khi nhấn vào một post.
  /// Có thể xử lý navigation hoặc logging tại đây.
  void onPostOpen(int id) {
    debugPrint('Opening post: $id');
    // Navigation logic here if needed: router.push('/details/$id')
  }

  @override
  void dispose() {
    bloc.close();
    super.dispose();
  }
}
