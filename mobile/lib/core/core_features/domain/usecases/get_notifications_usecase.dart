import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';
import '../repositories/settings_repo.dart';

/// Use case for getting notifications enabled status.
class GetNotificationsEnabledUseCase {
  final SettingsRepository repository;

  GetNotificationsEnabledUseCase(this.repository);

  Future<Either<Failure, bool>> call() async {
    return await repository.getNotificationsEnabled();
  }
}
