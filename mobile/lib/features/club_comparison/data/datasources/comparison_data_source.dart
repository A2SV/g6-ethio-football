import 'dart:convert';

class ComparisonDataSource {
  /// Simulates an API call to fetch comparison data
  Future<Map<String, dynamic>> getComparisonData() async {
    // Simulate network latency
    await Future.delayed(const Duration(seconds: 1));

    // Return the predefined JSON data
    return _getMockData();
  }

  Map<String, dynamic> _getMockData() {
    return {
      "comparison_data": {
        "team_a": {
          "name": "St. George",
          "honors": ["31x Premier League", "12x Ethiopian Cup"],
          "recent_form": ["W", "W", "D", "W", "L"],
          "notable_players": ["Player A", "Player B"],
          "fanbase_notes":
              "Reportedly the largest and most passionate fanbase in the country.",
        },
        "team_b": {
          "name": "Ethiopia Bunna",
          "honors": ["2x Premier League", "5x Ethiopian Cup"],
          "recent_form": ["L", "D", "D", "W", "W"],
          "notable_players": ["Player C", "Player D"],
          "fanbase_notes":
              "Known for their vibrant and vocal supporters, especially in Addis Ababa.",
        },
      },
      "source": "Curated Data",
      "freshness": "2025-09-01T12:00:00Z",
    };
  }
}
