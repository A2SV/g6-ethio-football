class NewsUpdateEntity {
  final String content;
  final String type; // e.g., "Past Match", "Standing", "Live Score"
  final DateTime? publishedAt; // We'll try to extract a date if possible, or leave null

  NewsUpdateEntity({
    required this.content,
    required this.type,
    this.publishedAt,
  });
}