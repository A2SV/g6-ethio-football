import 'dart:convert';
import 'package:flutter/services.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/news_article_model.dart';

abstract class NewsLocalDataSource {
  Future<List<NewsArticleModel>> getNews();
}

class NewsLocalDataSourceImpl implements NewsLocalDataSource {
  @override
  Future<List<NewsArticleModel>> getNews() async {
    try {
      final String jsonString = await rootBundle.loadString(
        'assets/mock/news.json',
      );
      return NewsArticleModel.fromJsonList(jsonString);
    } catch (e) {
      throw CacheException();
    }
  }
}
