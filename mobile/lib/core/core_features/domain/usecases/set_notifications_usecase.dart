import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';
import '../repositories/settings_repo.dart';

/// Use case for setting notifications enabled status.
class SetNotificationsEnabledUseCase {
  final SettingsRepository repository;

  SetNotificationsEnabledUseCase(this.repository);

  Future<Either<Failure, void>> call(bool enabled) async {
    return await repository.setNotificationsEnabled(enabled);
  }
}
