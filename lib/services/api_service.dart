import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/remede.dart';

class ApiService {

  static const baseUrl = "http://192.168.43.148:8000/api"; // IP de ton PC

  static Future<List<Remede>> getRemedes() async {

  final response = await http.get(Uri.parse("$baseUrl/remedes"));

  print(response.body);
  print(response.statusCode);

  if (response.statusCode == 200) {

    final Map<String, dynamic> jsonData = jsonDecode(response.body);

    final List data = jsonData["remedes"];

    return data.map((e) => Remede.fromJson(e)).toList();

  } else {
    throw Exception("Erreur API : ${response.statusCode}");
  }
}
}