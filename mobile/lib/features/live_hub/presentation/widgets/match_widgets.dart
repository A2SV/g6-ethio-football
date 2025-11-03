import 'package:ethio_football/features/live_hub/presentation/widgets/live_match_widget.dart';
import 'package:ethio_football/features/live_hub/presentation/widgets/previous_fixiture_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../domain/entities.dart' as entities;
import '../bloc/football_bloc.dart';
import '../bloc/football_state.dart';
import 'common_widgets.dart';

// Custom Team Logo Widget with better error handling

class PreviousFixturesSection extends StatelessWidget {
  const PreviousFixturesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return BlocBuilder<FootballBloc, FootballState>(
      builder: (context, state) {
        // Always show the section, even if empty
        final selectedDate = state is FootballLoaded
            ? state.selectedDate
            : null;
        final previousFixtures = state is FootballLoaded
            ? state.previousFixtures
            : [];

        print('🔍 [PREVIOUS_FIXTURES_WIDGET] State type: ${state.runtimeType}');
        print(
          '🔍 [PREVIOUS_FIXTURES_WIDGET] Previous fixtures count: ${previousFixtures.length}',
        );
        if (previousFixtures.isNotEmpty) {
          print(
            '🔍 [PREVIOUS_FIXTURES_WIDGET] First fixture: ${previousFixtures[0].homeTeam.name} vs ${previousFixtures[0].awayTeam.name}',
          );
        }

        // Filter previous fixtures by selected date if one is chosen
        var filteredFixtures = previousFixtures;
        if (selectedDate != null) {
          final selectedDateOnly = DateTime(
            selectedDate.year,
            selectedDate.month,
            selectedDate.day,
          );
          filteredFixtures = previousFixtures.where((f) {
            final fixtureDate = DateTime(f.date.year, f.date.month, f.date.day);
            return fixtureDate == selectedDateOnly;
          }).toList();
        }

        print(
          '🔍 [PREVIOUS_FIXTURES_WIDGET] Filtered fixtures count: ${filteredFixtures.length}',
        );

        return Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF2E7D32),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                selectedDate != null
                    ? 'Fixtures for ${selectedDate.day}/${selectedDate.month}/${selectedDate.year}'
                    : 'Previous Fixtures',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (filteredFixtures.isNotEmpty)
              ...filteredFixtures
                  .take(5)
                  .map((fixture) => PreviousFixtureCard(fixture: fixture))
            else if (state is FootballLoading)
              // Show loading state
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 24,
                ),
                child: const Center(
                  child: Column(
                    children: [
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Color(0xFF2E7D32),
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Loading previous fixtures...',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF666666),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              // Show empty state
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 24,
                ),
                child: const Center(
                  child: Text(
                    'No previous fixtures available',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF666666),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class LiveMatchesSectionNew extends StatelessWidget {
  const LiveMatchesSectionNew({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return BlocBuilder<FootballBloc, FootballState>(
      builder: (context, state) {
        if (state is FootballLoaded && state.liveMatches.isNotEmpty) {
          final selectedDate = state.selectedDate;

          // Filter live matches by selected date if one is chosen
          var filteredMatches = state.liveMatches;
          if (selectedDate != null) {
            final selectedDateOnly = DateTime(
              selectedDate.year,
              selectedDate.month,
              selectedDate.day,
            );
            filteredMatches = state.liveMatches.where((m) {
              final matchDate = DateTime(m.date.year, m.date.month, m.date.day);
              return matchDate == selectedDateOnly;
            }).toList();
          }

          if (filteredMatches.isEmpty) {
            return const SizedBox.shrink();
          }

          return Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFF2E7D32),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  selectedDate != null
                      ? 'Live Matches for ${selectedDate.day}/${selectedDate.month}/${selectedDate.year}'
                      : 'Live Matches',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isDark ? Color(0xFF121212) : Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ...filteredMatches
                  .take(5)
                  .map((match) => LiveMatchCard(match: match)),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

class LiveMatchesSection extends StatelessWidget {
  const LiveMatchesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FootballBloc, FootballState>(
      builder: (context, state) {
        if (state is FootballLoaded) {
          final selectedLeague = state.selectedLeague;
          final selectedDate = state.selectedDate;

          // Filter fixtures by league and optionally by date
          var fixtures = state.fixtures
              .where((f) => f.league == selectedLeague)
              .toList();

          // If a specific date is selected, filter fixtures for that date
          if (selectedDate != null) {
            final selectedDateOnly = DateTime(
              selectedDate.year,
              selectedDate.month,
              selectedDate.day,
            );
            fixtures = fixtures.where((f) {
              final fixtureDate = DateTime(
                f.kickoff.year,
                f.kickoff.month,
                f.kickoff.day,
              );
              return fixtureDate == selectedDateOnly;
            }).toList();
          }

          final liveScores = state.liveScores
              .where((l) => l.league == selectedLeague)
              .toList();

          // If a specific date is selected, filter live scores for that date
          var liveScoresFiltered = liveScores;
          if (selectedDate != null) {
            final selectedDateOnly = DateTime(
              selectedDate.year,
              selectedDate.month,
              selectedDate.day,
            );
            liveScoresFiltered = liveScores.where((l) {
              final liveScoreDate = DateTime(
                l.kickoff.year,
                l.kickoff.month,
                l.kickoff.day,
              );
              return liveScoreDate == selectedDateOnly;
            }).toList();
          }

          // Show only the selected league
          if (selectedLeague == 'ETH') {
            return LeagueCard(
              leagueName: 'ETHIOPIAN PREMIERE LEAGUE',
              leagueLogo: const EthiopianFlag(),
              fixtures: fixtures,
              liveScores: liveScoresFiltered,
            );
          } else {
            return LeagueCard(
              leagueName: 'ENGLISH PREMIER LEAGUE',
              leagueLogo: const PremierLeagueLogo(),
              fixtures: fixtures,
              liveScores: liveScoresFiltered,
            );
          }
        }
        // Return empty container for other states
        return const SizedBox.shrink();
      },
    );
  }
}

class LeagueCard extends StatelessWidget {
  final String leagueName;
  final Widget leagueLogo;
  final List<entities.Fixture> fixtures;
  final List<entities.LiveScore> liveScores;

  const LeagueCard({
    super.key,
    required this.leagueName,
    required this.leagueLogo,
    required this.fixtures,
    required this.liveScores,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final allMatches = <Widget>[];

    // Add live scores first
    for (final liveScore in liveScores) {
      allMatches.add(
        MatchRow(
          homeTeam: liveScore.homeTeam,
          awayTeam: liveScore.awayTeam,
          score: liveScore.score,
          isLive: true,
          time: '67\'', // Mock live time
        ),
      );
    }

    // Add fixtures
    for (final fixture in fixtures) {
      final time = DateFormat.Hm().format(fixture.kickoff.toLocal());
      allMatches.add(
        MatchRow(
          homeTeam: fixture.homeTeam,
          awayTeam: fixture.awayTeam,
          score: fixture.score ?? '3-2', // Mock score
          isLive: false,
          time: time,
        ),
      );
    }

    // If no data, show empty state
    if (allMatches.isEmpty) {
      allMatches.add(
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: const Center(
            child: Text(
              'No matches available',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF666666),
              ),
            ),
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: isDark ? Colors.black : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE8F5E8), width: 0.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
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
            decoration: const BoxDecoration(
              color: Color(0xFFF8F9FA),
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
                      final leagueFontSize = isSmallScreen ? 12.0 : 14.0;

                      return Text(
                        leagueName,
                        style: TextStyle(
                          fontSize: leagueFontSize,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF2E7D32),
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          // Matches
          ...allMatches.map((match) => match).toList(),
        ],
      ),
    );
  }
}

class MatchRow extends StatelessWidget {
  final String homeTeam;
  final String awayTeam;
  final String score;
  final bool isLive;
  final String time;

  const MatchRow({
    super.key,
    required this.homeTeam,
    required this.awayTeam,
    required this.score,
    required this.isLive,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Color(0xFFE8F5E8), width: 1)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Builder(
              builder: (context) {
                final screenWidth = MediaQuery.of(context).size.width;
                final isSmallScreen = screenWidth < 360;
                final teamFontSize = isSmallScreen ? 12.0 : 14.0;

                return Text(
                  homeTeam,
                  style: TextStyle(
                    fontSize: teamFontSize,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF1A1A1A),
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                );
              },
            ),
          ),
          // Score or Time with Boolean Circle - Centered
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Builder(
                  builder: (context) {
                    final screenWidth = MediaQuery.of(context).size.width;
                    final isSmallScreen = screenWidth < 360;
                    final scoreTimeFontSize = isSmallScreen ? 10.0 : 12.0;
                    final padding = isSmallScreen
                        ? const EdgeInsets.symmetric(horizontal: 8, vertical: 4)
                        : const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          );

                    return Container(
                      constraints: BoxConstraints(
                        minWidth: isSmallScreen ? 45 : 55,
                        maxWidth: isSmallScreen ? 65 : 75,
                      ),
                      padding: padding,
                      decoration: BoxDecoration(
                        color: isLive
                            ? const Color(0xFF2E7D32)
                            : const Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        isLive ? score : time,
                        style: TextStyle(
                          fontSize: scoreTimeFontSize,
                          fontWeight: FontWeight.w600,
                          color: isLive
                              ? Colors.white
                              : const Color(0xFF666666),
                        ),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    );
                  },
                ),
                const SizedBox(width: 8),
                Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: isLive
                        ? const Color(0xFF22C55E)
                        : const Color(0xFFE0E0E0),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: isLive ? Colors.white : const Color(0xFF9E9E9E),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Builder(
              builder: (context) {
                final screenWidth = MediaQuery.of(context).size.width;
                final isSmallScreen = screenWidth < 360;
                final teamFontSize = isSmallScreen ? 12.0 : 14.0;

                return Text(
                  awayTeam,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontSize: teamFontSize,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF1A1A1A),
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
