import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../bloc/news_bloc.dart';
import '../bloc/news_event.dart';
import '../bloc/news_state.dart';
import '../../../../injection_container.dart' as di;

/// News page for displaying football news.
class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> with TickerProviderStateMixin {
  late final AnimationController _heroController;
  late final Animation<double> _heroAnimation;
  late final AnimationController _cardsController;
  late final Animation<double> _cardsAnimation;

  @override
  void initState() {
    super.initState();
    context.read<NewsBloc>().add(const LoadNewsEvent());

    _heroController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _heroAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _heroController, curve: Curves.easeOutCubic),
    );

    _cardsController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _cardsAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _cardsController, curve: Curves.elasticOut),
    );

    // Start animations
    _heroController.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      _cardsController.forward();
    });
  }

  @override
  void dispose() {
    _heroController.dispose();
    _cardsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFE8F5E8), // Very light green
              Color(0xFFF1F8E9), // Light green-white
              Color(0xFFDCEDC8), // Soft green
              Color(0xFFC8E6C9), // Light green
            ],
          ),
        ),
        child: SafeArea(
          child: BlocBuilder<NewsBloc, NewsState>(
            builder: (context, state) {
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),

                      // Hero Section
                      FadeTransition(
                        opacity: _heroAnimation,
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0, 0.3),
                            end: Offset.zero,
                          ).animate(_heroAnimation),
                          child: _buildHeroSection(),
                        ),
                      ),

                      const SizedBox(height: 32),

                      // News Feed
                      FadeTransition(
                        opacity: _cardsAnimation,
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0, 0.1),
                            end: Offset.zero,
                          ).animate(_cardsAnimation),
                          child: _buildNewsContent(state),
                        ),
                      ),

                      const SizedBox(height: 100), // Extra space for bottom nav
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHeroSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF4CAF50), // Medium green
            Color(0xFF66BB6A), // Light green
            Color(0xFF81C784), // Very light green
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4CAF50).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const FaIcon(
                  FontAwesomeIcons.newspaper,
                  color: Colors.white,
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Football News',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      'Latest Updates',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            'Stay informed with the latest football news, transfer updates, match analysis, and breaking stories from around the world.',
            style: TextStyle(color: Colors.white, fontSize: 16, height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildNewsContent(NewsState state) {
    if (state is NewsLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(40.0),
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4CAF50)),
          ),
        ),
      );
    } else if (state is NewsError) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            children: [
              const FaIcon(
                FontAwesomeIcons.exclamationTriangle,
                color: Color(0xFF4CAF50),
                size: 48,
              ),
              const SizedBox(height: 16),
              Text(
                state.message,
                style: const TextStyle(color: Color(0xFF2E7D32), fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  context.read<NewsBloc>().add(const LoadNewsEvent());
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4CAF50),
                  foregroundColor: Colors.white,
                ),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    } else if (state is NewsLoaded) {
      return _buildNewsFeed(state.news);
    }
    return const SizedBox.shrink();
  }

  Widget _buildNewsFeed(List<dynamic> news) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Latest News',
          style: TextStyle(
            color: Color(0xFF2E7D32),
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ...news.map((article) => _buildNewsCard(article)).toList(),
      ],
    );
  }

  Widget _buildNewsCard(dynamic article) {
    // Convert hex color string to Color
    Color getColorFromHex(String hexColor) {
      hexColor = hexColor.replaceAll('#', '');
      return Color(int.parse('FF$hexColor', radix: 16));
    }

    // Get FontAwesome icon from string
    IconData getIconFromString(String iconName) {
      switch (iconName) {
        case 'trophy':
          return FontAwesomeIcons.trophy;
        case 'crown':
          return FontAwesomeIcons.crown;
        case 'exchange-alt':
          return FontAwesomeIcons.exchangeAlt;
        case 'globe':
          return FontAwesomeIcons.globe;
        case 'dumbbell':
          return FontAwesomeIcons.dumbbell;
        case 'fire':
          return FontAwesomeIcons.fire;
        default:
          return FontAwesomeIcons.newspaper;
      }
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE8F5E8), width: 1),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4CAF50).withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            // Handle news tap
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Opening: ${article.title}'),
                backgroundColor: const Color(0xFF4CAF50),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Category and Time
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: getColorFromHex(article.color).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          FaIcon(
                            getIconFromString(article.icon),
                            color: getColorFromHex(article.color),
                            size: 14,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            article.category,
                            style: TextStyle(
                              color: getColorFromHex(article.color),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Text(
                      article.timeAgo,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Title
                Text(
                  article.title,
                  style: const TextStyle(
                    color: Color(0xFF2E7D32),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    height: 1.3,
                  ),
                ),

                const SizedBox(height: 12),

                // Summary
                Text(
                  article.summary,
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 16),

                // Footer
                Row(
                  children: [
                    Text(article.image, style: const TextStyle(fontSize: 20)),
                    const SizedBox(width: 12),
                    Text(
                      article.readTime,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F5E8),
                        shape: BoxShape.circle,
                      ),
                      child: const FaIcon(
                        FontAwesomeIcons.chevronRight,
                        color: Color(0xFF4CAF50),
                        size: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
