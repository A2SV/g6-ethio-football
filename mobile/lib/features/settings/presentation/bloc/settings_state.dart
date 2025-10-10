import 'package:equatable/equatable.dart';

import '../../../../core/core_features/domain/entities/theme_type.dart';

// Base state
abstract class SettingsState extends Equatable {
  const SettingsState();

  @override
  List<Object> get props => [];
}

// Theme specific states
abstract class ThemeState extends SettingsState {
  final ThemeType theme;
  
  const ThemeState(this.theme);
  
  @override
  List<Object> get props => [theme];
}

class ThemeInitial extends ThemeState {
  const ThemeInitial() : super(ThemeType.LIGHT);
}

class ThemeLoaded extends ThemeState {
  const ThemeLoaded(ThemeType theme) : super(theme);
}

// Notification specific states
abstract class NotificationState extends SettingsState {
  final bool isEnabled;
  
  const NotificationState(this.isEnabled);
  
  @override
  List<Object> get props => [isEnabled];
}

class NotificationInitial extends NotificationState {
  const NotificationInitial() : super(false);
}

class NotificationStateUpdated extends NotificationState {
  const NotificationStateUpdated(bool isEnabled) : super(isEnabled);
}

// Error state
class SettingsError extends SettingsState {
  final String message;

  const SettingsError(this.message);

  @override
  List<Object> get props => [message];
}

// Cache states
class CacheClearing extends SettingsState {}

class CacheClearedSuccess extends SettingsState {}
