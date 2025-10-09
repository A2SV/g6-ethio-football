import 'package:ethio_football/core/core_features/domain/entities/theme_type.dart';
import 'package:ethio_football/core/core_features/domain/usecases/clear_cache_usecase.dart';
import 'package:ethio_football/core/core_features/domain/usecases/get_notifications_usecase.dart';
import 'package:ethio_football/core/core_features/domain/usecases/get_theme_usecase.dart';
import 'package:ethio_football/core/core_features/domain/usecases/save_theme_usecase.dart';
import 'package:ethio_football/core/core_features/domain/usecases/set_notifications_usecase.dart';
import 'package:ethio_football/features/settings/presentation/bloc/settings_event.dart';
import 'package:ethio_football/features/settings/presentation/bloc/settings_state.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final GetThemeUseCase _getThemeUseCase;
  final SaveThemeUseCase _saveThemeUseCase;
  final GetNotificationsEnabledUseCase _getNotificationsEnabledUseCase;
  final SetNotificationsEnabledUseCase _setNotificationsEnabledUseCase;
  final ClearCacheUseCase _clearCacheUseCase;

  SettingsBloc({
    required GetThemeUseCase getThemeUseCase,
    required SaveThemeUseCase saveThemeUseCase,
    required GetNotificationsEnabledUseCase getNotificationsEnabledUseCase,
    required SetNotificationsEnabledUseCase setNotificationsEnabledUseCase,
    required ClearCacheUseCase clearCacheUseCase,
  }) : _getThemeUseCase = getThemeUseCase,
       _saveThemeUseCase = saveThemeUseCase,
       _getNotificationsEnabledUseCase = getNotificationsEnabledUseCase,
       _setNotificationsEnabledUseCase = setNotificationsEnabledUseCase,
       _clearCacheUseCase = clearCacheUseCase,
       super(ThemeInitial()) {
    // Theme events
    on<LoadThemeEvent>(_onLoadTheme);
    on<ThemeChangedEvent>(_onThemeChanged);

    // Notification events
    on<LoadNotificationEvent>(_onLoadNotification);
    on<NotificationToggledEvent>(_onNotificationToggled);

    // Cache events
    on<ClearCacheRequestedEvent>(_onClearCacheRequested);

    // Load initial theme
    add(LoadThemeEvent());
  }

  // Theme handlers
  Future<void> _onLoadTheme(
    LoadThemeEvent event,
    Emitter<SettingsState> emit,
  ) async {
    try {
      final theme = await _getThemeUseCase().first;
      emit(ThemeLoaded(theme));
    } catch (e) {
      emit(SettingsError('Failed to load theme'));
    }
  }

  Future<void> _onThemeChanged(
    ThemeChangedEvent event,
    Emitter<SettingsState> emit,
  ) async {
    await _saveThemeUseCase(event.theme);
  }

  // Notification handlers
  Future<void> _onLoadNotification(
    LoadNotificationEvent event,
    Emitter<SettingsState> emit,
  ) async {
    try {
      final isEnabled = await _getNotificationsEnabledUseCase().first;
      emit(NotificationStateUpdated(isEnabled));
    } catch (e) {
      emit(SettingsError('Failed to load notification settings'));
    }
  }

  Future<void> _onNotificationToggled(
    NotificationToggledEvent event,
    Emitter<SettingsState> emit,
  ) async {
    await _setNotificationsEnabledUseCase(event.isEnabled);
  }

  // Cache handler
  Future<void> _onClearCacheRequested(
    ClearCacheRequestedEvent event,
    Emitter<SettingsState> emit,
  ) async {
    emit(CacheClearing());
    try {
      await _clearCacheUseCase();
      emit(CacheClearedSuccess());
    } catch (e) {
      emit(SettingsError('Failed to clear cache.'));
    }
  }
}
