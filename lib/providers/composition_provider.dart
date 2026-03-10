
import 'package:flutter/material.dart';
import '../models/Composition.dart';
import '../services/api_service.dart';

class CompositionProvider extends ChangeNotifier {
  List<Composition> compositions = [];

  Future<void> fetchCompositions() async {
    compositions = await ApiService.getCompositions();
    notifyListeners();
  }
}

static Future<void> createRemede(
    String nom,
    String description,
    String maladie,
    String token) async {

  await http.post(
    Uri.parse("$baseUrl/remedes"),
    headers: {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json"
    },
    body: jsonEncode({
      "nom": nom,
      "description": description,
      "maladie": maladie,
    }),
  );
}