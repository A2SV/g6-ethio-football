/// Use case for fetching comparison data between two clubs.
/// This use case handles the business logic for comparing two teams by their IDs.
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecase.dart';
import '../models/comparison_response.dart';
import '../repositories/comparison_repository.dart';

class GetComparisonDataUseCase
    extends UseCase<ComparisonResponse, ComparisonParams> {
  final ComparisonRepository repository;

  GetComparisonDataUseCase({required this.repository});

  @override
  Future<Either<Failure, ComparisonResponse>> call(
    ComparisonParams params,
  ) async {
    return await repository.getComparisonData(params.clubAId, params.clubBId);
  }
}

class ComparisonParams {
  final int clubAId;
  final int clubBId;

  ComparisonParams({required this.clubAId, required this.clubBId});
}
