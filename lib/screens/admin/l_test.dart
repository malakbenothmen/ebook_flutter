/*import 'package:flutter/material.dart';
import 'dart:io';

import 'dialogs/dialog_livre_screen.dart';
import 'filter_livre_screen.dart';



void main() => runApp(ListesLivresApp());

class ListesLivresApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestion des Livres',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: Colors.blue[800],
        scaffoldBackgroundColor: Colors.white,
      ),
      home: ListesLivresPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ListesLivresPage extends StatefulWidget {
  @override
  _ListesLivresPageState createState() => _ListesLivresPageState();
}

class _ListesLivresPageState extends State<ListesLivresPage> {
  List<Map<String, String>> livres = [
    {
      'id': '1',
      'nom': 'Livre 1',
      'author': 'Auteur 1',
      'price': '20.00',
      'date': '2023-01-01',
      'genre': 'Genre 1',
      'image': 'https://via.placeholder.com/100',
    },
    {
      'id': '2',
      'nom': 'Livre 2',
      'author': 'Auteur 2',
      'price': '15.00',
      'date': '2023-02-01',
      'genre': 'Genre 2',
      'image': 'https://via.placeholder.com/100',
    },
  ];

  List<Map<String, String>> displayedLivres = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    displayedLivres = List.from(livres);
  }

  void _searchLivre(String query) {
    setState(() {
      if (query.isEmpty) {
        displayedLivres = List.from(livres);
      } else {
        displayedLivres = livres
            .where((livre) =>
            livre['nom']!.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  void _addLivre() async {
    final newLivre = await Navigator.push<Map<String, String>>(
      context,
      MaterialPageRoute(builder: (context) => AddLivreScreen()),
    );
    if (newLivre != null) {
      setState(() {
        livres.add(newLivre);
        displayedLivres = List.from(livres);  // Update the list after addition
      });
    }
  }

  void _editLivre(int index) async {
    final updatedLivre = await Navigator.push<Map<String, String>>(
      context,
      MaterialPageRoute(
        builder: (context) => AddLivreScreen(
         // livreToEdit: displayedLivres[index],
        ),
      ),
    );
    if (updatedLivre != null) {
      setState(() {
        displayedLivres[index] = updatedLivre;
      });
    }
  }

  void _deleteLivre(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Supprimer le livre'),
        content: Text('Êtes-vous sûr de vouloir supprimer ce livre?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                livres.removeAt(index);
                displayedLivres = List.from(livres);  // Update the list after deletion
              });
              Navigator.pop(context);
            },
            child: Text('Supprimer'),
          ),
        ],
      ),
    );
  }

  // Method to return a placeholder image when image loading fails
  Widget _buildPlaceholderImage() {
    return Container(
      width: 80,
      height: 80,
      color: Colors.grey[200],
      child: Icon(Icons.book, color: Colors.blue[800]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Liste des Livres', style: TextStyle(color: Colors.blue[800])),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list, color: Colors.blue[800]),
            onPressed: () async {
              final filteredLivres = await Navigator.push<List<Map<String, String>>>(
                context,
                MaterialPageRoute(
                  builder: (context) => FilterLivreScreen(livres: livres), // Pass the current list of books
                ),
              );
              if (filteredLivres != null) {
                setState(() {
                  displayedLivres = filteredLivres; // Update the displayed books
                });
              }
            },
          ),

        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: searchController,
                onChanged: _searchLivre,
                decoration: InputDecoration(
                  labelText: 'Rechercher',
                  prefixIcon: Icon(Icons.search, color: Colors.blue[800]),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              Expanded(
                child: displayedLivres.isEmpty
                    ? Center(child: Text('Aucun livre trouvé.'))
                    : ListView.builder(
                  itemCount: displayedLivres.length,
                  itemBuilder: (context, index) {
                    final livre = displayedLivres[index];
                    return Card(
                        margin: EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
                        child:
                        ListTile(
                          contentPadding: EdgeInsets.all(16),
                          leading: (livre['image'] != null && livre['image']!.isNotEmpty)
                              ? (livre['image']!.startsWith('http') // Check if it's a network URL
                              ? Image.network(
                            livre['image']!,
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) {
                                return child;
                              } else {
                                return _buildPlaceholderImage();
                              }
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return _buildPlaceholderImage();
                            },
                          )
                              : Image(
                            image: FileImage(File(livre['image']!)), // Use FileImage for local files
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return _buildPlaceholderImage();
                            },
                          ))
                              : _buildPlaceholderImage(), // Use placeholder if the image is null or empty
                          title: Text(
                            livre['nom']!,
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Auteur: ${livre['author']}'),
                              Text('Genre: ${livre['genre']}'),
                              Text('Prix: ${livre['price']} DT'),
                              Text('Publié le: ${livre['date']}'),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit, color: Colors.blue[800]),
                                onPressed: () => _editLivre(index),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _deleteLivre(index),
                              ),
                            ],
                          ),
                          onTap: () => _editLivre(index),
                        )

                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addLivre,
        backgroundColor: Colors.blue[800],
        child: Icon(Icons.add),
      ),
    );
  }
}*/