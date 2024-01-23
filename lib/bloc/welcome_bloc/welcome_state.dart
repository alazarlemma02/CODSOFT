part of 'welcome_bloc.dart';

sealed class WelcomeState extends Equatable {
  const WelcomeState();

  @override
  List<Object> get props => [];
}

final class WelcomeInitial extends WelcomeState {
  int pageIndex;

  WelcomeInitial({this.pageIndex = 0});
}
