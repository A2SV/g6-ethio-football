import '../repositories/settings_repo.dart';

/// Sets the state of the notification setting.
class SetNotificationsEnabledUseCase {
  final SettingsRepository _settingsRepository;

  SetNotificationsEnabledUseCase(this._settingsRepository);

  /// Sets the notification setting asynchronously.
  Future<void> call(bool enabled) async {
    await _settingsRepository.setNotificationsEnabled(enabled);
  }
}
