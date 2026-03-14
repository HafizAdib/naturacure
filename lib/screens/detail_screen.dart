import 'package:flutter/material.dart';
import '../models/remede.dart';
import '../services/api_service.dart'; // ton ApiService
import '../models/etape.dart';

class DetailScreen extends StatefulWidget {
  final Remede remede;

  const DetailScreen({super.key, required this.remede});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  int likeCount = 0;
  bool liked = false;

  @override
  void initState() {
    super.initState();
    // ici tu peux charger le nombre de likes initial si tu veux
  }

  void _likeRemede() async {
    // Ici tu devrais récupérer le token de l'utilisateur
    String token = "ton_token_sanctum";
    await ApiService.likeRemede(widget.remede.id, token);
    setState(() {
      liked = !liked;
      likeCount += liked ? 1 : -1;
    });
  }

  void _commentRemede() {
    final TextEditingController _commentController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Ajouter un commentaire"),
        content: TextField(
          controller: _commentController,
          decoration: const InputDecoration(hintText: "Votre commentaire"),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              String token = "ton_token_sanctum";
              await ApiService.commentRemede(
                  widget.remede.id, _commentController.text, token);
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Commentaire envoyé !")),
              );
            },
            child: const Text("Envoyer"),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Annuler"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final remede = widget.remede;

    return Scaffold(
      appBar: AppBar(
        title: Text(remede.nom),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(remede.nom,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text("Maladie : ${remede.maladie.nom}",
                style: const TextStyle(fontSize: 18, color: Colors.green)),
            const SizedBox(height: 16),
            Text(remede.description, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            const Text("Étapes de composition :",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ...remede.etapes.map(
              (e) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("${e.ordre}. ${e.description}",
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    if (e.detail != null && e.detail!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(left: 8, top: 2),
                        child: Text(e.detail!,
                            style: const TextStyle(color: Colors.grey)),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                IconButton(
                  icon: Icon(liked ? Icons.favorite : Icons.favorite_border,
                      color: Colors.red),
                  onPressed: _likeRemede,
                ),
                Text("$likeCount Likes"),
                const SizedBox(width: 20),
                IconButton(
                  icon: const Icon(Icons.comment_outlined, color: Colors.blue),
                  onPressed: _commentRemede,
                ),
                const Text("Commenter"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}