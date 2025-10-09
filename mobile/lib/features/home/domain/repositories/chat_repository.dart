import 'package:dartz/dartz.dart';
import 'package:ethio_football/core/errors/failures.dart';

import '../entities/chat_message.dart';

abstract class ChatRepository {
  Future<Either<Failure, List<ChatMessage>>> getChatMessages({int? limit});
  Future<Either<Failure, void>> saveChatMessage(ChatMessage message);
  Future<Either<Failure, void>> deleteChatMessage(String messageId);
  Future<Either<Failure, void>> clearAllMessages();
}
