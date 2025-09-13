import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:sample_a2sv_final/core/network/network_info.dart';
import 'package:sample_a2sv_final/features/home/data/datasources/home_local_data_source.dart';
import 'package:sample_a2sv_final/features/home/data/datasources/home_remote_data_source.dart';
import 'package:sample_a2sv_final/features/home/data/repositories/home_repository_impl.dart';
import 'package:sample_a2sv_final/features/home/domain/repositories/home_repository.dart';
import 'package:sample_a2sv_final/features/home/domain/usecases/get_initial_greeting.dart';
import 'package:sample_a2sv_final/features/home/domain/usecases/send_intent.dart';
import 'package:sample_a2sv_final/features/home/presentation/bloc/home_bloc.dart';

final sl = GetIt.instance; // sl = service locator

Future<void> init() async {
  //! Features - Home
  // Bloc
  sl.registerFactory(
        () => HomeBloc(
      sendIntent: sl(),
      getInitialGreeting: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => SendIntent(sl()));
  sl.registerLazySingleton(() => GetInitialGreeting(sl()));

  // Repository
  sl.registerLazySingleton<HomeRepository>(
        () => HomeRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<HomeRemoteDataSource>(
        () => HomeRemoteDataSourceImpl(client: sl()),
  );
  sl.registerLazySingleton<HomeLocalDataSource>(
        () => HomeLocalDataSourceImpl(sharedPreferences: sl()),
  );

  //! Core
  sl.registerLazySingleton<NetworkInfo>(
        () => NetworkInfoImpl(sl()),
  );

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => InternetConnectionChecker());
}