import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../routers/app_router.dart';
import '../widgets/bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../features/home/presentation/pages/home_page.dart';
import '../../../features/home/presentation/bloc/home_bloc.dart';
import '../../../features/club_comparison/presentation/pages/comparison_page.dart';
import '../../../features/club_comparison/presentation/blocs/comparison_bloc.dart';
import '../../../features/live_hub/presentation/pages/live_hub_page.dart';
import '../../../features/live_hub/presentation/bloc/football_bloc.dart';
import '../../../features/settings/presentation/pages/settings_page.dart';
import '../../../features/settings/presentation/bloc/settings_bloc.dart';
import '../../../features/news/presentation/pages/news_page.dart';
import '../../../features/news/presentation/bloc/news_bloc.dart';
import '../../../injection_container.dart' as di;

/// Main page with bottom navigation.
class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    BlocProvider(create: (_) => di.sl<HomeBloc>(), child: const HomePage()),
    BlocProvider(
      create: (_) => di.sl<ComparisonBloc>(),
      child: const ComparisonPage(),
    ),
    BlocProvider(
      create: (_) => di.sl<FootballBloc>(),
      child: const LiveHubPage(),
    ),
    BlocProvider(create: (_) => di.sl<NewsBloc>(), child: const NewsPage()),
    BlocProvider(
      create: (_) => di.sl<SettingsBloc>(),
      child: const SettingsPage(),
    ),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigation(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
    );
  }
}
