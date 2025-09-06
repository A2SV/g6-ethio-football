import '../repositories/settings_repo.dart';

/// Fetches the current notification setting from the data layer.
class GetNotificationsEnabledUseCase {
  final SettingsRepository _settingsRepository;

  GetNotificationsEnabledUseCase(this._settingsRepository);

  /// Returns a Stream to listen for real-time changes to the notification setting.
  Stream<bool> call() {
    return _settingsRepository.getNotificationsEnabled();
  }
}
