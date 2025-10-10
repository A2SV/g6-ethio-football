import 'package:dartz/dartz.dart';
import 'package:ethio_football/core/errors/failures.dart';
import '../entities/chat_message.dart';

abstract class HomeRepository {
  Future<Either<Failure, ChatMessage>> sendIntent(String query);
  Future<Either<Failure, ChatMessage>> getInitialGreeting();
  Future<Either<Failure, List<ChatMessage>>> getCachedMessages();
  Future<void> cacheCurrentMessages(List<ChatMessage> messages);
}
