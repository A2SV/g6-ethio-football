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

  Widget _buildComparisonTable(TeamData teamA, TeamData teamB) {
    return Table(
      border: TableBorder.all(color: Colors.grey),
      children: [
        _buildTableRow(
          'Honors',
          teamA.honors.join(', '),
          teamB.honors.join(', '),
          Colors.green,
        ),
        _buildTableRow(
          'Recent Form',
          teamA.recentForm.join(' '),
          teamB.recentForm.join(' '),
          Colors.blue,
        ),
        _buildTableRow(
          'Notable Players',
          teamA.notablePlayers.join(', '),
          teamB.notablePlayers.join(', '),
          Colors.orange,
        ),
        _buildTableRow(
          'Fanbase Notes',
          teamA.fanbaseNotes,
          teamB.fanbaseNotes,
          Colors.purple,
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
