import 'package:equatable/equatable.dart';

class Quote extends Equatable {
  final String author;
  final String category;
  final String quote;

  const Quote(
      {required this.author, required this.category, required this.quote});

  Quote copyWith({String? author, String? category, String? quote}) {
    return Quote(
        author: author ?? this.author,
        category: category ?? this.category,
        quote: quote ?? this.quote);
  }

  factory Quote.fromJson(Map<String, dynamic> json) {
    return Quote(
        author: json['author'],
        category: json['category'],
        quote: json['quote']);
  }

  Map<String, dynamic> toJson() {
    return {'author': author, 'category': category, 'quote': quote};
  }

  @override
  List<Object> get props => [author, category, quote];
}
