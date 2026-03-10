import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  String searchQuery = "";
  bool showApprovedOnly = false;

  final List<Map<String, dynamic>> remedies = [
    {
      "imageUrl": "https://images.unsplash.com/photo-1501004318641-b39e6451bec6",
      "title": "Remède contre la toux",
      "mainIngredient": "Gingembre",
      "description": "Ce remède naturel aide à soulager la toux et renforcer le système immunitaire.",
      "steps": [
        "1. Laver le gingembre",
        "2. Écraser le gingembre",
        "3. Faire bouillir dans l'eau",
        "4. Boire chaud",
      ],
      "approved": true,
    },
    // ... les autres remèdes
  ];

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredRemedies = remedies.where((remedy) {
      final query = searchQuery.toLowerCase();
      final matchesSearch = remedy["title"].toLowerCase().contains(query) ||
          remedy["mainIngredient"].toLowerCase().contains(query);

      final matchesApproved = showApprovedOnly ? remedy["approved"] == true : true;

      return matchesSearch && matchesApproved;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("NaturaCure"),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: "Rechercher un remède...",
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value;
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: !showApprovedOnly ? Colors.green : Colors.grey[300],
                        ),
                        onPressed: () {
                          setState(() {
                            showApprovedOnly = false;
                          });
                        },
                        child: Text(
                          "Tous",
                          style: TextStyle(color: !showApprovedOnly ? Colors.white : Colors.black),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: showApprovedOnly ? Colors.green : Colors.grey[300],
                        ),
                        onPressed: () {
                          setState(() {
                            showApprovedOnly = true;
                          });
                        },
                        child: Text(
                          "Approuvés",
                          style: TextStyle(color: showApprovedOnly ? Colors.white : Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: filteredRemedies.map((remedy) {
            return Column(
              children: [
                remedyCard(
                  imageUrl: remedy["imageUrl"],
                  title: remedy["title"],
                  mainIngredient: remedy["mainIngredient"],
                  description: remedy["description"],
                  steps: List<String>.from(remedy["steps"]),
                  onFavorite: () {
                    print("Favori cliqué sur ${remedy["title"]}");
                  },
                  onComment: () {
                    print("Commenter cliqué sur ${remedy["title"]}");
                  },
                  onTapCard: () {
                    print("Voir plus sur ${remedy["title"]}");
                    // Ici tu peux naviguer vers une page de détails si tu veux
                  },
                ),
                const SizedBox(height: 20),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget remedyCard({
    required String imageUrl,
    required String title,
    required String mainIngredient,
    required String description,
    required List<String> steps,
    VoidCallback? onFavorite,
    VoidCallback? onComment,
    VoidCallback? onTapCard,
  }) {
    return GestureDetector(
      onTap: onTapCard, // cliquer sur toute la carte
      child: Container(
        width: 330,
        child: Card(
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.network(
                imageUrl,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "Ingrédient principal : $mainIngredient",
                      style: const TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      description,
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      "Étapes principales :",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    ...steps.map((step) => Text(step)).toList(),
                    const SizedBox(height: 15),
                    const Divider(),
                    Align(
  alignment: Alignment.centerRight,
  child: Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      // Bouton Favori
      InkWell(
        onTap: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text("Favori"),
              content: const Text("Vous avez cliqué sur Favori !"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text("Fermer"),
                ),
              ],
            ),
          );
          if (onFavorite != null) onFavorite();
        },
        child: Row(
          children: const [
            Icon(Icons.favorite_border, color: Colors.red),
            SizedBox(width: 8),
            Text("Favori"),
          ],
        ),
      ),
      const SizedBox(width: 16),
      // Bouton Commenter
      InkWell(
        onTap: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text("Commenter"),
              content: const Text("Vous avez cliqué sur Commenter !"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text("Fermer"),
                ),
              ],
            ),
          );
          if (onComment != null) onComment();
        },
        child: Row(
          children: const [
            Icon(Icons.comment_outlined, color: Colors.blue),
            SizedBox(width: 8),
            Text("Commenter"),
          ],
        ),
      ),
    ],
  ),
),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}