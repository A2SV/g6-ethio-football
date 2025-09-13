import 'package:dartz/dartz.dart';
import 'package:sample_a2sv_final/core/error/failures.dart';
import 'package:sample_a2sv_final/core/usecases/usecase.dart';
import 'package:sample_a2sv_final/features/home/domain/entities/message.dart';
import 'package:sample_a2sv_final/features/home/domain/repositories/home_repository.dart';

class GetInitialGreeting implements UseCase<ChatMessage, NoParams> {
  final HomeRepository repository;

  GetInitialGreeting(this.repository);

  @override
  Future<Either<Failure, ChatMessage>> call(NoParams params) async {
    return await repository.getInitialGreeting();
  }
}