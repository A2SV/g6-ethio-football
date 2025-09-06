import 'package:flutter/material.dart';
class MyBottomNavigationBar extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;
  const MyBottomNavigationBar({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
  }) : super(key: key);

  @override
  _MyBottomNavigationBarState createState() => _MyBottomNavigationBarState();
}

class _MyBottomNavigationBarState extends State<MyBottomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.cast), // Using cast as a placeholder for Live Hub
          label: 'Live Hub',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.compare_arrows), // Using compare_arrows for Compare
          label: 'Compare',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.article), // Using article for News
          label: 'News',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Settings',
        ),
      ],
      currentIndex: widget.selectedIndex,
      selectedItemColor: Color(0xFF1E392A),
      unselectedItemColor: Colors.grey,
      onTap: widget.onItemTapped,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
    );
  }
}