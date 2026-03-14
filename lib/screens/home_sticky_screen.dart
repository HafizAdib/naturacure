import 'package:flutter/material.dart';

class HomeScreenSticky extends StatefulWidget {
  const HomeScreenSticky({super.key});

  @override
  State<HomeScreenSticky> createState() => _HomeScreenStickyState();
}

class _HomeScreenStickyState extends State<HomeScreenSticky> {
  final TextEditingController _searchController = TextEditingController();
  String searchQuery = "";
  bool showApprovedOnly = false;

  final List<String> remedies = List.generate(20, (index) => "Remède $index");

  @override
  Widget build(BuildContext context) {
    List<String> filteredRemedies = remedies.where((r) => r.toLowerCase().contains(searchQuery.toLowerCase())).toList();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            backgroundColor: Colors.green,
            expandedHeight: 140,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text("NaturaCure"),
              centerTitle: true,
            ),
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
                              backgroundColor: !showApprovedOnly ? Colors.white : Colors.grey[300],
                              foregroundColor: !showApprovedOnly ? Colors.green : Colors.black,
                            ),
                            onPressed: () {
                              setState(() {
                                showApprovedOnly = false;
                              });
                            },
                            child: const Text("Tous"),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: showApprovedOnly ? Colors.white : Colors.grey[300],
                              foregroundColor: showApprovedOnly ? Colors.green : Colors.black,
                            ),
                            onPressed: () {
                              setState(() {
                                showApprovedOnly = true;
                              });
                            },
                            child: const Text("Approuvés"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text(filteredRemedies[index]),
                  ),
                );
              },
              childCount: filteredRemedies.length,
            ),
          ),
        ],
      ),
    );
  }
}