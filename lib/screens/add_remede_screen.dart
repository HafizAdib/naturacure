import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/api_service.dart';
import 'dart:io';

class AddProductScreen extends StatefulWidget {
  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {

  final _formKey = GlobalKey<FormState>();
  String nom = "";
  String description = "";
  String maladie = "";
  File? imageFile;

  Future pickImage() async {
    final picked = await ImagePicker().pickImage(
        source: ImageSource.gallery);

    if (picked != null) {
      setState(() {
        imageFile = File(picked.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Ajouter produit")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: "Nom"),
                onSaved: (v) => nom = v!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Maladie"),
                onSaved: (v) => maladie = v!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Description"),
                onSaved: (v) => description = v!,
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: pickImage,
                child: Text("Choisir image"),
              ),
              ElevatedButton(
                child: Text("Enregistrer"),
                onPressed: () async {
                  _formKey.currentState!.save();
                  if (imageFile != null) {
                    await ApiService.addProduit(
                        nom, description, maladie, imageFile!.path, "");
                  }
                  Navigator.pop(context);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}