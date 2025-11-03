import 'package:equatable/equatable.dart';

class NewsArticle extends Equatable {
  final String id;
  final String title;
  final String summary;
  final String image;
  final String timeAgo;
  final String category;
  final String readTime;
  final String icon;
  final String color;

  const NewsArticle({
    required this.id,
    required this.title,
    required this.summary,
    required this.image,
    required this.timeAgo,
    required this.category,
    required this.readTime,
    required this.icon,
    required this.color,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    summary,
    image,
    timeAgo,
    category,
    readTime,
    icon,
    color,
  ];
}
