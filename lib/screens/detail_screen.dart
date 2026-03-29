import 'package:flutter/material.dart';
import '../models/remede.dart';
import '../services/api_service.dart';
import '../services/session_service.dart';
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
  bool isLoading = true;
  List<dynamic> commentaires = [];

  @override
  void initState() {
    super.initState();
    _loadRemedeDetails();
  }

  // Charger les détails du remède et ses commentaires
  void _loadRemedeDetails() async {
    try {
      final remedeDetail = await ApiService.getRemedeById(widget.remede.id); 
      setState(() {
        commentaires = remedeDetail.commentaires ?? [];
        likeCount = remedeDetail.likes ?? 0;
        liked = remedeDetail.liked ?? false;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      print("Erreur chargement remède : $e");
    }
  }

  void _likeRemede() async {
    try {
      String token = SessionService.token!;
      await ApiService.likeRemede(widget.remede.id, token);

      setState(() {
        liked = !liked;
        likeCount += liked ? 1 : -1;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur lors du like : $e")),
      );
    }
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
              String token = SessionService.token!;
              try {
                await ApiService.commentRemede(
                  widget.remede.id,
                  _commentController.text,
                  token,
                );

                Navigator.pop(context);

                // Ajouter le commentaire localement pour mise à jour instantanée
                setState(() {
                  commentaires.insert(0, {
                    'contenu': _commentController.text,
                    'user': {'name': 'Vous'}
                  });
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Commentaire envoyé !")),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Erreur commentaire : $e")),
                );
              }
            },
            child: const Text("Envoyer"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Annuler"),
          ),
        ],
      ),
    );
  }

  @override
  @override
Widget build(BuildContext context) {
  final remede = widget.remede;

  return Scaffold(
    appBar: AppBar(
      backgroundColor: Colors.white,
        elevation: 1,
      title: Text(remede.nom),
    ),
    body: isLoading
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(remede.nom,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text("Maladie : ${remede.maladie.nom}",
                    style:
                        const TextStyle(fontSize: 18, color: Colors.green)),
                const SizedBox(height: 16),
                Text(remede.description, style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 16),
                const Text("Étapes de composition :",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                ...remede.etapes.map(
                  (e) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("${e.ordre}. ${e.description}",
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
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
                const Divider(),
                const SizedBox(height: 10),
                const Text(
                  "Commentaires :",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                if (commentaires.isEmpty)
                  const Text("Aucun commentaire pour le moment."),
                ...commentaires.map((c) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const CircleAvatar(
                              radius: 16, child: Icon(Icons.person, size: 16)),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  c['user']?['name'] ?? 'Utilisateur',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 14),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  c['contenu'] ?? '',
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )),
                const SizedBox(height: 80), // <-- espace pour la barre fixe
              ],
            ),
          ),
    bottomNavigationBar: Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          )
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(
                liked ? Icons.thumb_up : Icons.thumb_up_outlined,
                color: Colors.lightGreen),
            onPressed: _likeRemede,
          ),
          Text("$likeCount"),
          const SizedBox(width: 16),
          Expanded(
            child: InkWell(
              onTap: _commentRemede,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.comment_outlined, color: Colors.grey, size: 20),
                    SizedBox(width: 8),
                    Text(
                      "Ajouter un commentaire…",
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

}