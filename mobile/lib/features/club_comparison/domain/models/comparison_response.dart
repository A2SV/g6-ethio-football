import 'package:equatable/equatable.dart';
import 'team_data.dart';

class ComparisonResponse extends Equatable {
  final Map<String, TeamData> comparisonData;
  final String source;
  final String freshness;

  const ComparisonResponse({
    required this.comparisonData,
    required this.source,
    required this.freshness,
  });

  @override
  List<Object?> get props => [comparisonData, source, freshness];

  factory ComparisonResponse.fromJson(Map<String, dynamic> json) {
    final comparisonDataJson = json['comparison_data'] as Map<String, dynamic>;
    final comparisonData = <String, TeamData>{};

    comparisonDataJson.forEach((key, value) {
      comparisonData[key] = TeamData.fromJson(value as Map<String, dynamic>);
    });

    return ComparisonResponse(
      comparisonData: comparisonData,
      source: json['source'] as String,
      freshness: json['freshness'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    final comparisonDataJson = <String, dynamic>{};
    comparisonData.forEach((key, value) {
      comparisonDataJson[key] = value.toJson();
    });

    return {
      'comparison_data': comparisonDataJson,
      'source': source,
      'freshness': freshness,
    };
  }
}
