import 'package:get_it/get_it.dart';
import 'package:sqflite/sqflite.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ethio_football/core/utils/database_helper.dart';
import 'package:ethio_football/core/network/http_client.dart';
import 'package:ethio_football/features/my_clubs/data/data_sources/my_clubs_local_data.dart';
import 'package:ethio_football/features/my_clubs/data/repositories/my_clubs_repository_impl.dart';
import 'package:ethio_football/features/my_clubs/domain/repositories/my_clubs_repository.dart';
import 'package:ethio_football/features/my_clubs/presentation/bloc/my_clubs_bloc.dart';
import 'package:ethio_football/features/home/presentation/bloc/home_bloc.dart';
import 'package:ethio_football/features/club_comparison/data/datasources/comparison_data_source.dart';
import 'package:ethio_football/features/club_comparison/data/repositories/comparison_repository_impl.dart';
import 'package:ethio_football/features/club_comparison/domain/repositories/comparison_repository.dart';
import 'package:ethio_football/features/club_comparison/domain/usecases/get_clubs_usecase.dart';
import 'package:ethio_football/features/club_comparison/domain/usecases/get_comparison_data_usecase.dart';
import 'package:ethio_football/features/club_comparison/presentation/blocs/comparison_bloc.dart';
import 'package:ethio_football/features/live_hub/data/football_api_client.dart';
import 'package:ethio_football/features/live_hub/data/football_repository_impl.dart';
import 'package:ethio_football/features/live_hub/domain/football_repository.dart';
import 'package:ethio_football/features/live_hub/domain/usecases.dart';
import 'package:ethio_football/features/live_hub/presentation/bloc/football_bloc.dart';
import 'package:ethio_football/features/settings/data/repositories/settings_repo_impl.dart';
import 'package:ethio_football/features/settings/domain/repositories/cache_repository.dart';
import 'package:ethio_football/features/settings/data/repositories/cache_repository_impl.dart';
import 'package:ethio_football/core/core_features/domain/repositories/settings_repo.dart';
import 'package:ethio_football/core/core_features/domain/usecases/get_theme_usecase.dart';
import 'package:ethio_football/core/core_features/domain/usecases/save_theme_usecase.dart';
import 'package:ethio_football/core/core_features/domain/usecases/get_notifications_usecase.dart';
import 'package:ethio_football/core/core_features/domain/usecases/set_notifications_usecase.dart';
import 'package:ethio_football/core/core_features/domain/usecases/clear_cache_usecase.dart';
import 'package:ethio_football/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:ethio_football/features/news/domain/repositories/news_repository.dart';
import 'package:ethio_football/features/news/data/repositories/news_repository_impl.dart';
import 'package:ethio_football/features/news/data/datasources/news_local_data_source.dart';
import 'package:ethio_football/features/news/presentation/bloc/news_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Features - Home
  sl.registerFactory(() => HomeBloc());

  //! Features - MyClubs
  sl.registerFactory(() => MyClubsBloc(repository: sl()));

  // Repository
  sl.registerLazySingleton<MyClubsRepository>(
    () => MyClubsRepositoryImpl(localDataSource: sl()),
  );

  // Local Data Source
  sl.registerLazySingleton<MyClubsLocalDataSource>(
    () => MyClubsLocalDataSourceImpl(),
  );

  //! Features - Club Comparison
  sl.registerFactory(
    () => ComparisonBloc(
      getClubsUseCase: sl(),
      getComparisonDataUseCase: sl(),
      comparisonRepository: sl(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(() => GetClubsUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetComparisonDataUseCase(repository: sl()));

  // Repository
  sl.registerLazySingleton<ComparisonRepository>(
    () => ComparisonRepositoryImpl(dataSource: sl()),
  );

  // Data Source
  sl.registerLazySingleton<ComparisonDataSource>(
    () => ComparisonDataSource(sl()),
  );

  //! Features - Live Hub
  sl.registerFactory(
    () => FootballBloc(
      getStandings: sl(),
      getFixtures: sl(),
      getLiveScores: sl(),
      getPreviousFixtures: sl(),
      getLiveMatches: sl(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(() => GetStandings(sl()));
  sl.registerLazySingleton(() => GetFixtures(sl()));
  sl.registerLazySingleton(() => GetLiveScores(sl()));
  sl.registerLazySingleton(() => GetPreviousFixtures(sl()));
  sl.registerLazySingleton(() => GetLiveMatches(sl()));

  // Repository
  sl.registerLazySingleton<FootballRepository>(
    () => FootballRepositoryImpl(sl()),
  );

  // API Client
  sl.registerLazySingleton<FootballApiClient>(() => FootballApiClient(sl()));

  //! Features - Settings
  sl.registerFactory(
    () => SettingsBloc(
      getThemeUseCase: sl(),
      saveThemeUseCase: sl(),
      getNotificationsEnabledUseCase: sl(),
      setNotificationsEnabledUseCase: sl(),
      clearCacheUseCase: sl(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(() => GetThemeUseCase(sl()));
  sl.registerLazySingleton(() => SaveThemeUseCase(sl()));
  sl.registerLazySingleton(() => GetNotificationsEnabledUseCase(sl()));
  sl.registerLazySingleton(() => SetNotificationsEnabledUseCase(sl()));
  sl.registerLazySingleton(() => ClearCacheUseCase(sl()));

  // Repositories
  sl.registerLazySingleton<SettingsRepository>(
    () => SettingsRepositoryImpl(sl()),
  );

  sl.registerLazySingleton<CacheRepository>(() => CacheRepositoryImpl());

  // External
  sl.registerLazySingletonAsync<SharedPreferences>(
    () async => await SharedPreferences.getInstance(),
  );

  //! Core / External

  // HTTP Client
  sl.registerLazySingleton(() => HttpClient());

  // DatabaseHelper singleton
  sl.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper.instance);

  // Initialize SQLite database
  final dbHelper = sl<DatabaseHelper>();
  await dbHelper.database; // ensure database is initialized

  //! Features - News
  sl.registerFactory(() => NewsBloc(repository: sl()));

  // Repository
  sl.registerLazySingleton<NewsRepository>(
    () => NewsRepositoryImpl(localDataSource: sl()),
  );

  // Data Source
  sl.registerLazySingleton<NewsLocalDataSource>(
    () => NewsLocalDataSourceImpl(),
  );
}
