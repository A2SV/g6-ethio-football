import 'package:dartz/dartz.dart';
import 'package:ethio_football/core/errors/failures.dart';
import 'package:ethio_football/core/usecase.dart';
import 'package:ethio_football/features/home/domain/entities/chat_message.dart';
import 'package:ethio_football/features/home/domain/repositories/chat_repository.dart';

class GetInitialGreeting implements UseCase<List<ChatMessage>, NoParams> {
  final ChatRepository repository;

  GetInitialGreeting(this.repository);

  @override
  Future<Either<Failure, List<ChatMessage>>> call(NoParams params) async {
    return await repository.getChatMessages();
  }
}
