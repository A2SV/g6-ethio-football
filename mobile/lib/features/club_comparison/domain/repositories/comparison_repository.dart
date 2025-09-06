import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../models/comparison_response.dart';
import '../models/team_data.dart';

abstract class ComparisonRepository {
  /// Fetches comparison data for two teams
  Future<Either<Failure, ComparisonResponse>> getComparisonData(
    int clubAId,
    int clubBId,
  );

  /// Fetches all available clubs
  Future<Either<Failure, List<TeamData>>> getClubs();
}
