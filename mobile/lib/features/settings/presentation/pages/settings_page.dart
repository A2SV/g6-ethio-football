import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ethio_football/core/utils/database_helper.dart';
import 'package:ethio_football/features/home/presentation/bloc/home_bloc.dart';
import 'package:ethio_football/features/home/presentation/bloc/home_event.dart'
    as home_event;
import 'package:ethio_football/features/my_clubs/presentation/pages/my_clubs_page.dart';
import 'package:ethio_football/features/my_clubs/presentation/bloc/my_clubs_bloc.dart';
import 'package:ethio_football/injection_container.dart' as di;

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isDarkTheme = false;
  bool _notificationsEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Theme Toggle
          ListTile(
            leading: const FaIcon(FontAwesomeIcons.sun),
            title: const Text('Dark Theme'),
            trailing: Switch(
              value: _isDarkTheme,
              onChanged: (isDark) {
                setState(() {
                  _isDarkTheme = isDark;
                });
                // TODO: Implement theme change logic
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Theme change coming soon!')),
                );
              },
            ),
          ),

          // Notification Toggle
          ListTile(
            leading: const FaIcon(FontAwesomeIcons.bell),
            title: const Text('Notifications'),
            trailing: Switch(
              value: _notificationsEnabled,
              onChanged: (isEnabled) {
                setState(() {
                  _notificationsEnabled = isEnabled;
                });
                // TODO: Implement notification settings
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Notification settings coming soon!')),
                );
              },
            ),
          ),

          // Other settings...
          const Divider(),
          ListTile(
            leading: const FaIcon(FontAwesomeIcons.users),
            title: const Text('My Clubs'),
            trailing: const FaIcon(FontAwesomeIcons.chevronRight),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BlocProvider(
                    create: (_) => di.sl<MyClubsBloc>(),
                    child: const MyClubsPage(),
                  ),
                ),
              );
            },
          ),
          ListTile(
            leading: const FaIcon(FontAwesomeIcons.language),
            title: const Text('Language'),
            trailing: const Text('ENG'),
            onTap: () {
              // Show language selection dialog
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Language settings coming soon!')),
              );
            },
          ),

          // Clear Cache Button
          const SizedBox(height: 24),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.green,
            ),
            onPressed: () async {
              // Show confirmation dialog
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Clear Cache'),
                  content: const Text(
                    'This will clear all cached chat messages. This action cannot be undone. Continue?',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      style: TextButton.styleFrom(foregroundColor: Colors.red),
                      child: const Text('Clear'),
                    ),
                  ],
                ),
              );

              if (confirmed == true) {
                try {
                  // Clear chat messages from database
                  final dbHelper = DatabaseHelper.instance;
                  await dbHelper.clearChatMessages();

                  // Clear chat messages from HomeBloc state
                  if (context.mounted) {
                    context.read<HomeBloc>().clearChatMessages();
                  }

                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Chat cache cleared successfully!'),
                      ),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error clearing cache: $e')),
                    );
                  }
                }
              }
            },
            child: const Text('Clear Cache'),
          ),

          // App Info
          const SizedBox(height: 24),
          const Divider(),
          const ListTile(
            leading: FaIcon(FontAwesomeIcons.infoCircle),
            title: Text('App Version'),
            trailing: Text('1.0.0'),
          ),
          const ListTile(
            leading: FaIcon(FontAwesomeIcons.questionCircle),
            title: Text('Help & Support'),
            trailing: FaIcon(FontAwesomeIcons.chevronRight),
          ),
        ],
      ),
    );
  }
}
