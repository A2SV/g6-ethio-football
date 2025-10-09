import 'package:flutter/material.dart';

class EthiopianFlag extends StatelessWidget {
  const EthiopianFlag({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Image.asset(
          'assets/image/Ethiopian_Premier_League_LOGO.png',
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            // Fallback to original design if image fails to load
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFFE31E24), // Red
                    Color(0xFFFCD116), // Yellow
                    Color(0xFF078930), // Green
                  ],
                  stops: [0.0, 0.5, 1.0],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: const Center(
                child: Icon(
                  Icons.flag,
                  color: Colors.white,
                  size: 12,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class PremierLeagueLogo extends StatelessWidget {
  const PremierLeagueLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Image.asset(
          'assets/image/Premier_League_LogoSmall.png',
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            // Fallback to original design if image fails to load
            return Container(
              decoration: BoxDecoration(
                color: const Color(0xFF37003C), // Purple
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Center(
                child: Text(
                  'PL',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class OnlineBanner extends StatelessWidget {
  const OnlineBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 8,
            height: 8,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Color(0xFF22C55E),
                shape: BoxShape.circle,
              ),
            ),
          ),
          SizedBox(width: 8),
          Builder(
            builder: (context) {
              final screenWidth = MediaQuery.of(context).size.width;
              final isSmallScreen = screenWidth < 360;
              final bannerFontSize = isSmallScreen ? 10.0 : 12.0;

              return Text(
                'You are Online.',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: bannerFontSize,
                  fontWeight: FontWeight.w500,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class BottomNav extends StatelessWidget {
  const BottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0xFFE0E0E0),
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF2E7D32),
        unselectedItemColor: const Color(0xFF9E9E9E),
        selectedLabelStyle:
            const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        unselectedLabelStyle:
            const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.wifi_tethering), label: 'Live Hub'),
          BottomNavigationBarItem(
              icon: Icon(Icons.compare_arrows), label: 'Compare'),
          BottomNavigationBarItem(
              icon: Icon(Icons.article_outlined), label: 'News'),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: 'Settings'),
        ],
        currentIndex: 1,
        onTap: (_) {},
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
