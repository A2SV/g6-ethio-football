import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities.dart';
import '../bloc/football_bloc.dart';
import '../bloc/football_state.dart';
import 'common_widgets.dart';

class TableSection extends StatelessWidget {
  const TableSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return BlocBuilder<FootballBloc, FootballState>(
      builder: (context, state) {
        if (state is FootballLoaded) {
          final selectedLeague = state.selectedLeague;

          return Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isDark
                  ? const Color.fromARGB(255, 29, 29, 29)
                  : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color.fromARGB(255, 181, 217, 181),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Color.fromARGB(255, 160, 223, 160).withOpacity(0.35),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                // Table Header
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2E7D32),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Builder(
                    builder: (context) {
                      final screenWidth = MediaQuery.of(context).size.width;
                      final isSmallScreen = screenWidth < 360;
                      final headerFontSize = isSmallScreen ? 14.0 : 16.0;

                      return Text(
                        'Table',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: headerFontSize,
                          fontWeight: FontWeight.w600,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                // Show only the selected league table
                Builder(
                  builder: (context) {
                    final season = state.season != null
                        ? '${state.season}/${state.season! + 1}'
                        : '2025/26'; // Fallback
                    if (selectedLeague == 'ETH') {
                      return TableCard(
                        leagueName: 'ETHIOPIAN PREMIERE LEAGUE',
                        leagueLogo: const EthiopianFlag(),
                        season: season,
                        standings: state.standings,
                      );
                    } else {
                      return TableCard(
                        leagueName: 'ENGLISH PREMIER LEAGUE',
                        leagueLogo: const PremierLeagueLogo(),
                        season: season,
                        standings: state.standings,
                      );
                    }
                  },
                ),
              ],
            ),
          );
        }
        // Return empty container for other states
        return const SizedBox.shrink();
      },
    );
  }
}

class TableCard extends StatelessWidget {
  final String leagueName;
  final Widget leagueLogo;
  final String season;
  final List<Standing> standings;

