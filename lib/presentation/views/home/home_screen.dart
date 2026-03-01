import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../i18n/strings.g.dart';
import '../../widgets/widgets.dart';
import 'bloc/home_bloc.dart';
import 'bloc/home_state.dart';
import 'view_model/home_view_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // ViewModel
  final HomeViewModel _viewModel = sl<HomeViewModel>();

  @override
  void initState() {
    super.initState();
    _viewModel.init();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _viewModel.bloc,
      child: Scaffold(
        appBar: AppBar(
          title: Text(t.home.title),
          centerTitle: true,
        ),
        body: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            return state.when(
              initial: () => Center(child: Text(t.home.press_refresh)),
              loading: () => const AppLoading(message: 'Đang tải dữ liệu...'),
              loaded: (posts) {
                if (posts.isEmpty) {
                  return const AppEmptyWidget(
                    message: 'Không có bài viết nào',
                    icon: Icons.article_outlined,
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    final post = posts[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12.0),
                      child: ListTile(
                        onTap: () => _viewModel.onPostOpen(post.id),
                        title: Text(
                          post.title,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(post.body),
                        leading: CircleAvatar(
                          child: Text(post.id.toString()),
                        ),
                      ),
                    );
                  },
                );
              },
              error: (message) => AppErrorWidget(
                message: t.home.error.replaceAll('{message}', message),
                onRetry: _viewModel.onRetry,
              ),
            );
          },
        ),
      ),
    );
  }
}
