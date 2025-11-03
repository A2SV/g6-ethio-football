import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';
import '../entities/theme_type.dart';
import '../repositories/settings_repo.dart';

/// Use case for getting the current theme.
class GetThemeUseCase {
  final SettingsRepository repository;

  GetThemeUseCase(this.repository);

  Future<Either<Failure, ThemeType>> call() async {
    return await repository.getTheme();
  }
}
