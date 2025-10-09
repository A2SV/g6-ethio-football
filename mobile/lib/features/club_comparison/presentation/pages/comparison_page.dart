/// Main page widget for club comparison feature.
/// This page allows users to select two football clubs and view their comparison data including honors, form, players, and fanbase info.
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/models/comparison_response.dart';
import '../../domain/models/team_data.dart';
import '../blocs/comparison_bloc.dart';
import '../blocs/comparison_event.dart';
import '../blocs/comparison_state.dart';

class ComparisonPage extends StatefulWidget {
  const ComparisonPage({super.key});

  @override
  State<ComparisonPage> createState() => _ComparisonPageState();
}

class _ComparisonPageState extends State<ComparisonPage> {
  TeamData? _selectedClubA;
  TeamData? _selectedClubB;

  List<TeamData> _clubs = [];

  @override
  void initState() {
    super.initState();
    context.read<ComparisonBloc>().add(const LoadClubsEvent());
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : Colors.white,
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF1F1F1F) : Colors.white,

        title: Text(
          'Compare Clubs',
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocListener<ComparisonBloc, ComparisonState>(
        listener: (context, state) {
          if (state is ClubsLoadedState) {
            setState(() {
              _clubs = state.clubs;
            });
          }
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                // Selected clubs header
                _buildSelectedClubsHeader(isDark),
                const SizedBox(height: 20),
                // Club selection grid
                _buildClubSelectionGrid(isDark),
                const SizedBox(height: 20),
                // Compare button
                _buildCompareButton(isDark),
                const SizedBox(height: 20),
                // Results section (conditional)
                BlocBuilder<ComparisonBloc, ComparisonState>(
                  builder: (context, state) {
                    if (state is ComparisonLoadingState) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is ComparisonLoadedState) {
                      return _buildResultUI(state.comparisonResponse, isDark);
                    } else if (state is ComparisonErrorState) {
                      return Center(
                        child: Text(
                          state.errorMessage,
                          style: TextStyle(
                            color: isDark ? Colors.white : Colors.black,
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSelectedClubsHeader(bool isDark) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(vertical: 16),
      color: isDark ? const Color(0xFF1F1F1F) : const Color(0xFFF5F5F5),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildSelectedClubDisplay(_selectedClubA, isDark),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Colors.orange.shade600, Colors.orange.shade900],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: const Text(
                'VS',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            _buildSelectedClubDisplay(_selectedClubB, isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedClubDisplay(TeamData? club, bool isDark) {
    final color = club != null
        ? Colors.green.shade600
        : (isDark ? Colors.grey.shade700 : Colors.grey.shade400);
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.sports_soccer, color: Colors.white, size: 36),
              if (club != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8, left: 4, right: 4),
                  child: Text(
                    club.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildClubSelectionGrid(bool isDark) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 150.0,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.8,
      ),
      itemCount: _clubs.length,
      itemBuilder: (context, index) {
        return _buildClubGridItem(_clubs[index], isDark);
      },
    );
  }

  Widget _buildCompareButton(bool isDark) {
    final canCompare = _selectedClubA != null && _selectedClubB != null;
    return ElevatedButton(
      onPressed: canCompare
          ? () {
              final clubAId = int.parse(_selectedClubA!.id);
              final clubBId = int.parse(_selectedClubB!.id);
              print('🔍 [COMPARISON_PAGE] Comparing clubs:');
              print(
                '🔍 [COMPARISON_PAGE] Club A: ${_selectedClubA!.name} (ID: $clubAId)',
              );
              print(
                '🔍 [COMPARISON_PAGE] Club B: ${_selectedClubB!.name} (ID: $clubBId)',
              );

              context.read<ComparisonBloc>().add(
                FetchComparisonDataEvent(clubAId: clubAId, clubBId: clubBId),
              );
            }
          : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: canCompare
            ? Colors.green.shade700
            : Colors.grey.shade400,
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        elevation: canCompare ? 8 : 0,
      ),
      child: Text(
        'Compare Clubs',
        style: TextStyle(
          fontSize: 18,
          color: canCompare ? Colors.white : Colors.grey.shade700,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildClubGridItem(TeamData club, bool isDark) {
    final isSelected = _selectedClubA == club || _selectedClubB == club;
    final isSelectedA = _selectedClubA == club;

    return GestureDetector(
      onTap: () {
        setState(() {
          if (_selectedClubA == club) {
            _selectedClubA = null;
          } else if (_selectedClubB == club) {
            _selectedClubB = null;
          } else if (_selectedClubA == null) {
            _selectedClubA = club;
          } else if (_selectedClubB == null) {
            if (club != _selectedClubA) {
              _selectedClubB = club;
            }
          }
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? Colors.green.shade800 : Colors.green.shade200)
              : (isDark ? const Color(0xFF1F1F1F) : Colors.white),
          borderRadius: BorderRadius.circular(16),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color:
                        (isSelectedA
                                ? Colors.orange.shade900
                                : Colors.green.shade900)
                            .withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
          border: Border.all(
            color: isSelected
                ? (isSelectedA ? Colors.orange : Colors.green.shade600)
                : (isDark ? Colors.grey.shade700 : Colors.grey.shade400),
            width: isSelected ? 3 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.sports_soccer,
              color: isSelected
                  ? Colors.white
                  : (isDark ? Colors.white : Colors.black),
              size: 40,
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Text(
                club.name,
                style: TextStyle(
                  color: isSelected
                      ? Colors.white
                      : (isDark ? Colors.white : Colors.black),
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultUI(ComparisonResponse response, bool isDark) {
    final teamA = response.comparisonData['team_a']!;
    final teamB = response.comparisonData['team_b']!;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.only(bottom: 20),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildTeamHeader(teamA, isDark),
                _buildTeamHeader(teamB, isDark),
              ],
            ),
            const SizedBox(height: 20),
            _buildComparisonTable(teamA, teamB, isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamHeader(TeamData team, bool isDark) {
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: const Icon(
              Icons.shield_outlined,
              color: Colors.blue,
              size: 40,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            team.name,
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildComparisonTable(TeamData teamA, TeamData teamB, bool isDark) {
    final tableData = {
      'Matches Played': [teamA.matchesPlayed, teamB.matchesPlayed],
      'Wins': [teamA.wins, teamB.wins],
      'Draws': [teamA.draws, teamB.draws],
      'Losses': [teamA.losses, teamB.losses],
      'Goals For': [teamA.goalsFor, teamB.goalsFor],
      'Goals Against': [teamA.goalsAgainst, teamB.goalsAgainst],
    };

    return Table(
      defaultColumnWidth: const IntrinsicColumnWidth(),
      border: TableBorder.all(
        color: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(8),
      ),
      children: tableData.entries.map((entry) {
        final label = entry.key;
        final values = entry.value;
        final valueA = values[0];
        final valueB = values[1];

        return TableRow(
          decoration: BoxDecoration(
            color: (label == 'Wins' || label == 'Goals For')
                ? (isDark ? Colors.green.shade900 : Colors.green.shade50)
                : (label == 'Losses' || label == 'Goals Against')
                ? (isDark ? Colors.red.shade900 : Colors.red.shade50)
                : (isDark ? const Color(0xFF1F1F1F) : Colors.white),
          ),
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              child: Text(
                label,
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(12),
              child: Text(
                valueA.toString(),
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              padding: const EdgeInsets.all(12),
              child: Text(
                valueB.toString(),
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
}
