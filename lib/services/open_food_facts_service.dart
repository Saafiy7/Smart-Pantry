import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:smart_pantry/models/food_info.dart';

class OpenFoodFactsService {
  static const String _baseUrl = 'https://world.openfoodfacts.org';
  static const Map<String, String> _headers = {
    'User-Agent': 'SmartPantry/1.0 (projet etudiant ISET Bizerte)',
  };

  static Future<List<FoodInfo>> searchByName(String name) async {
    final url = Uri.parse(
      '$_baseUrl/cgi/search.pl?search_terms=${Uri.encodeQueryComponent(name)}'
      '&search_simple=1&action=process&json=1&page_size=10'
      '&fields=code,product_name,brands,image_url',
    );
    try {
      final reponse = await http
          .get(url, headers: _headers)
          .timeout(const Duration(seconds: 8));

      if (reponse.statusCode != 200) {
        throw Exception('Erreur ${reponse.statusCode}');
      }
      final Map<String, dynamic> corps =
          jsonDecode(utf8.decode(reponse.bodyBytes));
      final List<dynamic> liste = corps['products'] ?? [];
      return liste
          .map((e) => FoodInfo.fromJson(e))
          .where((f) => f.name.isNotEmpty)
          .toList();
    } on TimeoutException {
      throw Exception('Le serveur ne répond pas. Réessayez.');
    } on FormatException {
      throw Exception('Réponse invalide du serveur.');
    } on http.ClientException {
      throw Exception('Pas de connexion Internet.');
    }
  }
}