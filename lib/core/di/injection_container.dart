import 'package:get_it/get_it.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../network/api_client.dart';
// Data
import '../../data/datasources/post_local_data_source.dart';
import '../../data/datasources/post_remote_data_source.dart';
import '../../data/repositories_impl/post_repository_impl.dart';
import '../../domain/repositories/post_repository.dart';
// Domain
import '../../domain/usecases/get_posts.dart';
// Presentation
import '../../presentation/views/home/bloc/home_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Core
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  final String baseUrl = dotenv.env['BASE_URL'] ?? 'https://jsonplaceholder.typicode.com';
  sl.registerLazySingleton(() => ApiClient(baseUrl: baseUrl));

  //! Features - Posts
  // Bloc
  sl.registerFactory(() => HomeBloc(getPosts: sl()));

  // Use cases
  sl.registerLazySingleton(() => GetPosts(sl()));

  // Repository
  sl.registerLazySingleton<PostRepository>(
    () => PostRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<PostRemoteDataSource>(
    () => PostRemoteDataSourceImpl(apiClient: sl()),
  );
  sl.registerLazySingleton<PostLocalDataSource>(
    () => PostLocalDataSourceImpl(sharedPreferences: sl()),
  );
}
