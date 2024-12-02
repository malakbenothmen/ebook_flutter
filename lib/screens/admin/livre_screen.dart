import 'package:flutter/material.dart';
import 'dart:io';
import 'package:ebook_flutter/services/livreService.dart';
import 'package:ebook_flutter/services/genreService.dart';
import 'package:ebook_flutter/models/livre.dart';
import 'package:ebook_flutter/models/genre.dart';
import 'dialogs/dialog_livre_screen.dart';
import 'filter_livre_screen.dart';

class GestionLivreScreen extends StatefulWidget {
  @override
  _ListesLivresPageState createState() => _ListesLivresPageState();
}

class _ListesLivresPageState extends State<GestionLivreScreen> {
  List<Livre> livres = [];
  List<Livre> displayedLivres = [];
  List<Genre> genres = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadLivres();
    _loadGenres();
  }

  Future<void> _loadLivres() async {
    try {
      final livresData = await getAllLivre();
      setState(() {
        livres = (livresData as List).map((item) => Livre(
          item['nomLivre'],
          item['nomAuteur'],
          item['prixLivre'].toDouble(),
          DateTime.parse(item['datePublication']),
          Genre(item['genre']['nomGenre'], item['genre']['descGenre'], item['genre']['idGenre']),
          item['imagePath'],
          item['idLivre'],
        )).toList();
        displayedLivres = List.from(livres);
      });
    } catch (e) {
      print('Error loading livres: $e');
      // Handle error (show a snackbar, for example)
    }
  }

  Future<void> _loadGenres() async {
    try {
      final genresData = await getAllGenre();
      setState(() {
        genres = (genresData as List).map((item) => Genre(
          item['nomGenre'],
          item['descGenre'],
          item['idGenre'],
        )).toList();
      });
    } catch (e) {
      print('Error loading genres: $e');
      // Handle error
    }
  }

  void _searchLivre(String query) {
    setState(() {
      if (query.isEmpty) {
        displayedLivres = List.from(livres);
      } else {
        displayedLivres = livres
            .where((livre) =>
            livre.nomLivre.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  void _addLivre() async {
    final newLivre = await Navigator.push<Livre>(
      context,
      MaterialPageRoute(builder: (context) => DialogLivreScreen(/*genres: genres*/)),
    );
    if (newLivre != null) {
      setState(() {
        livres.add(newLivre);
        displayedLivres = List.from(livres);
      });
    }
  }

  void _editLivre(int index) async {
    final updatedLivre = await Navigator.push<Livre>(
      context,
      MaterialPageRoute(
        builder: (context) => DialogLivreScreen(/*livreToEdit: displayedLivres[index],
          genres: genres,*/
        ),
      ),
    );
    if (updatedLivre != null) {
      setState(() {
        int originalIndex = livres.indexWhere((livre) => livre.idLivre == updatedLivre.idLivre);
        if (originalIndex != -1) {
          livres[originalIndex] = updatedLivre;
        }
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
            onPressed: () async {
              try {
                await deleteLivre(displayedLivres[index].idLivre!);
                setState(() {
                  livres.removeWhere((livre) => livre.idLivre == displayedLivres[index].idLivre);
                  displayedLivres.removeAt(index);
                });
                Navigator.pop(context);
              } catch (e) {
                print('Error deleting livre: $e');
                Navigator.pop(context);
                // Show error message to user
              }
            },
            child: Text('Supprimer'),
          ),
        ],
      ),
    );
  }

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
    // The build method remains largely the same, but we'll update the ListView.builder
    // to use the Livre objects instead of Map<String, String>
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
              final filteredLivres = await Navigator.push<List<Livre>>(
                context,
                MaterialPageRoute(
                  builder: (context) => FilterLivreScreen(livres: livres, genres: genres),
                ),
              );
              if (filteredLivres != null) {
                setState(() {
                  displayedLivres = filteredLivres;
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
                      child: ListTile(
                        contentPadding: EdgeInsets.all(16),
                        leading: (livre.imagePath != null && livre.imagePath!.isNotEmpty)
                            ? (livre.imagePath!.startsWith('http')
                            ? Image.network(
                          livre.imagePath!,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return _buildPlaceholderImage();
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return _buildPlaceholderImage();
                          },
                        )
                            : Image(
                          image: FileImage(File(livre.imagePath!)),
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return _buildPlaceholderImage();
                          },
                        ))
                            : _buildPlaceholderImage(),
                        title: Text(
                          livre.nomLivre,
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Auteur: ${livre.nomAuteur}'),
                            Text('Genre: ${livre.genre?.nomGenre ?? 'N/A'}'),
                            Text('Prix: ${livre.prixLivre} DT'),
                            Text('Publié le: ${livre.datePublication.toIso8601String().split('T')[0]}'),
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
                      ),
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
}

