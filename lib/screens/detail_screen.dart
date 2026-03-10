class DetailScreen extends StatefulWidget {
  final int remedeId;

  DetailScreen({required this.remedeId});

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {

  Remede? remede;
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadDetail();
  }

  void loadDetail() async {
    remede = await ApiService.getRemede(widget.remedeId);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    if (remede == null) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: Text(remede!.nom)),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text(remede!.description),
            SizedBox(height: 20),
            TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: "Ajouter un commentaire...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              child: Text("Commenter"),
              onPressed: () async {
                await ApiService.commentRemede(
                    remede!.id, controller.text, "TOKEN_ICI");
                controller.clear();
              },
            )
          ],
        ),
      ),
    );
  }
}