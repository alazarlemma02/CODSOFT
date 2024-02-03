part of 'quote_bloc.dart';

sealed class QuoteEvent extends Equatable {
  const QuoteEvent();

  @override
  List<Object> get props => [];
}

class FetchQuoteEvent extends QuoteEvent {}

class QuoteAddToFavouriteEvent extends QuoteEvent {
  final Quote quote;

  const QuoteAddToFavouriteEvent({required this.quote});

  @override
  List<Object> get props => [quote];
}
