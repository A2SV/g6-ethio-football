import 'dart:convert';
import '../../domain/entities/news_article.dart';

class NewsArticleModel extends NewsArticle {
  const NewsArticleModel({
    required super.id,
    required super.title,
    required super.summary,
    required super.image,
    required super.timeAgo,
    required super.category,
    required super.readTime,
    required super.icon,
    required super.color,
  });

  factory NewsArticleModel.fromJson(Map<String, dynamic> json) {
    return NewsArticleModel(
      id: json['id'] as String,
      title: json['title'] as String,
      summary: json['summary'] as String,
      image: json['image'] as String,
      timeAgo: json['timeAgo'] as String,
      category: json['category'] as String,
      readTime: json['readTime'] as String,
      icon: json['icon'] as String,
      color: json['color'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'summary': summary,
      'image': image,
      'timeAgo': timeAgo,
      'category': category,
      'readTime': readTime,
      'icon': icon,
      'color': color,
    };
  }

  static List<NewsArticleModel> fromJsonList(String jsonString) {
    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((json) => NewsArticleModel.fromJson(json)).toList();
  }
}
