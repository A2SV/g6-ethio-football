import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/news_article.dart';
import '../../domain/repositories/news_repository.dart';
import '../datasources/news_local_data_source.dart';
import '../models/news_article_model.dart';

class NewsRepositoryImpl implements NewsRepository {
  final NewsLocalDataSource localDataSource;

  NewsRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<NewsArticle>>> getNews() async {
    try {
      final newsModels = await localDataSource.getNews();
      return Right(newsModels);
    } on CacheException {
      return Left(CacheFailure('Failed to load news from cache'));
    }
  }
}
