import 'etape.dart';
import 'maladie.dart';

class Remede {
  final int id;
  final String nom;
  final String description;
  final String status;
  final Maladie maladie; // <-- ici
  final List<Etape> etapes;

  Remede({
    required this.id,
    required this.nom,
    required this.description,
    required this.status,
    required this.maladie,
    required this.etapes,
  });

  factory Remede.fromJson(Map<String, dynamic> json) {
    return Remede(
      id: json['id'],
      nom: json['nom'],
      description: json['description'],
      status: json['status'],
      maladie: Maladie.fromJson(json['maladie']), // <-- parsing
      etapes: (json['etapes'] as List)
          .map((e) => Etape.fromJson(e))
          .toList(),
    );
  }
}