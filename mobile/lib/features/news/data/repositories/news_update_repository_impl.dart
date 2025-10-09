import '../../domain/entities/news_update_entity.dart';
import '../../domain/repositories/news_update_repository.dart';
import '../datasources/news_remote_datasource.dart';

class NewsUpdateRepositoryImpl implements NewsUpdateRepository {
  final NewsRemoteDataSource remoteDataSource;

  NewsUpdateRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<NewsUpdateEntity>> getFutureMatches() {
    return remoteDataSource.fetchFutureMatches();
  }

  @override
  Future<List<NewsUpdateEntity>> getLiveScores() {
    return remoteDataSource.fetchLiveScores();
  }

  @override
  Future<List<NewsUpdateEntity>> getPastMatches() {
    return remoteDataSource.fetchPastMatches();
  }

  @override
  Future<List<NewsUpdateEntity>> getStandings() {
    return remoteDataSource.fetchStandings();
  }

  @override
  Future<List<NewsUpdateEntity>> getAllCombinedNews() async {
    List<NewsUpdateEntity> allNews = [];
    try {
      allNews.addAll(await remoteDataSource.fetchPastMatches());
    } catch (e) {
      print("Error fetching past matches for combined news: $e");
    }
    try {
      allNews.addAll(await remoteDataSource.fetchStandings());
    } catch (e) {
      print("Error fetching standings for combined news: $e");
    }
    try {
      allNews.addAll(await remoteDataSource.fetchFutureMatches());
    } catch (e) {
      print("Error fetching future matches for combined news: $e");
    }
    try {
      allNews.addAll(await remoteDataSource.fetchLiveScores());
    } catch (e) {
      print("Error fetching live scores for combined news: $e");
    }

    // Sort combined news if possible by date, otherwise keep original order
    allNews.sort((a, b) {
      if (a.publishedAt == null && b.publishedAt == null) return 0;
      if (a.publishedAt == null) return 1;
      if (b.publishedAt == null) return -1;
      return b.publishedAt!.compareTo(a.publishedAt!); // Latest first
    });

    return allNews;
  }
}