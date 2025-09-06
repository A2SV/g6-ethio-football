import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import 'core/core_features/domain/entities/theme_type.dart';
import 'features/my_clubs/presentation/bloc/my_clubs_bloc.dart';
import 'features/my_clubs/presentation/pages/my_clubs_page.dart';
import 'features/club_comparison/presentation/blocs/comparison_bloc.dart';
import 'features/club_comparison/presentation/pages/comparison_page.dart';
import 'features/settings/presentation/bloc/settings_bloc.dart';
import 'features/settings/presentation/bloc/settings_state.dart';
import 'features/settings/presentation/pages/settings_page.dart';
import 'features/home/presentation/pages/home_page.dart';
import 'features/live_hub/presentation/live_hub_page.dart';
import 'features/news/presentation/pages/news_page.dart';
import 'injection_container.dart' as di;
import 'injection_container.dart' show sl;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final SettingsBloc _settingsBloc;
  bool _isDarkTheme = false;

  @override
  void initState() {
    super.initState();
    _settingsBloc = GetIt.I<SettingsBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _settingsBloc),
        BlocProvider(create: (_) => GetIt.I<MyClubsBloc>()),
        BlocProvider(create: (_) => GetIt.I<ComparisonBloc>()),
      ],
      child: BlocListener<SettingsBloc, SettingsState>(
        listener: (context, state) {
          if (state is ThemeLoaded) {
            setState(() {
              _isDarkTheme = state.theme == ThemeType.DARK;
            });
          }
        },
        child: MaterialApp(
          title: 'Ethio Football',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.green,
              brightness: Brightness.light,
            ),
            useMaterial3: true,
          ),
          darkTheme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.green,
              brightness: Brightness.dark,
            ),
            useMaterial3: true,
          ),
          themeMode: _isDarkTheme ? ThemeMode.dark : ThemeMode.light,
          home: const MainScreen(),
          routes: {
            '/myClubs': (context) => const MyClubsPage(),
            '/comparison': (context) => const ComparisonPage(),
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _settingsBloc.close();
    super.dispose();
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  static final List<Widget> _pages = <Widget>[
    HomePage(),
    LiveHubPage(),
    BlocProvider<ComparisonBloc>(
      create: (context) => sl<ComparisonBloc>(),
      child: ComparisonPage(),
    ),
    NewsPage(),
    SettingsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.green.shade400,
        unselectedItemColor: Colors.grey.shade600,
        backgroundColor: Colors.grey.shade900,
        selectedIconTheme: IconThemeData(size: 28),
        unselectedIconTheme: IconThemeData(size: 24),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.live_tv_outlined),
            activeIcon: Icon(Icons.live_tv),
            label: 'Live Hub',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.compare_arrows),
            label: 'Compare',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.article_outlined),
            activeIcon: Icon(Icons.article),
            label: 'News',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            activeIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
