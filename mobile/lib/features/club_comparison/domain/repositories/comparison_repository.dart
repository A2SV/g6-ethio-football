/// Abstract repository interface for club comparison operations.
/// Defines methods for fetching comparison data between two clubs and retrieving the list of available clubs.
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
