import 'package:flutter/material.dart';
import '../services/api_service.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  List<dynamic> remedes = [];
  bool isLoading = true;

  final TextEditingController _maladieController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchRemedes();
  }

  Future<void> fetchRemedes() async {
    setState(() => isLoading = true);
    try {
      final data = await ApiService.getPendingRemedes();
      setState(() {
        remedes = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  void approveRemede(int id) async {
    try {
      await ApiService.approveRemede(id);
      fetchRemedes();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur approbation: $e")),
      );
    }
  }

  void rejectRemede(int id) async {
    try {
      await ApiService.rejectRemede(id);
      fetchRemedes();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur rejet: $e")),
      );
    }
  }

  void deleteRemede(int id) async {
    try {
      await ApiService.deleteRemede(id);
      fetchRemedes();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur suppression: $e")),
      );
    }
  }

  void addMaladie() async {
    if (_maladieController.text.trim().isEmpty) return;

    try {
      await ApiService.addMaladie(_maladieController.text.trim());
      _maladieController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Maladie ajoutée avec succès")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur ajout maladie: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin - Remèdes"),
        backgroundColor: Colors.green,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: fetchRemedes,
              child: ListView(
                padding: const EdgeInsets.all(8),
                children: [
                  ...remedes.map((remede) {
                    return Card(
                      child: ListTile(
                        title: Text(remede['nom']),
                        subtitle: Text(remede['description']),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.check, color: Colors.green),
                              onPressed: () => approveRemede(remede['id']),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close, color: Colors.red),
                              onPressed: () => rejectRemede(remede['id']),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.grey),
                              onPressed: () => deleteRemede(remede['id']),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                  const SizedBox(height: 20),
                  const Divider(),
                  const Text(
                    "Ajouter une nouvelle maladie",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _maladieController,
                          decoration: const InputDecoration(
                            hintText: "Nom de la maladie",
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: addMaladie,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),
                        child: const Text("Ajouter"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}