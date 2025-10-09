/// Widget for displaying the comparison results between two selected clubs.
/// Shows a comprehensive table comparing team statistics including matches played, wins, draws, losses, goals, and calculated metrics.
import 'package:flutter/material.dart';
import '../../domain/models/comparison_response.dart';
import '../../domain/models/team_data.dart';

class ComparisonResult extends StatelessWidget {
  final ComparisonResponse response;

  const ComparisonResult({super.key, required this.response});

  @override
  Widget build(BuildContext context) {
    final teamA = response.comparisonData['team_a']!;
    final teamB = response.comparisonData['team_b']!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [_buildTeamHeader(teamA), _buildTeamHeader(teamB)],
          ),
          const SizedBox(height: 20),
          _buildSummaryCard(teamA, teamB),
          const SizedBox(height: 20),
          _buildComparisonTable(teamA, teamB),
        ],
      ),
    );
  }

  Widget _buildTeamHeader(TeamData team) {
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

  Widget _buildSummaryCard(TeamData teamA, TeamData teamB) {
    final pointsA = (teamA.wins * 3) + teamA.draws;
    final pointsB = (teamB.wins * 3) + teamB.draws;
    final gdA = teamA.goalsFor - teamA.goalsAgainst;
    final gdB = teamB.goalsFor - teamB.goalsAgainst;

    String winner;
    Color winnerColor;

    if (pointsA > pointsB || (pointsA == pointsB && gdA > gdB)) {
      winner = '${teamA.name} is leading';
      winnerColor = Colors.green;
    } else if (pointsB > pointsA || (pointsB == pointsA && gdB > gdA)) {
      winner = '${teamB.name} is leading';
      winnerColor = Colors.blue;
    } else {
      winner = 'Teams are evenly matched';
      winnerColor = Colors.orange;
    }

    return Card(
      color: Colors.grey[900],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'Comparison Summary',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              winner,
              style: TextStyle(
                color: winnerColor,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Based on current season statistics',
              style: TextStyle(color: Colors.grey[400], fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildComparisonTable(TeamData teamA, TeamData teamB) {
    return Table(
      border: TableBorder.all(color: Colors.grey),
      children: [
        _buildTableRow(
          'Matches Played',
          teamA.matchesPlayed.toString(),
          teamB.matchesPlayed.toString(),
          Colors.green,
        ),
        _buildTableRow(
          'Wins',
          teamA.wins.toString(),
          teamB.wins.toString(),
          Colors.blue,
        ),
        _buildTableRow(
          'Draws',
          teamA.draws.toString(),
          teamB.draws.toString(),
          Colors.orange,
        ),
        _buildTableRow(
          'Losses',
          teamA.losses.toString(),
          teamB.losses.toString(),
          Colors.red,
        ),
        _buildTableRow(
          'Goals For',
          teamA.goalsFor.toString(),
          teamB.goalsFor.toString(),
          Colors.purple,
        ),
        _buildTableRow(
          'Goals Against',
          teamA.goalsAgainst.toString(),
          teamB.goalsAgainst.toString(),
          Colors.teal,
        ),
        _buildTableRow(
          'Goal Difference',
          (teamA.goalsFor - teamA.goalsAgainst).toString(),
          (teamB.goalsFor - teamB.goalsAgainst).toString(),
          Colors.indigo,
        ),
        _buildTableRow(
          'Points',
          ((teamA.wins * 3) + teamA.draws).toString(),
          ((teamB.wins * 3) + teamB.draws).toString(),
          Colors.amber,
        ),
      ],
    );
  }

  TableRow _buildTableRow(
    String label,
    String valueA,
    String valueB,
    Color labelColor,
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
          child: Text(valueA, style: const TextStyle(color: Colors.white)),
        ),
        Container(
          padding: const EdgeInsets.all(8),
          child: Text(valueB, style: const TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
