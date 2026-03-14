import 'package:flutter/material.dart';
import '../models/remede.dart';
import '../services/api_service.dart';
import '../widgets/remedy_card.dart';
import 'detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  String searchQuery = "";
  bool showApprovedOnly = false;
  bool isLoading = true;

  List<Remede> remedies = [];

  @override
  void initState() {
    super.initState();
    fetchRemedies();
  }

  Future<void> fetchRemedies() async {
    try {
      final data = await ApiService.getRemedes();
      setState(() {
        remedies = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      print("Erreur API : $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Impossible de récupérer les remèdes")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Filtrage
    List<Remede> filteredRemedies = remedies.where((remede) {
      final query = searchQuery.toLowerCase();
      final matchesSearch = remede.nom.toLowerCase().contains(query) ||
          remede.maladie.nom.toLowerCase().contains(query);

      final matchesApproved = showApprovedOnly ? remede.status == "valide" : true;

      return matchesSearch && matchesApproved;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("NaturaCure"),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(80),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Rechercher un remède...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              onChanged: (value) {
                setState(() => searchQuery = value);
              },
            ),
          ),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: filteredRemedies.map((remede) {
                  return remedyCard(
                    remede: remede,
                    onFavorite: () => print("Favori cliqué sur ${remede.nom}"),
                    onComment: () => print("Commenter cliqué sur ${remede.nom}"),
                    onTapCard: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailScreen(remede: remede),
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
            ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () => setState(() => showApprovedOnly = false),
                style: ElevatedButton.styleFrom(
                  backgroundColor: !showApprovedOnly ? Colors.green : Colors.grey[300],
                ),
                child: Text(
                  "Tous",
                  style: TextStyle(color: !showApprovedOnly ? Colors.white : Colors.black),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ElevatedButton(
                onPressed: () => setState(() => showApprovedOnly = true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: showApprovedOnly ? Colors.green : Colors.grey[300],
                ),
                child: Text(
                  "Approuvés",
                  style: TextStyle(color: showApprovedOnly ? Colors.white : Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}