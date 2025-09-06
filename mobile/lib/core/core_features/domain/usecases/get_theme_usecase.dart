import '../entities/theme_type.dart';
import '../repositories/settings_repo.dart';

/// Fetches the current theme setting from the data layer.
class GetThemeUseCase {
  final SettingsRepository _settingsRepository;

  GetThemeUseCase(this._settingsRepository);

  /// The `call` method makes this class callable like a function.
  /// It returns a Stream to listen for real-time changes to the theme.
  Stream<ThemeType> call() {
    return _settingsRepository.getTheme();
  }
}
