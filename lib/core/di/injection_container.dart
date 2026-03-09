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
import '../../presentation/views/home/view_model/home_view_model.dart';
import '../../presentation/views/sound/view_model/sound_view_model.dart';
import '../../presentation/views/payment/view_model/payment_view_model.dart';
import '../../presentation/views/wallet/view_model/wallet_view_model.dart';
import '../../presentation/views/fingerprint/view_model/fingerprint_view_model.dart';
import '../../presentation/views/summary_format/view_model/summary_format_view_model.dart';
import '../../presentation/views/summary_time/view_model/summary_time_view_model.dart';
import '../../presentation/views/ticket/view_model/ticket_view_model.dart';
import '../../presentation/views/operation_print/view_model/operation_print_view_model.dart';
import '../../presentation/views/network/view_model/network_view_model.dart';
import '../../presentation/views/ordering/view_model/ordering_view_model.dart';
import '../../presentation/views/ftp/view_model/ftp_view_model.dart';
import '../../presentation/views/parent_child/view_model/parent_child_view_model.dart';
import '../../presentation/views/options/view_model/option_1_view_model.dart';
import '../../presentation/views/details/view_model/details_view_model.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Core - SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  // Use AppConfig to get baseUrl (supports multi-environment)
  final config = AppConfig.instance;

  //! Core - Network
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

  // ViewModels - LazySingleton: share instance between content and layout
  sl.registerLazySingleton(() => HomeViewModel(getPosts: sl()));
  sl.registerLazySingleton(() => SoundViewModel());
  sl.registerLazySingleton(() => PaymentViewModel());
  sl.registerLazySingleton(() => WalletViewModel());
  sl.registerLazySingleton(() => FingerprintViewModel());
  sl.registerLazySingleton(() => SummaryFormatViewModel());
  sl.registerLazySingleton(() => SummaryTimeViewModel());
  sl.registerLazySingleton(() => TicketViewModel());
  sl.registerLazySingleton(() => OperationPrintViewModel());
  sl.registerLazySingleton(() => NetworkViewModel());
  sl.registerLazySingleton(() => OrderingViewModel());
  sl.registerLazySingleton(() => FtpViewModel());
  sl.registerLazySingleton(() => ParentChildViewModel());
  sl.registerLazySingleton(() => Option1ViewModel());
  sl.registerLazySingleton(() => DetailsViewModel());

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
