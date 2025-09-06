import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/core_features/domain/entities/theme_type.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../../../settings/presentation/bloc/settings_state.dart';
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
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, themeState) {
        final isDark =
            themeState is ThemeLoaded && themeState.theme == ThemeType.DARK;
        return Scaffold(
          backgroundColor: isDark ? Colors.black : Colors.white,
          appBar: AppBar(
            backgroundColor: isDark ? Colors.black : Colors.white,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: isDark ? Colors.white : Colors.black,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Text(
              'Compare Clubs',
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black,
                fontSize: 20,
              ),
            ),
            centerTitle: true,
            actions: [
              IconButton(
                icon: Icon(
                  Icons.settings,
                  color: isDark ? Colors.white : Colors.black,
                ),
                onPressed: () {},
              ),
            ],
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
                            ),
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
        );
      },
    );
  }

  Widget _buildSelectedClubsHeader(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[800] : Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildSelectedClubDisplay('Club A', _selectedClubA, isDark),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: const BoxDecoration(
              color: Colors.orange,
              shape: BoxShape.circle,
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
          _buildSelectedClubDisplay('Club B', _selectedClubB, isDark),
        ],
      ),
    );
  }

  Widget _buildSelectedClubDisplay(String label, TeamData? club, bool isDark) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: club != null ? Colors.green : Colors.grey,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.sports_soccer, color: Colors.white, size: 24),
              if (club != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    club.name,
                    style: const TextStyle(color: Colors.white, fontSize: 10),
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildClubSelectionGrid(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: _clubs.length,
        itemBuilder: (context, index) {
          return _buildClubGridItem(index, isDark);
        },
      ),
    );
  }

  Widget _buildCompareButton(bool isDark) {
    final canCompare = _selectedClubA != null && _selectedClubB != null;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ElevatedButton(
        onPressed: canCompare
            ? () {
                context.read<ComparisonBloc>().add(
                  FetchComparisonDataEvent(
                    clubAId: int.parse(_selectedClubA!.id),
                    clubBId: int.parse(_selectedClubB!.id),
                  ),
                );
              }
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: canCompare ? Colors.green : Colors.grey,
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        child: const Text(
          'Compare Clubs',
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildClubGridItem(int index, bool isDark) {
    final club = _clubs[index];
    final isSelected = _selectedClubA == club || _selectedClubB == club;

    return GestureDetector(
      onTap: () {
        setState(() {
          if (_selectedClubA == club) {
            _selectedClubA = null;
          } else if (_selectedClubB == club) {
            _selectedClubB = null;
          } else if (_selectedClubA == null) {
            _selectedClubA = club;
          } else if (_selectedClubB == null && club != _selectedClubA) {
            _selectedClubB = club;
          }
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.green
              : (isDark ? Colors.grey[800] : Colors.grey[200]),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? Colors.green.shade700
                : (isDark ? Colors.white : Colors.black),
            width: isSelected ? 2 : 1,
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
              size: 30,
            ),
            const SizedBox(height: 8),
            Text(
              club.name,
              style: TextStyle(
                color: isSelected
                    ? Colors.white
                    : (isDark ? Colors.white : Colors.black),
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultUI(ComparisonResponse response, bool isDark) {
    final teamA = response.comparisonData['team_a']!;
    final teamB = response.comparisonData['team_b']!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const SizedBox(height: 20),
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
    );
  }

  Widget _buildTeamHeader(TeamData team, bool isDark) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: const BoxDecoration(
            color: Colors.grey,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.sports_soccer, color: Colors.white),
        ),
        const SizedBox(height: 8),
        Text(
          team.name,
          style: const TextStyle(color: Colors.white, fontSize: 16),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildComparisonTable(TeamData teamA, TeamData teamB, bool isDark) {
    return Table(
      border: TableBorder.all(color: Colors.grey),
      children: [
        _buildTableRow(
          'Honors',
          teamA.honors.join(', '),
          teamB.honors.join(', '),
          Colors.green,
          isDark,
        ),
        _buildTableRow(
          'Recent Form',
          teamA.recentForm.join(' '),
          teamB.recentForm.join(' '),
          Colors.blue,
          isDark,
        ),
        _buildTableRow(
          'Notable Players',
          teamA.notablePlayers.join(', '),
          teamB.notablePlayers.join(', '),
          Colors.orange,
          isDark,
        ),
        _buildTableRow(
          'Fanbase Notes',
          teamA.fanbaseNotes,
          teamB.fanbaseNotes,
          Colors.purple,
          isDark,
        ),
      ],
    );
  }

  TableRow _buildTableRow(
    String label,
    String valueA,
    String valueB,
    Color labelColor,
    bool isDark,
  ) {
    return TableRow(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          color: labelColor,
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8),
          child: Text(
            valueA,
            style: TextStyle(color: isDark ? Colors.white : Colors.black),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8),
          child: Text(
            valueB,
            style: TextStyle(color: isDark ? Colors.white : Colors.black),
          ),
        ),
      ],
    );
  }
}
