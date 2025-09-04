import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecase.dart';
import '../entities/club.dart';
import '../repositories/my_clubs_repository.dart';

class GetAllClubs implements UseCase<List<Club>, NoParams> {
  final MyClubsRepository repository;

  GetAllClubs(this.repository);

  @override
  Future<Either<Failure, List<Club>>> call(NoParams params) async {
    return await repository.getAllClubs();
  }
}
