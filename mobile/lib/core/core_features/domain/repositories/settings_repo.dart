import '../entities/theme_type.dart';

abstract class SettingsRepository {
  Stream<ThemeType> getTheme();
  Future<void> saveTheme(ThemeType theme);

  Stream<bool> getNotificationsEnabled();
  Future<void> setNotificationsEnabled(bool enabled);
}
