import 'package:equatable/equatable.dart';
import 'package:ethio_football/core/core_features/domain/entities/theme_type.dart';

// Base event class
abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object> get props => [];
}

// Theme events
class LoadThemeEvent extends SettingsEvent {}

class ThemeChangedEvent extends SettingsEvent {
  final ThemeType theme;

  const ThemeChangedEvent(this.theme);

  @override
  List<Object> get props => [theme];
}

// Notification events
class LoadNotificationEvent extends SettingsEvent {}

class NotificationToggledEvent extends SettingsEvent {
  final bool isEnabled;

  const NotificationToggledEvent(this.isEnabled);

  @override
  List<Object> get props => [isEnabled];
}

// Cache events
class ClearCacheRequestedEvent extends SettingsEvent {}
