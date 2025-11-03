import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';
import '../entities/theme_type.dart';

/// Abstract repository for settings-related operations.
abstract class SettingsRepository {
  /// Get the current theme type.
  Future<Either<Failure, ThemeType>> getTheme();

  /// Save the theme type.
  Future<Either<Failure, void>> saveTheme(ThemeType theme);

  /// Get notifications enabled status.
  Future<Either<Failure, bool>> getNotificationsEnabled();

  /// Set notifications enabled status.
  Future<Either<Failure, void>> setNotificationsEnabled(bool enabled);

  /// Clear cache.
  Future<Either<Failure, void>> clearCache();
}
