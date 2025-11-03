import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';
import '../repositories/settings_repo.dart';

/// Use case for clearing cache.
class ClearCacheUseCase {
  final SettingsRepository repository;

  ClearCacheUseCase(this.repository);

  Future<Either<Failure, void>> call() async {
    return await repository.clearCache();
  }
}
