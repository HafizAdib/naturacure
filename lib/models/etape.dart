class Etape {
  final int id;
  final String description;
  final String? detail;
  final int ordre;

  Etape({required this.id, required this.description, this.detail, required this.ordre});

  factory Etape.fromJson(Map<String, dynamic> json) {
    return Etape(
      id: json['id'],
      description: json['description'],
      detail: json['detail'],
      ordre: json['ordre'],
    );
  }
}