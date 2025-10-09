import '../entities/news_update_entity.dart';
import '../repositories/news_update_repository.dart';

enum NewsCategory {
  all,
  pastMatches,
  standings,
  futureMatches,
  liveScores,
}

class GetNewsUpdates {
  final NewsUpdateRepository repository;

  GetNewsUpdates(this.repository);

  Future<List<NewsUpdateEntity>> call({required NewsCategory category}) async {
    switch (category) {
      case NewsCategory.all:
        return await repository.getAllCombinedNews();
      case NewsCategory.pastMatches:
        return await repository.getPastMatches();
      case NewsCategory.standings:
        return await repository.getStandings();
      case NewsCategory.futureMatches:
        return await repository.getFutureMatches();
      case NewsCategory.liveScores:
        return await repository.getLiveScores();
    }
  }
}