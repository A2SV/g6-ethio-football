import 'package:dartz/dartz.dart';
import 'package:ethio_football/core/core_features/domain/entities/theme_type.dart';
import 'package:ethio_football/core/core_features/domain/repositories/settings_repo.dart';
import 'package:ethio_football/core/errors/failures.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SharedPreferences _prefs;
  static const _themeKey = 'theme_type';
  static const _notificationsKey = 'notifications_enabled';

  SettingsRepositoryImpl(this._prefs);

  // Theme methods
  @override
  Future<Either<Failure, ThemeType>> getTheme() async {
    try {
      final themeIndex =
          _prefs.getInt(_themeKey) ?? ThemeType.SYSTEM_DEFAULT.index;
      final theme = ThemeType.values[themeIndex];
      return Right(theme);
    } catch (e) {
      return Left(CacheFailure('Failed to get theme'));
    }
  }

  @override
  Future<Either<Failure, void>> saveTheme(ThemeType theme) async {
    try {
      final themeIndex = theme.index;
      await _prefs.setInt(_themeKey, themeIndex);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure('Failed to save theme'));
    }
  }

  // Notifications methods
  @override
  Future<Either<Failure, bool>> getNotificationsEnabled() async {
    try {
      final enabled = _prefs.getBool(_notificationsKey) ?? true;
      return Right(enabled);
    } catch (e) {
      return Left(CacheFailure('Failed to get notifications setting'));
    }
  }

  @override
  Future<Either<Failure, void>> setNotificationsEnabled(bool enabled) async {
    try {
      await _prefs.setBool(_notificationsKey, enabled);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure('Failed to save notifications setting'));
    }
  }

  @override
  Future<Either<Failure, void>> clearCache() async {
    try {
      // Implementation for clearing cache
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure('Failed to clear cache'));
    }
  }
}
