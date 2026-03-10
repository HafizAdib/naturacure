class Remede {
  final int id;
  final String nom;
  final String description;
  final String maladie;
  final String image;
  final int likes;
  final bool validated;

  Remede({
    required this.id,
    required this.nom,
    required this.description,
    required this.maladie,
    required this.image,
    required this.likes,
    required this.validated,
  });

  factory Remede.fromJson(Map<String, dynamic> json) {
    return Remede(
      id: json['id'],
      nom: json['nom'],
      description: json['description'],
      maladie: json['maladie'],
      image: json['image'] ?? "",
      likes: json['likes_count'] ?? 0,
      validated: json['validated'] ?? false,
    );
  }
}