import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'live_hub_bloc_event.dart';
part 'live_hub_bloc_state.dart';

class LiveHubBlocBloc extends Bloc<LiveHubBlocEvent, LiveHubBlocState> {
  LiveHubBlocBloc() : super(LiveHubBlocInitial()) {
    on<LiveHubBlocEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
