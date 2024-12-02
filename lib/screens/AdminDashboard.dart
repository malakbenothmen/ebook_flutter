import 'package:flutter/material.dart';

import 'admin/author_screen.dart';
import 'admin/genre_screen.dart';
import 'admin/livre_screen.dart';

class AdminDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue, // Fond bleu
      appBar: AppBar(
        title: Text("Admin Dashboard"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Bouton Gestion Livre
            ElevatedButton(
              onPressed: () {
                // Naviguer vers la page de gestion des livres
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GestionLivreScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.book, color: Colors.blue),
                  SizedBox(width: 8),
                  Text(
                    "Gestion Livre",
                    style: TextStyle(color: Colors.blue, fontSize: 18),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Bouton Gestion Genre
            ElevatedButton(
              onPressed: () {
                // Naviguer vers la page de gestion des genres
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GestionGenreScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.category, color: Colors.blue),
                  SizedBox(width: 8),
                  Text(
                    "Gestion Genre",
                    style: TextStyle(color: Colors.blue, fontSize: 18),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Bouton Gestion Auteur
            ElevatedButton(
              onPressed: () {
                // Naviguer vers la page de gestion des auteurs
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GestionAuthorScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.person, color: Colors.blue),
                  SizedBox(width: 8),
                  Text(
                    "Gestion Auteur",
                    style: TextStyle(color: Colors.blue, fontSize: 18),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}