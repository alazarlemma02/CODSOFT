import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'welcome_event.dart';
part 'welcome_state.dart';

class WelcomeBloc extends Bloc<WelcomeEvent, WelcomeInitial> {
  WelcomeBloc() : super(WelcomeInitial()) {
    on<WelcomePageChangedEvent>((event, emit) {
      emit(WelcomeInitial(pageIndex: state.pageIndex));
    });
  }
}
