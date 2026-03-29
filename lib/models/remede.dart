import 'etape.dart';
import 'maladie.dart';

class Remede {
  final int id;
  final String nom;
  final String description;
  final String status;
  final Maladie maladie;
  final List<Etape> etapes;

  // Champs ajoutés pour commentaires et likes
  List<dynamic>? commentaires; // pour stocker les commentaires
  int? likes; // nombre de likes
  bool? liked; // si l'utilisateur a liké

  Remede({
    required this.id,
    required this.nom,
    required this.description,
    required this.status,
    required this.maladie,
    required this.etapes,
    this.commentaires,
    this.likes,
    this.liked,
  });

  factory Remede.fromJson(Map<String, dynamic> json) {
    return Remede(
      id: json['id'],
      nom: json['nom'],
      description: json['description'],
      status: json['status'],
      maladie: Maladie.fromJson(json['maladie']),
      etapes: (json['etapes'] as List)
          .map((e) => Etape.fromJson(e))
          .toList(),
      commentaires: json['commentaires'] ?? [],
      likes: json['likes'] ?? 0,
      liked: json['liked'] ?? false,
    );
  }
}