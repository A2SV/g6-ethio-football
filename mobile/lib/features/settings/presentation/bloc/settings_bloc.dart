import 'package:ethio_football/core/core_features/domain/entities/theme_type.dart';
import 'package:ethio_football/core/core_features/domain/usecases/clear_cache_usecase.dart';
import 'package:ethio_football/core/core_features/domain/usecases/get_notifications_usecase.dart';
import 'package:ethio_football/core/core_features/domain/usecases/get_theme_usecase.dart';
import 'package:ethio_football/core/core_features/domain/usecases/save_theme_usecase.dart';
import 'package:ethio_football/core/core_features/domain/usecases/set_notifications_usecase.dart';
import 'package:ethio_football/features/settings/presentation/bloc/settings_event.dart';
import 'package:ethio_football/features/settings/presentation/bloc/settings_state.dart';
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
  })  : _getThemeUseCase = getThemeUseCase,
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
  }

  // Theme handlers
  Future<void> _onLoadTheme(
    LoadThemeEvent event,
    Emitter<SettingsState> emit,
  ) async {
    try {
      await emit.onEach<ThemeType>(
        _getThemeUseCase(),
        onData: (theme) => emit(ThemeLoaded(theme)),
        onError: (_, __) => emit(SettingsError('Failed to load theme')),
      );
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
      await emit.onEach<bool>(
        _getNotificationsEnabledUseCase(),
        onData: (isEnabled) => emit(NotificationStateUpdated(isEnabled)),
        onError: (_, __) => emit(SettingsError('Failed to load notification settings')),
      );
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
