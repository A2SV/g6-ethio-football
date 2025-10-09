import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_news_updates.dart';
import 'news_event.dart';
import 'news_state.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final GetNewsUpdates getNewsUpdates;

  NewsBloc({required this.getNewsUpdates}) : super(NewsInitial()) {
    on<FetchNewsUpdates>(_onFetchNewsUpdates);
  }

  void _onFetchNewsUpdates(FetchNewsUpdates event, Emitter<NewsState> emit) async {
    emit(NewsLoading());
    try {
      final news = await getNewsUpdates(category: event.category);
      emit(NewsLoaded(newsUpdates: news, currentCategory: event.category));
    } catch (e) {
      emit(NewsError(message: e.toString()));
    }
  }
}