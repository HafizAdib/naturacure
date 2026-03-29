import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../services/session_service.dart';

class AddRemedeScreen extends StatefulWidget {
  const AddRemedeScreen({super.key});

  @override
  State<AddRemedeScreen> createState() => _AddRemedeScreenState();
}

class _AddRemedeScreenState extends State<AddRemedeScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  List<dynamic> maladies = [];
  dynamic selectedMaladie;

  bool isSubmitting = false;

  List<Map<String, String>> etapes = [];

  @override
  void initState() {
    super.initState();
    _loadMaladies();
  }

  Future<void> _loadMaladies() async {
    try {
      final data = await ApiService.getMaladies();
      setState(() {
        maladies = data;
      });
    } catch (e) {
      print("Erreur chargement maladies : $e");
    }
  }

  void _addEtape() {
    setState(() {
      etapes.add({'ordre': '${etapes.length + 1}', 'description': ''});
    });
  }

  void _removeEtape(int index) {
    setState(() {
      etapes.removeAt(index);
      for (int i = 0; i < etapes.length; i++) {
        etapes[i]['ordre'] = '${i + 1}';
      }
    });
  }

  Future<void> _submitRemede() async {
    if (!_formKey.currentState!.validate()) return;

    if (selectedMaladie == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Veuillez sélectionner ou créer une maladie")),
      );
      return;
    }

    if (etapes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Ajoutez au moins une étape")),
      );
      return;
    }

    setState(() => isSubmitting = true);

    try {
      final token = SessionService.token!;
      final etapesList = etapes.asMap().entries.map((entry) {
        return {
          "num_etape": entry.key + 1,
          "instructions": entry.value['description']
        };
      }).toList();

      // Envoi API
      await ApiService.addRemede(
        nom: _nomController.text,
        description: _descriptionController.text,
        maladieId: selectedMaladie['id'], // null si nouvelle maladie
        maladie: selectedMaladie['id'] == null ? selectedMaladie['nom'] : null,
        etapes: etapesList,
        token: token,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Remède ajouté avec succès")),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur : $e")),
      );
    }

    setState(() => isSubmitting = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ajouter un remède"),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nomController,
                decoration: const InputDecoration(
                  labelText: "Nom du remède",
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? "Veuillez entrer un nom" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: "Description",
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? "Veuillez entrer une description" : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<dynamic>(
                decoration: const InputDecoration(
                  labelText: "Maladie",
                  border: OutlineInputBorder(),
                ),
                value: selectedMaladie,
                items: maladies.map((m) {
                  return DropdownMenuItem(
                    value: m,
                    child: Text(m['nom']),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() => selectedMaladie = value);
                },
              ),
              /* TextButton.icon(
                icon: const Icon(Icons.add),
                label: const Text("Ajouter une nouvelle maladie"),
                onPressed: () {
                  TextEditingController controller = TextEditingController();
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("Nouvelle maladie"),
                      content: TextField(
                        controller: controller,
                        decoration: const InputDecoration(hintText: "Nom de la maladie"),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("Annuler"),
                        ),
                        TextButton(
                          onPressed: () {
                            if (controller.text.trim().isEmpty) return;

                            final newMaladie = {"id": null, "nom": controller.text.trim()};

                            setState(() {
                              maladies.add(newMaladie);
                              selectedMaladie = newMaladie;
                            });

                            Navigator.pop(context);
                          },
                          child: const Text("Ajouter"),
                        ),
                      ],
                    ),
                  );
                },
              ), */
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Étapes de composition", style: TextStyle(fontWeight: FontWeight.bold)),
                  IconButton(onPressed: _addEtape, icon: const Icon(Icons.add)),
                ],
              ),
              const SizedBox(height: 8),
              ...etapes.asMap().entries.map((entry) {
                final index = entry.key;
                final etape = entry.value;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          initialValue: etape['description'],
                          decoration: InputDecoration(
                            labelText: "Étape ${etape['ordre']}",
                            border: const OutlineInputBorder(),
                          ),
                          onChanged: (value) => etapes[index]['description'] = value,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _removeEtape(index),
                      ),
                    ],
                  ),
                );
              }).toList(),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isSubmitting ? null : _submitRemede,
                  child: isSubmitting
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Ajouter"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}