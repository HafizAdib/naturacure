import 'dart:async';
import 'package:flutter/material.dart';
import '../models/remede.dart';
import '../services/api_service.dart';
import '../services/session_service.dart';
import '../widgets/remedy_card.dart';
import 'detail_screen.dart';
import 'add_remede_screen.dart';
import 'login_screen.dart';
import 'admin_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _searchController = TextEditingController();

  String searchQuery = "";
  bool isLoading = true;
  bool showSearch = false;

  List<Remede> remedies = [];
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    fetchRemedies();
  }

  Future<void> fetchRemedies() async {
    setState(() => isLoading = true);
    try {
      final data = await ApiService.getRemedes();
      setState(() {
        remedies = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Impossible de récupérer les remèdes")),
      );
    }
  }

  Future<void> searchRemedies(String query) async {
    if (query.isEmpty) {
      fetchRemedies();
      return;
    }
    try {
      final result = await ApiService.searchRemedes(query);
      setState(() {
        remedies = result;
      });
    } catch (e) {
      print(e);
    }
  }

  void onSearchChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      searchRemedies(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
  child: Column(
    children: [
      UserAccountsDrawerHeader(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green.shade700, Colors.green.shade400],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        accountName: Text(
          SessionService.user?['name'] ?? "Utilisateur",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        accountEmail: Text(SessionService.user?['email'] ?? ""),
        currentAccountPicture: CircleAvatar(
          backgroundColor: Colors.white,
          child: Text(
            (SessionService.user?['name'] ?? "U")[0].toUpperCase(),
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
        ),
      ),

      // Ajouter un remède
      ListTile(
        leading: const Icon(Icons.add, color: Colors.green),
        title: const Text(
          "Ajouter un remède",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AddRemedeScreen()),
          );
        },
      ),

      // Bouton Admin visible uniquement si type = 'admin'
      if (SessionService.user?['type_user'] == 'admin')
        ListTile(
          leading: const Icon(Icons.admin_panel_settings, color: Colors.green),
          title: const Text(
            "Administration",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AdminScreen()),
            );
          },
        ),

      const Divider(),

      // Déconnexion
      ListTile(
        leading: const Icon(Icons.logout, color: Colors.green),
        title: const Text(
          "Déconnexion",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        onTap: () {
          SessionService.logout();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => LoginScreen()),
          );
        },
      ),

      const Spacer(),

      // Footer optionnel
      Padding(
        padding: const EdgeInsets.all(12.0),
        child: Text(
          "NaturaCure © 2026",
          style: TextStyle(color: Colors.green.shade700, fontSize: 12),
        ),
      ),
    ],
  ),
),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: showSearch
            ? const Text(
                "Recherche",
                style: TextStyle(color: Colors.black),
              )
            : Row(
                children: [
                  const SizedBox(width: 8),
                  const Icon(Icons.local_florist, color: Colors.green),
                  const SizedBox(width: 8),
                  const Text(
                    "NaturaCure",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
        leading: showSearch
            ? IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () {
                  setState(() {
                    showSearch = false;
                    _searchController.clear();
                  });
                  fetchRemedies();
                },
              )
            : null,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black),
            onPressed: () {
              setState(() {
                showSearch = !showSearch;
              });
            },
          ),
          /* IconButton(
            icon: const CircleAvatar(radius: 14),
            onPressed: () {
              _scaffoldKey.currentState?.openDrawer();
            },
          ), */
        ],
        bottom: showSearch
            ? PreferredSize(
                preferredSize: const Size.fromHeight(60),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Container(
                    height: 45,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: TextField(
                      controller: _searchController,
                      autofocus: true,
                      decoration: const InputDecoration(
                        hintText: "Rechercher un remède",
                        prefixIcon: Icon(Icons.search),
                        border: InputBorder.none,
                      ),
                      onChanged: onSearchChanged,
                    ),
                  ),
                ),
              )
            : null,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: fetchRemedies,
              child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: remedies.length,
                itemBuilder: (context, index) {
                  final remede = remedies[index];
                  return remedyCard(
                    remede: remede,
                    onTapCard: () {
                      if (SessionService.token != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailScreen(remede: remede),
                          ),
                        );
                      } else {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text("Connexion requise"),
                            content: const Text(
                                "Vous devez être connecté pour voir les détails et interagir avec ce remède."),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text("OK"),
                              ),
                              TextButton(
                                onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => LoginScreen()),
                                ),
                                child: const Text("Se connecter"),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
        onPressed: () {
          if (SessionService.token != null) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddRemedeScreen()),
            );
          } else {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text("Connexion requise"),
                content: const Text("Vous devez être connecté pour ajouter un remède."),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("OK"),
                  ),
                  TextButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    ),
                    child: const Text("Se connecter"),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}