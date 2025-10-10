import 'package:dartz/dartz.dart';

import 'package:ethio_football/core/errors/failures.dart';

import '../entities/chat_message.dart';
import '../repositories/chat_repository.dart';

class GetChatMessages {
  final ChatRepository repository;

  GetChatMessages(this.repository);

  Future<Either<Failure, List<ChatMessage>>> call({int? limit}) async {
    return await repository.getChatMessages(limit: limit);
  }
}
