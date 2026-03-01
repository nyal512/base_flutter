import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../network/api_client.dart';
import '../network/auth_token_service.dart';
import '../network/network_info.dart';
import '../config/env/app_config.dart';
// Data
import '../../data/datasources/post_local_data_source.dart';
import '../../data/datasources/post_remote_data_source.dart';
import '../../data/repositories_impl/post_repository_impl.dart';
import '../../domain/repositories/post_repository.dart';
// Domain
import '../../domain/usecases/get_posts.dart';
// Presentation
import '../../presentation/views/home/bloc/home_bloc.dart';
import '../../presentation/views/home/view_model/home_view_model.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Core — SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  // Dùng AppConfig để lấy baseUrl (hỗ trợ multi-environment)
  final config = AppConfig.instance;

  //! Core — Network
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl());

  sl.registerLazySingleton<AuthTokenService>(
    () => AuthTokenServiceImpl(
      prefs: sl(),
      baseUrl: config.baseUrl,
    ),
  );

  sl.registerLazySingleton(
    () => ApiClient(
      baseUrl: config.baseUrl,
      tokenService: sl(),
    ),
  );

  //! Features - Posts

  // ViewModels
  sl.registerFactory(() => HomeViewModel(bloc: sl()));

  // Bloc
  sl.registerLazySingleton(() => HomeBloc(getPosts: sl()));

  // Use cases
  sl.registerLazySingleton(() => GetPosts(sl()));

  // Repository
  sl.registerLazySingleton<PostRepository>(
    () => PostRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
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
