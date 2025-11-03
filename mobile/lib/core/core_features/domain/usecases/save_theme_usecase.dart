import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';
import '../entities/theme_type.dart';
import '../repositories/settings_repo.dart';

/// Use case for saving the theme.
class SaveThemeUseCase {
  final SettingsRepository repository;

  SaveThemeUseCase(this.repository);

  Future<Either<Failure, void>> call(ThemeType theme) async {
    return await repository.saveTheme(theme);
  }
}
