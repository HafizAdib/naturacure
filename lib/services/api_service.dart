import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/remede.dart';
import '../services/session_service.dart';

class ApiService {

  static const baseUrl = "http://192.168.43.148:8000/api";

  // =============================
  // Récupérer les remèdes
  // =============================
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

  // =============================
  // LIKE REMEDE
  // =============================
  static Future<void> likeRemede(int remedeId, String token) async {

    final response = await http.post(
      Uri.parse('$baseUrl/remedes/$remedeId/like'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Erreur lors du like');
    }
  }

  // =============================
  // COMMENTER REMEDE
  // =============================
  static Future<void> commentRemede(
    int remedeId, String commentaire, String token) async {

  final response = await http.post(
    Uri.parse('$baseUrl/remedes/$remedeId/comment'),
    headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'contenu': commentaire,
    }),
  );

  print("STATUS CODE : ${response.statusCode}");
  print("BODY : ${response.body}");

  if (response.statusCode != 201) {
    throw Exception(response.body);
  }
}

// Ajoute cette méthode dans ApiService
static Future<Remede> getRemedeById(int remedeId) async {
  final response = await http.get(
    Uri.parse('$baseUrl/remedes/$remedeId'),
    headers: {
      'Accept': 'application/json',
      // Si tu veux envoyer le token pour savoir si l'utilisateur a liké
      // 'Authorization': 'Bearer $token',
    },
  );

  print("STATUS CODE : ${response.statusCode}");
  print("BODY : ${response.body}");

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);

    // La réponse doit contenir 'remede' avec toutes les relations
    final remedeJson = data['remede'];

    // Retourne un objet Remede complet
    return Remede.fromJson(remedeJson);
  } else {
    throw Exception('Erreur récupération remède : ${response.statusCode}');
  }
}

// Ajoute cette méthode dans ta classe ApiService
 static Future<void> addRemede({
    required String nom,
    required String description,
    int? maladieId,         // si tu veux utiliser un ID existant
    String? maladie,        // nom de la maladie si nouvelle
    List<Map<String, dynamic>> etapes = const [],
    required String token,  // token Sanctum
  }) async {
    // Préparer le body JSON
    Map<String, dynamic> body = {
      "nom": nom,
      "description": description,
      "etapes": etapes.map((e) => {
        "num_etape": e['num_etape'],
        "instructions": e['instructions'],
      }).toList(),
    };

    // Ajouter la maladie
    if (maladieId != null) {
      body["maladie_id"] = maladieId;
    } else if (maladie != null) {
      body["maladie"] = maladie;
    }

    final response = await http.post(
      Uri.parse("$baseUrl/remedes"),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode(body),
    );

    print("STATUS CODE : ${response.statusCode}");
    print("BODY ENVOYE : ${jsonEncode(body)}");
    print("BODY RECU : ${response.body}");

    if (response.statusCode != 201) {
      throw Exception("Erreur création remède : ${response.body}");
    }
  }

static Future<List<Remede>> searchRemedes(String query) async {

  final response = await http.get(
    Uri.parse('$baseUrl/search-remedes?q=$query'),
  );

  if (response.statusCode == 200) {

    final data = jsonDecode(response.body);

    final List remedes = data["remedes"];

    return remedes.map((e) => Remede.fromJson(e)).toList();

  } else {
    throw Exception("Erreur recherche");
  }
}

static Future<List<dynamic>> getMaladies() async {

  final response = await http.get(
    Uri.parse('$baseUrl/maladies'),
  );

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception("Erreur chargement maladies");
  }
}

  // =============================
  // LOGIN UTILISATEUR
  // =============================
  static Future<String> login(String email, String password) async {

  final response = await http.post(
    Uri.parse('$baseUrl/login'),
    headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      "email": email,
      "password": password
    }),
  );

  if (response.statusCode == 200) {

    final data = jsonDecode(response.body);

    return data["access_token"];

  } else {
    throw Exception("Identifiants invalides");
  }
}

static Future<Map<String, dynamic>> loginWithUser(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {"Accept": "application/json"},
      body: {
        'email': email,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return {
        'token': data['token'],
        'user': data['user'],
      };
    } else {
      throw Exception('Échec de la connexion : ${response.body}');
    }
    
  }

  // Inscription
  static Future<Map<String, dynamic>> register(
      String name, String email, String password) async {
    final response = await http.post(
      Uri.parse("$baseUrl/register"),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
      body: jsonEncode({
        "name": name,
        "email": email,
        "password": password,
        "password_confirmation": password,
      }),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception(jsonDecode(response.body)['message'] ??
          "Erreur lors de l'inscription");
    }
  }

  // Admin

  // Obtenir tous les remèdes en attente (admin)
  /// Récupère la liste des remèdes en attente pour l'admin
  static Future<List<dynamic>> getPendingRemedes() async {
    if (SessionService.token == null) {
      throw Exception("Utilisateur non connecté");
    }

    final response = await http.get(
      Uri.parse("$baseUrl/admin/remedes"),
      headers: {
        'Authorization': 'Bearer ${SessionService.token}',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      // Si Laravel renvoie directement un tableau
      if (data is List) return data;

      // Si Laravel renvoie { "remedes": [...] }
      if (data is Map && data.containsKey('remedes')) {
        return data['remedes'];
      }

      throw Exception("Format de données inattendu");
    } else if (response.statusCode == 401) {
      throw Exception("Token invalide ou expiré");
    } else {
      throw Exception(
          "Erreur chargement remèdes : ${response.statusCode} ${response.reasonPhrase}");
    }
  }
  // Approuver un remède
  static Future<void> approveRemede(int id) async {
    final response = await http.post(
      Uri.parse("$baseUrl/admin/remedes/$id/approve"),
      headers: {
        'Authorization': 'Bearer ${SessionService.token}',
        'Accept': 'application/json',
      },
    );
    if (response.statusCode != 200) {
      throw Exception("Erreur lors de l'approbation");
    }
  }

  // Rejeter un remède
  static Future<void> rejectRemede(int id) async {
    final response = await http.post(
      Uri.parse("$baseUrl/admin/remedes/$id/reject"),
      headers: {
        'Authorization': 'Bearer ${SessionService.token}',
        'Accept': 'application/json',
      },
    );
    if (response.statusCode != 200) {
      throw Exception("Erreur lors du rejet");
    }
  }

  // Supprimer un remède
  static Future<void> deleteRemede(int id) async {
    final response = await http.delete(
      Uri.parse("$baseUrl/admin/remedes/$id"),
      headers: {
        'Authorization': 'Bearer ${SessionService.token}',
        'Accept': 'application/json',
      },
    );
    if (response.statusCode != 200) {
      throw Exception("Erreur lors de la suppression");
    }
  }

  // Ajouter une maladie
  static Future<Map<String, dynamic>> addMaladie(String nom) async {
    final response = await http.post(
      Uri.parse("$baseUrl/admin/maladies"),
      headers: {
        'Authorization': 'Bearer ${SessionService.token}',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'nom': nom}),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Erreur ajout maladie");
    }
  }

  // Lister toutes les maladies
  // static Future<List<dynamic>> getMaladies() async {
  //   final response = await http.get(
  //     Uri.parse("$baseUrl/admin/maladies"),
  //     headers: {
  //       'Authorization': 'Bearer ${SessionService.token}',
  //       'Accept': 'application/json',
  //     },
  //   );

  //   if (response.statusCode == 200) {
  //     final data = jsonDecode(response.body);
  //     return data['maladies'];
  //   } else {
  //     throw Exception("Erreur chargement maladies");
  //   }
  // }
}