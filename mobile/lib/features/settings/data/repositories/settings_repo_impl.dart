import 'package:ethio_football/core/core_features/domain/entities/theme_type.dart';
import 'package:ethio_football/core/core_features/domain/repositories/settings_repo.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SharedPreferences _prefs;
  static const _themeKey = 'theme_type';
  static const _notificationsKey = 'notifications_enabled';

  // Using BehaviorSubject to provide a stream with an initial value
  final _themeSubject = BehaviorSubject<ThemeType>.seeded(
    ThemeType.SYSTEM_DEFAULT,
  );
  final _notificationsSubject = BehaviorSubject<bool>.seeded(true);

  SettingsRepositoryImpl(this._prefs) {
    // Initialize streams with current saved values
    _themeSubject.add(_getSavedTheme());
    _notificationsSubject.add(_getSavedNotifications());
  }

  // Theme methods
  @override
  Stream<ThemeType> getTheme() => _themeSubject.stream;

  @override
  Future<void> saveTheme(ThemeType theme) async {
    final themeIndex = theme.index;
    await _prefs.setInt(_themeKey, themeIndex);
    _themeSubject.add(theme);
  }

  ThemeType _getSavedTheme() {
    final themeIndex =
        _prefs.getInt(_themeKey) ?? ThemeType.SYSTEM_DEFAULT.index;
    return ThemeType.values[themeIndex];
  }

  // Notifications methods
  @override
  Stream<bool> getNotificationsEnabled() => _notificationsSubject.stream;

  @override
  Future<void> setNotificationsEnabled(bool enabled) async {
    await _prefs.setBool(_notificationsKey, enabled);
    _notificationsSubject.add(enabled);
  }

  bool _getSavedNotifications() {
    return _prefs.getBool(_notificationsKey) ?? true;
  }
}
