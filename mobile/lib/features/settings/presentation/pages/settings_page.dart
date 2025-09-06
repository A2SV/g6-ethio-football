import 'package:ethio_football/core/core_features/domain/entities/theme_type.dart';
import 'package:ethio_football/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:ethio_football/features/settings/presentation/bloc/settings_event.dart';
import 'package:ethio_football/features/settings/presentation/bloc/settings_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late final SettingsBloc _settingsBloc;
  bool _isDarkTheme = false;
  bool _notificationsEnabled = false;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _settingsBloc = context.read<SettingsBloc>();
    // Load initial states
    _settingsBloc.add(LoadThemeEvent());
    _settingsBloc.add(LoadNotificationEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: BlocListener<SettingsBloc, SettingsState>(
        listener: (context, state) {
          if (state is ThemeLoaded) {
            setState(() {
              _isDarkTheme = state.theme == ThemeType.DARK;
              _isLoading = false;
            });
          } else if (state is NotificationStateUpdated) {
            setState(() {
              _notificationsEnabled = state.isEnabled;
              _isLoading = false;
            });
          } else if (state is CacheClearedSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Cache cleared successfully!')),
            );
          } else if (state is SettingsError) {
            setState(() {
              _errorMessage = state.message;
              _isLoading = false;
            });
          } else if (state is CacheClearing) {
            setState(() => _isLoading = true);
          }
        },
        child: _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            _errorMessage!,
            style: const TextStyle(color: Colors.red),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        // Theme Toggle
        ListTile(
          leading: const Icon(Icons.wb_sunny_outlined),
          title: const Text('Dark Theme'),
          trailing: Switch(
            value: _isDarkTheme,
            onChanged: (isDark) {
              _settingsBloc.add(
                ThemeChangedEvent(isDark ? ThemeType.DARK : ThemeType.LIGHT),
              );
            },
          ),
        ),

        // Notification Toggle
        ListTile(
          leading: const Icon(Icons.notifications_outlined),
          title: const Text('Notifications'),
          trailing: Switch(
            value: _notificationsEnabled,
            onChanged: (isEnabled) {
              _settingsBloc.add(NotificationToggledEvent(isEnabled));
            },
          ),
        ),

        // Other settings...
        const Divider(),
        ListTile(
          leading: const Icon(Icons.group_outlined),
          title: const Text('My Clubs'),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: () => Navigator.pushNamed(context, '/myClubs'),
        ),
        ListTile(
          leading: const Icon(Icons.language_outlined),
          title: const Text('Language'),
          trailing: const Text('ENG'),
          onTap: () {
            // Show language selection dialog
          },
        ),

        // Clear Cache Button
        const SizedBox(height: 24),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.green,
          ),
          onPressed: () => _settingsBloc.add(ClearCacheRequestedEvent()),
          child: const Text('Clear Cache'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    // Do not close the bloc here as it's managed at the app level
    super.dispose();
  }
}
