import 'package:dartz/dartz.dart';

import 'package:ethio_football/core/errors/failures.dart';

import '../entities/chat_message.dart';
import '../repositories/chat_repository.dart';

class SaveChatMessage {
  final ChatRepository repository;

  SaveChatMessage(this.repository);

  Future<Either<Failure, void>> call(ChatMessage message) async {
    return await repository.saveChatMessage(message);
  }
}
