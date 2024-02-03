import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:daily_quote/data/model/quote.dart';
import 'package:daily_quote/data/services/services.dart';
import 'package:equatable/equatable.dart';

part 'quote_event.dart';
part 'quote_state.dart';

class QuoteBloc extends Bloc<QuoteEvent, QuoteState> {
  QuoteBloc() : super(QuoteInitial()) {
    on<FetchQuoteEvent>(_fetchQuoteEvent);
  }

  FutureOr<void> _fetchQuoteEvent(
      FetchQuoteEvent event, Emitter<QuoteState> emit) async {
    emit(QuoteLoadingState());
    try {
      final quote = await ApiProvider.fetchQuotes(category: 'inspirational');
      emit(QuoteLoadedState(quote: quote));
    } catch (e) {
      emit(QuoteErrorState(message: e.toString()));
    }
  }
}
