import 'package:ethio_football/core/core_features/domain/entities/theme_type.dart';
import 'package:ethio_football/core/core_features/domain/repositories/settings_repo.dart';

/// Saves the user's selected theme setting.
class SaveThemeUseCase {
  final SettingsRepository _settingsRepository;

  SaveThemeUseCase(this._settingsRepository);

  /// Saves the theme asynchronously.
  Future<void> call(ThemeType theme) async {
    await _settingsRepository.saveTheme(theme);
  }
}
