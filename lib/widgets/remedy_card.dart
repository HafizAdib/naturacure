import 'package:flutter/material.dart';
import '../models/remede.dart';

Widget remedyCard({
  required Remede remede,
    VoidCallback? onTapCard,
}) {
  return GestureDetector(
    onTap: onTapCard,
    child: Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 1),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image (optionnelle si tu as un champ imageUrl dans Remede)
            if (remede.etapes.isNotEmpty) // juste pour exemple, tu peux ajouter imageUrl
              Image.network(
                'https://images.unsplash.com/photo-1501004318641-b39e6451bec6',
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nom du remède
                  Text(
                    remede.nom,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  // Nom de la maladie
                  Text(
                    'Maladie : ${remede.maladie.nom}',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.green,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Description
                  Text(
                    remede.description,
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    "Étapes principales :",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  // Liste des étapes
                  ...remede.etapes.map((e) => Text('${e.ordre}. ${e.description}')),
                  const SizedBox(height: 15),
                  
                ],
              ),
            )
          ],
        ),
      ),
    ),
  );
}