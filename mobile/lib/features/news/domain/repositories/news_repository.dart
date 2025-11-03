import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/news_article.dart';

abstract class NewsRepository {
  Future<Either<Failure, List<NewsArticle>>> getNews();
}
