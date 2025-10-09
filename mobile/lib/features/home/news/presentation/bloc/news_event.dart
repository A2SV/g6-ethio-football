import '../../domain/usecases/get_news_updates.dart';

abstract class NewsEvent {}

class FetchNewsUpdates extends NewsEvent {
  final NewsCategory category;

  FetchNewsUpdates({this.category = NewsCategory.all});
}