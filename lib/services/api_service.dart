import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/remede.dart';

class ApiService {

  static const baseUrl = "http://127.0.0.1:8000/api";

  static Future<List<Remede>> getRemedes() async {
    final response = await http.get(Uri.parse("$baseUrl/remedes"));
    final List data = jsonDecode(response.body);
    return data.map((e) => Remede.fromJson(e)).toList();
  }

  static Future<Remede> getRemede(int id) async {
    final response =
        await http.get(Uri.parse("$baseUrl/remedes/$id"));
    return Remede.fromJson(jsonDecode(response.body));
  }

  static Future<void> likeRemede(int id, String token) async {
    await http.post(
      Uri.parse("$baseUrl/remedes/$id/like"),
      headers: {
        "Authorization": "Bearer $token"
      },
    );
  }

  static Future<void> commentRemede(
      int id, String content, String token) async {

    await http.post(
      Uri.parse("$baseUrl/remedes/$id/comment"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json"
      },
      body: jsonEncode({
        "contenu": content
      }),
    );
  }
}
