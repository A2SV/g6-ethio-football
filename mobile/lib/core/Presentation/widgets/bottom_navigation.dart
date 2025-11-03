import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/// Bottom navigation widget for the app.
class BottomNavigation extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
          icon: FaIcon(FontAwesomeIcons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: FaIcon(FontAwesomeIcons.balanceScale),
          label: 'Compare',
        ),
        BottomNavigationBarItem(
          icon: FaIcon(FontAwesomeIcons.tv),
          label: 'Live Hub',
        ),
        BottomNavigationBarItem(
          icon: FaIcon(FontAwesomeIcons.newspaper),
          label: 'News',
        ),
        BottomNavigationBarItem(
          icon: FaIcon(FontAwesomeIcons.cog),
          label: 'Settings',
        ),
      ],
    );
  }
}
