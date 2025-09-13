import 'package:dartz/dartz.dart'; // For Either
import 'package:sample_a2sv_final/core/error/failures.dart';
import 'package:sample_a2sv_final/core/network/network_info.dart';
import 'package:sample_a2sv_final/features/home/data/datasources/home_local_data_source.dart';
import 'package:sample_a2sv_final/features/home/data/datasources/home_remote_data_source.dart';
import 'package:sample_a2sv_final/features/home/data/models/message_model.dart';
import 'package:sample_a2sv_final/features/home/domain/entities/message.dart';
import 'package:sample_a2sv_final/features/home/domain/repositories/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;
  final HomeLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  HomeRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, ChatMessage>> sendIntent(String query) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteMessage = await remoteDataSource.sendIntent(query);
        // Optionally cache the latest messages here if needed for continuity
        // For simplicity, we'll cache the entire conversation in the BLoC.
        return Right(remoteMessage);
      } on ServerFailure catch (e) {
        return Left(e);
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, ChatMessage>> getInitialGreeting() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteMessage = await remoteDataSource.getInitialGreeting();
        return Right(remoteMessage);
      } on ServerFailure catch (e) {
        return Left(e);
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, List<ChatMessage>>> getCachedMessages() async {
    try {
      final localMessages = await localDataSource.getLastMessages();
      return Right(localMessages);
    } on CacheFailure {
      return Left(CacheFailure());
    }
  }

  @override
  Future<void> cacheCurrentMessages(List<ChatMessage> messages) {
    // Convert ChatMessage entities to MessageModels for caching
    final messageModels = messages.map((e) => MessageModel.fromEntity(e)).toList();
    return localDataSource.cacheMessages(messageModels);
  }
}