class Composition {
  final int id;
  final String nom;
  final String description;
  final String maladie;
  final String image;
  final int likes;
  final bool isValidated;

  Composition({
    required this.id,
    required this.nom,
    required this.description,
    required this.maladie,
    required this.image,
    required this.likes,
    required this.isValidated,
  });

  factory Composition.fromJson(Map<String, dynamic> json) {
    return Composition(
      id: json['id'],
      nom: json['nom'],
      description: json['description'],
      maladie: json['maladie'],
      image: json['image'] ?? "",
      likes: json['likes'],
      isValidated: json['is_validated'],
    );
  }
}