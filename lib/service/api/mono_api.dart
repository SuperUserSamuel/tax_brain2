import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/transaction.dart';

class MonoService {
  static const String baseUrl =
      "https://your-backend.com/mono";

  Future<List<BankTransaction>> fetchTransactions({
    required String accountId,
    required DateTime from,
    required DateTime to,
  }) async {
    final uri = Uri.parse(
      "$baseUrl/transactions"
          "?accountId=$accountId"
          "&from=${from.toIso8601String()}"
          "&to=${to.toIso8601String()}",
    );

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception("Failed to load transactions");
    }

    final data = json.decode(response.body)['data'];

    return List<BankTransaction>.from(
      data.map((e) => BankTransaction.fromJson(e)),
    );
  }
}
