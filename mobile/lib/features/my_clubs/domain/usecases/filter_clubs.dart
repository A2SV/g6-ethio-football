import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/club.dart';
import '../repositories/my_clubs_repository.dart';

class FilterClub {
  final MyClubsRepository repository;

  FilterClub(this.repository);

  /// Filters clubs by league
  Future<Either<Failure, List<Club>>> call({League? league}) async {
    final result = await repository.getAllClubs();
    return result.fold((failure) => Left(failure), (clubs) {
      if (league == null) return Right(clubs);

      final filtered = clubs
          .where(
            (club) => club.league == league,
          ) // assuming club.league is stored as string
          .toList();

      return Right(filtered);
    });
  }
}
