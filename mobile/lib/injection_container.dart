import 'package:get_it/get_it.dart';
import 'package:sqflite/sqflite.dart';
import 'package:ethio_football/core/utils/database_helper.dart';
import 'package:ethio_football/features/my_clubs/data/data_sources/my_clubs_local_data.dart';
import 'package:ethio_football/features/my_clubs/data/repositories/my_clubs_repository_impl.dart';
import 'package:ethio_football/features/my_clubs/domain/repositories/my_clubs_repository.dart';
import 'package:ethio_football/features/my_clubs/presentation/bloc/my_clubs_bloc.dart';

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

  //! Core / External

  // DatabaseHelper singleton
  sl.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper.instance);

  // Initialize SQLite database
  final dbHelper = sl<DatabaseHelper>();
  await dbHelper.database; // ensure database is initialized
}
