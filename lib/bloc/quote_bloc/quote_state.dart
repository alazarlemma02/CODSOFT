part of 'quote_bloc.dart';

sealed class QuoteState extends Equatable {
  const QuoteState();

  @override
  List<Object> get props => [];
}

final class QuoteInitial extends QuoteState {}

class QuoteLoadingState extends QuoteState {}

class QuoteLoadedState extends QuoteState {
  final Quote quote;

  const QuoteLoadedState({required this.quote});

  @override
  List<Object> get props => [quote];
}

class QuoteErrorState extends QuoteState {
  final String message;

  const QuoteErrorState({required this.message});

  @override
  List<Object> get props => [message];
}
