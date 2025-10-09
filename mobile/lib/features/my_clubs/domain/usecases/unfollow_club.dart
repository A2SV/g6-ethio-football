import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:ethio_football/core/errors/failures.dart';
import 'package:ethio_football/features/my_clubs/domain/repositories/my_clubs_repository.dart';

import '../../../../core/usecase.dart';

class UnfollowClub implements UseCase<Unit, UnfollowClubParams> {
  final MyClubsRepository repository;

  UnfollowClub(this.repository);

  @override
  Future<Either<Failure, Unit>> call(UnfollowClubParams params) async {
    final result = await repository.unfollowClub(params.clubId);
    return result.fold((failure) => Left(failure), (_) => Right(unit));
  }
}

class UnfollowClubParams extends Equatable {
  final String clubId;

  const UnfollowClubParams({required this.clubId});

  @override
  List<Object?> get props => [clubId];
}
