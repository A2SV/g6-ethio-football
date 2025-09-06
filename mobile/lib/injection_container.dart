import 'package:ethio_football/core/core_features/domain/repositories/settings_repo.dart';
import 'package:ethio_football/core/core_features/domain/usecases/clear_cache_usecase.dart';
import 'package:ethio_football/core/core_features/domain/usecases/get_notifications_usecase.dart';
import 'package:ethio_football/core/core_features/domain/usecases/get_theme_usecase.dart';
import 'package:ethio_football/core/core_features/domain/usecases/save_theme_usecase.dart';
import 'package:ethio_football/core/core_features/domain/usecases/set_notifications_usecase.dart';
import 'package:ethio_football/features/settings/data/repositories/cache_repository_impl.dart';
import 'package:ethio_football/features/settings/data/repositories/settings_repo_impl.dart';
import 'package:ethio_football/features/settings/domain/repositories/cache_repository.dart';
import 'package:ethio_football/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:sqflite/sqflite.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ethio_football/core/utils/database_helper.dart';
import 'package:ethio_football/features/my_clubs/data/data_sources/my_clubs_local_data.dart';
import 'package:ethio_football/features/my_clubs/data/repositories/my_clubs_repository_impl.dart';
import 'package:ethio_football/features/my_clubs/domain/repositories/my_clubs_repository.dart';
import 'package:ethio_football/features/my_clubs/presentation/bloc/my_clubs_bloc.dart';
import 'package:ethio_football/features/club_comparison/data/datasources/comparison_data_source.dart';
import 'package:ethio_football/features/club_comparison/data/repositories/comparison_repository_impl.dart';
import 'package:ethio_football/features/club_comparison/domain/repositories/comparison_repository.dart';
import 'package:ethio_football/features/club_comparison/domain/usecases/get_clubs_usecase.dart';
import 'package:ethio_football/features/club_comparison/domain/usecases/get_comparison_data_usecase.dart';
import 'package:ethio_football/features/club_comparison/presentation/blocs/comparison_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Features - MyClubs
  // Bloc
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
  // Data Source
  sl.registerLazySingleton<ComparisonDataSource>(() => ComparisonDataSource());

  // Repository
  sl.registerLazySingleton<ComparisonRepository>(
    () => ComparisonRepositoryImpl(dataSource: sl()),
  );

  // Use Cases
  sl.registerLazySingleton(() => GetClubsUseCase(repository: sl()));

  // Bloc
  sl.registerFactory(
    () => ComparisonBloc(getClubsUseCase: sl(), comparisonDataSource: sl()),
  );

  //! Features - Settings
  // Bloc
  sl.registerFactory(
    () => SettingsBloc(
      getThemeUseCase: sl(),
      saveThemeUseCase: sl(),
      getNotificationsEnabledUseCase: sl(),
      setNotificationsEnabledUseCase: sl(),
      clearCacheUseCase: sl(),
    ),
  );

  // Repositories
  sl.registerLazySingleton<SettingsRepository>(
    () => SettingsRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<CacheRepository>(() => CacheRepositoryImpl());

  // Use Cases (Domain Layer)
  sl.registerLazySingleton(() => GetThemeUseCase(sl()));
  sl.registerLazySingleton(() => SaveThemeUseCase(sl()));
  sl.registerLazySingleton(() => GetNotificationsEnabledUseCase(sl()));
  sl.registerLazySingleton(() => SetNotificationsEnabledUseCase(sl()));
  sl.registerLazySingleton(() => ClearCacheUseCase(sl()));

  //! Core / External
  // DatabaseHelper singleton
  sl.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper.instance);

  // SharedPreferences singleton
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  // Initialize SQLite database
  final dbHelper = sl<DatabaseHelper>();
  await dbHelper.database; // ensure database is initialized
  await dbHelper.ensureClubsSeeded(); // ensure clubs are seeded
}
