import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/club.dart';
import '../repositories/my_clubs_repository.dart';

class SearchClub {
  final MyClubsRepository repository;

  SearchClub(this.repository);

  /// Returns clubs whose name contains the [query] string
  Future<Either<Failure, List<Club>>> call(String query) async {
    final result = await repository.getAllClubs();
    return result.fold((failure) => Left(failure), (clubs) {
      final filtered = clubs
          .where(
            (club) => club.name.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
      return Right(filtered);
    });
  }
}
