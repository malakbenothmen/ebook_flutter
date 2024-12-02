import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GestionAuthorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Gestion Auteur")),
      body: Center(child: Text("Écran de gestion des auteurs")),
    );
  }
}