  const TableCard({
    super.key,
    required this.leagueName,
    required this.leagueLogo,
    required this.season,
    required this.standings,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[850] : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color.fromARGB(255, 190, 228, 190),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? Colors.grey[850] : Color(0xFFF8F9FA),
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Row(
              children: [
                leagueLogo,
                const SizedBox(width: 12),
                Expanded(
                  child: Builder(
                    builder: (context) {
                      final screenWidth = MediaQuery.of(context).size.width;
                      final isSmallScreen = screenWidth < 360;
                      final leagueNameFontSize = isSmallScreen ? 12.0 : 14.0;
                      final seasonFontSize = isSmallScreen ? 10.0 : 12.0;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            leagueName,
                            style: TextStyle(
                              fontSize: leagueNameFontSize,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF2E7D32),
                            ),
                          ),
                          Text(
                            'TABLE - $season',
                            style: TextStyle(
                              fontSize: seasonFontSize,
                              color: const Color(0xFF666666),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          // Table Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isDark ? Colors.black : Color(0xFFF5F5F5),
              border: Border(
                top: BorderSide(color: Color(0xFFE8F5E8), width: 1),
              ),
            ),
            child: Builder(
              builder: (context) {
                final screenWidth = MediaQuery.of(context).size.width;
                final isSmallScreen = screenWidth < 360;
                final headerFontSize = isSmallScreen ? 10.0 : 12.0;

                return Row(
                  children: [
                    SizedBox(
                      width: isSmallScreen ? 20 : 24,
                      child: Text(
                        '#',
                        style: TextStyle(
                          fontSize: headerFontSize,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF666666),
                        ),
                      ),
                    ),
                    SizedBox(width: isSmallScreen ? 6 : 8),
                    Expanded(
                      child: Text(
                        'CLUB',
                        style: TextStyle(
                          fontSize: headerFontSize,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF666666),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: isSmallScreen ? 18 : 24,
                      child: Text(
                        'MP',
                        style: TextStyle(
                          fontSize: headerFontSize,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF666666),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: isSmallScreen ? 16 : 20,
                      child: Text(
                        'W',
                        style: TextStyle(
                          fontSize: headerFontSize,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF666666),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: isSmallScreen ? 16 : 20,
                      child: Text(
                        'D',
                        style: TextStyle(
                          fontSize: headerFontSize,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF666666),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: isSmallScreen ? 16 : 20,
                      child: Text(
                        'L',
                        style: TextStyle(
                          fontSize: headerFontSize,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF666666),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: isSmallScreen ? 16 : 20,
                      child: Text(
                        'GD',
                        style: TextStyle(
                          fontSize: headerFontSize,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF666666),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: isSmallScreen ? 3 : 4,
                      child: Text(
                        '|',
                        style: TextStyle(
                          fontSize: headerFontSize,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF666666),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: isSmallScreen ? 20 : 25,
                      child: Text(
                        'Pts',
                        style: TextStyle(
                          fontSize: headerFontSize,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF666666),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          // Table Rows
          ..._generateTableRows(leagueName, standings),
        ],
      ),
    );
  }

  List<Widget> _generateTableRows(String league, List<Standing> standings) {
    if (standings.isEmpty) {
      return [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: const Center(
            child: Text(
              'No standings available',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF666666),
              ),
            ),
          ),
        ),
      ];
    }

    return standings.map((standing) {
      return Builder(
        builder: (context) {
          final screenWidth = MediaQuery.of(context).size.width;
          final isSmallScreen = screenWidth < 360;
          final dataFontSize = isSmallScreen ? 10.0 : 12.0;
          final logoSize = isSmallScreen ? 16.0 : 20.0;
          final spacing = isSmallScreen ? 6.0 : 8.0;
          final columnWidth = isSmallScreen ? 16.0 : 20.0;

          return Container(
            padding: EdgeInsets.symmetric(
              horizontal: isSmallScreen ? 12 : 16,
              vertical: isSmallScreen ? 6 : 8,
            ),
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: Color(0xFFE8F5E8), width: 1),
              ),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: isSmallScreen ? 18 : 24,
                  child: Text(
                    '${standing.position}',
                    style: TextStyle(
                      fontSize: dataFontSize,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1A1A1A),
                    ),
                  ),
                ),
                SizedBox(width: spacing),
                Container(
                  width: logoSize,
                  height: logoSize,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(logoSize / 2),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(logoSize / 2),
                    child: Builder(
                      builder: (context) {
                        // Debug: Print logo URL
                        print(
                          'Loading logo for ${standing.team}: ${standing.teamLogo}',
                        );

                        if (standing.teamLogo.isNotEmpty &&
                            standing.teamLogo != 'null' &&
                            standing.teamLogo.startsWith('http')) {
                          return Image.network(
                            standing.teamLogo,
                            fit: BoxFit.cover,
                            width: logoSize,
                            height: logoSize,
                            headers: const {
                              'User-Agent':
                                  'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
                            },
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Container(
                                width: logoSize,
                                height: logoSize,
                                color: const Color(0xFFE0E0E0),
                                child: Icon(
                                  Icons.hourglass_empty,
                                  size: dataFontSize,
                                  color: const Color(0xFF666666),
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              print(
                                'Logo load failed for ${standing.team}: ${standing.teamLogo}',
                              );
                              return Container(
                                width: logoSize,
                                height: logoSize,
                                color: const Color(0xFFE0E0E0),
                                child: Icon(
                                  Icons.sports_soccer,
                                  size: dataFontSize,
                                  color: const Color(0xFF666666),
                                ),
                              );
                            },
                          );
                        } else {
                          print(
                            'Invalid logo URL for ${standing.team}: ${standing.teamLogo}',
                          );
                          return Container(
                            width: logoSize,
                            height: logoSize,
                            color: const Color(0xFFE0E0E0),
                            child: Icon(
                              Icons.sports_soccer,
                              size: dataFontSize,
                              color: const Color(0xFF666666),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ),
                SizedBox(width: spacing),
                Expanded(
                  child: Text(
                    standing.team,
                    style: TextStyle(
                      fontSize: dataFontSize,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF1A1A1A),
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                SizedBox(
                  width: columnWidth,
                  child: Text(
                    '${standing.matchPlayed}',
                    style: TextStyle(
                      fontSize: dataFontSize,
                      color: const Color(0xFF1A1A1A),
                    ),
                  ),
                ),
                SizedBox(
                  width: columnWidth,
                  child: Text(
                    '${standing.wins}',
                    style: TextStyle(
                      fontSize: dataFontSize,
                      color: const Color(0xFF1A1A1A),
                    ),
                  ),
                ),
                SizedBox(
                  width: columnWidth,
                  child: Text(
                    '${standing.draw}',
                    style: TextStyle(
                      fontSize: dataFontSize,
                      color: const Color(0xFF1A1A1A),
                    ),
                  ),
                ),
                SizedBox(
                  width: columnWidth,
                  child: Text(
                    '${standing.lose}',
                    style: TextStyle(
                      fontSize: dataFontSize,
                      color: const Color(0xFF666666),
                    ),
                  ),
                ),
                SizedBox(
                  width: columnWidth,
                  child: Text(
                    '${standing.gd}',
                    style: TextStyle(
                      fontSize: dataFontSize,
                      color: const Color(0xFF1A1A1A),
                    ),
                  ),
                ),
                SizedBox(
                  width: isSmallScreen ? 3 : 4,
                  child: Text(
                    '|',
                    style: TextStyle(
                      fontSize: dataFontSize,
                      color: const Color(0xFF666666),
                    ),
                  ),
                ),
                SizedBox(
                  width: columnWidth,
                  child: Center(
                    child: Container(
                      width: logoSize,
                      height: logoSize,
                      decoration: const BoxDecoration(
                        color: Color(0xFF2E7D32),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '${standing.points}',
                          style: TextStyle(
                            fontSize: dataFontSize,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    }).toList();
  }
}
