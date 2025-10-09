import '../entities/news_update_entity.dart';

abstract class NewsUpdateRepository {
  Future<List<NewsUpdateEntity>> getPastMatches();
  Future<List<NewsUpdateEntity>> getStandings();
  Future<List<NewsUpdateEntity>> getFutureMatches();
  Future<List<NewsUpdateEntity>> getLiveScores();
  Future<List<NewsUpdateEntity>> getAllCombinedNews(); // For 'All News' display
}