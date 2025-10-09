/// Use case for retrieving the list of available clubs for comparison.
/// This use case encapsulates the business logic for fetching clubs from the repository.
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecase.dart';
import '../models/team_data.dart';
import '../repositories/comparison_repository.dart';

class GetClubsUseCase extends UseCase<List<TeamData>, NoParams> {
  final ComparisonRepository repository;

  GetClubsUseCase({required this.repository});

  @override
  Future<Either<Failure, List<TeamData>>> call(NoParams params) async {
    return await repository.getClubs();
  }
}
