import '../../domain/entities/news_update_entity.dart';
import '../../domain/usecases/get_news_updates.dart';

abstract class NewsState {}

class NewsInitial extends NewsState {}

class NewsLoading extends NewsState {}

class NewsLoaded extends NewsState {
  final List<NewsUpdateEntity> newsUpdates;
  final NewsCategory currentCategory;

  NewsLoaded({required this.newsUpdates, required this.currentCategory});
}

class NewsError extends NewsState {
  final String message;

  NewsError({required this.message});
}