import 'dart:convert';

import 'package:daily_quote/data/model/quote.dart';
import 'package:http/http.dart' as http;

class ApiProvider {
  static const String baseUrl = 'https://api.api-ninjas.com/v1/quotes';
  static const String apiKey = 'uHfuZqxxCgNwM2jwC2v1kg==1VgishccUS8frYiQ';

  static Future<Quote> fetchQuotes({required String category}) async {
    final String apiUrl = '$baseUrl?category=$category';

    try {
      final response =
          await http.get(Uri.parse(apiUrl), headers: {'X-Api-Key': apiKey});
      final List<dynamic> quoteListJson = jsonDecode(response.body);
      if (quoteListJson.isNotEmpty) {
        final Map<String, dynamic> quoteJson = quoteListJson.first;
        return Quote.fromJson(quoteJson);
      } else {
        throw Exception('No quotes found');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
