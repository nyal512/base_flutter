import 'package:flutter/material.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../i18n/strings.g.dart';
import '../../widgets/widgets.dart';
import 'view_model/home_view_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final HomeViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = sl<HomeViewModel>()..init();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(t.home.title),
        centerTitle: true,
      ),
      body: ListenableBuilder(
        listenable: _viewModel,
        builder: (context, _) {
          if (_viewModel.isLoading) {
            return AppLoading(message: t.home.loading);
          }
          if (_viewModel.hasError) {
            return AppErrorWidget(
              message: t.home.error.replaceAll('{message}', _viewModel.errorMessage!),
              onRetry: _viewModel.onRetry,
            );
          }
          if (_viewModel.posts.isEmpty) {
            return AppEmptyWidget(
              message: t.home.empty,
              icon: Icons.article_outlined,
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: _viewModel.posts.length,
            itemBuilder: (context, index) {
              final post = _viewModel.posts[index];
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
      ),
    );
  }
}
