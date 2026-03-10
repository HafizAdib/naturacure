class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  List<Remede> remedes = [];

  @override
  void initState() {
    super.initState();
    loadRemedes();
  }

  void loadRemedes() async {
    remedes = await ApiService.getRemedes();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("NaTéraCure 🌿")),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: remedes.length,
        itemBuilder: (context, index) {

          var remede = remedes[index];

          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            margin: EdgeInsets.only(bottom: 16),
            child: ListTile(
              title: Text(remede.nom),
              subtitle: Text(remede.maladie),
              trailing: Text("❤️ ${remede.likes}"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        DetailScreen(remedeId: remede.id),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}