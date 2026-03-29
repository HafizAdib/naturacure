import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SessionService {
  static String? token;
  static Map<String, dynamic>? user;

  /// Initialiser la session au démarrage de l'app
  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    final userString = prefs.getString('user');
    if (userString != null) {
      user = jsonDecode(userString);
    }
  }

  /// Sauvegarder le token et les infos utilisateur
  static Future<void> login(String newToken, Map<String, dynamic> newUser) async {
    token = newToken;
    user = newUser;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token!);
    await prefs.setString('user', jsonEncode(user));
  }

  /// Déconnexion et suppression des données locales
  static Future<void> logout() async {
    token = null;
    user = null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('user');
  }

  /// Vérifie si l'utilisateur est connecté
  static bool get isLoggedIn => token != null && user != null;
}