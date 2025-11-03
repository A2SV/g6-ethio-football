import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/news_repository.dart';
import 'news_event.dart';
import 'news_state.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final NewsRepository repository;

  NewsBloc({required this.repository}) : super(const NewsInitial()) {
    on<LoadNewsEvent>(_onLoadNews);
  }

  Future<void> _onLoadNews(LoadNewsEvent event, Emitter<NewsState> emit) async {
    emit(const NewsLoading());

    final result = await repository.getNews();

    result.fold(
      (failure) => emit(NewsError(failure.message)),
      (news) => emit(NewsLoaded(news)),
    );
  }
}
