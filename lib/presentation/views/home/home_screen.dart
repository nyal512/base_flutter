import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../i18n/strings.g.dart';
import 'bloc/home_bloc.dart';
import 'bloc/home_event.dart';
import 'bloc/home_state.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<HomeBloc>()..add(FetchPostsEvent()),
      child: Scaffold(
        appBar: AppBar(
          title: Text(t.home.title),
          centerTitle: true,
        ),
        body: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            return state.when(
              initial: () => Center(child: Text(t.home.press_refresh)),
              loading: () => const Center(child: CircularProgressIndicator()),
              loaded: (posts) {
                return ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    final post = posts[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12.0),
                      child: ListTile(
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
              error: (message) => Center(
                child: Text(
                  t.home.error.replaceAll('{message}', message),
                  style: const TextStyle(color: Colors.red, fontSize: 16),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
