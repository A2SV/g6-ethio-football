import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../features/home/presentation/pages/home_page.dart';
import '../../../features/home/presentation/bloc/home_bloc.dart';
import '../../../features/club_comparison/presentation/pages/comparison_page.dart';
import '../../../features/live_hub/presentation/pages/live_hub_page.dart';
import '../../../features/settings/presentation/pages/settings_page.dart';
import '../../../features/my_clubs/presentation/pages/my_clubs_page.dart';
import '../../../features/news/presentation/pages/news_page.dart';
import '../../../injection_container.dart' as di;

/// App Router for navigation management.
class AppRouter {
  static const String home = '/';
  static const String clubComparison = '/clubComparison';
  static const String liveHub = '/liveHub';
  static const String settings = '/settings';
  static const String myClubs = '/myClubs';
  static const String news = '/news';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => di.sl<HomeBloc>(),
            child: const HomePage(),
          ),
        );
      case clubComparison:
        return MaterialPageRoute(builder: (_) => const ComparisonPage());
      case liveHub:
        return MaterialPageRoute(builder: (_) => const LiveHubPage());
      case AppRouter.settings:
        return MaterialPageRoute(builder: (_) => const SettingsPage());
      case myClubs:
        return MaterialPageRoute(builder: (_) => const MyClubsPage());
      case news:
        return MaterialPageRoute(builder: (_) => const NewsPage());
      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text('Page not found'))),
        );
    }
  }
}
