import 'package:dartz/dartz.dart';
import 'package:sample_a2sv_final/core/error/failures.dart';
import 'package:sample_a2sv_final/features/home/domain/entities/message.dart';

abstract class HomeRepository {
  Future<Either<Failure, ChatMessage>> sendIntent(String query);
  Future<Either<Failure, ChatMessage>> getInitialGreeting();
  Future<Either<Failure, List<ChatMessage>>> getCachedMessages();
  Future<void> cacheCurrentMessages(List<ChatMessage> messages);
}