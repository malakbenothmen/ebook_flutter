import 'package:flutter/material.dart';
import '../../models/genre.dart';
import '../../models/livre.dart';


class FilterLivreScreen extends StatefulWidget {
  final List<Livre> livres;
  final List<Genre> genres;

  FilterLivreScreen({required this.livres, required this.genres});

  @override
  _FilterLivreScreenState createState() => _FilterLivreScreenState();
}

class _FilterLivreScreenState extends State<FilterLivreScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();

  Genre? _selectedGenre;
  List<Livre> _filteredLivres = [];

  @override
  void initState() {
    super.initState();
    _filteredLivres = List.from(widget.livres);
  }

  void _applyFilter() {
    setState(() {
      _filteredLivres = widget.livres.where((livre) {
        bool matchesName = livre.nomLivre.toLowerCase().contains(_nameController.text.toLowerCase());
        bool matchesAuthor = livre.nomAuteur.toLowerCase().contains(_authorController.text.toLowerCase());
        bool matchesGenre = _selectedGenre == null || livre.genre?.idGenre == _selectedGenre?.idGenre;

        return matchesName && matchesAuthor && matchesGenre;
      }).toList();
    });

    Navigator.pop(context, _filteredLivres);
  }

  void _resetFilters() {
    setState(() {
      _nameController.clear();
      _authorController.clear();
      _selectedGenre = null;
      _filteredLivres = List.from(widget.livres);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Filtrer les Livres', style: TextStyle(color: Colors.blue[800])),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.blue[800]),
      ),
      body: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Nom du Livre',
                prefixIcon: Icon(Icons.book, color: Colors.blue[800]),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _authorController,
              decoration: InputDecoration(
                labelText: 'Auteur',
                prefixIcon: Icon(Icons.person, color: Colors.blue[800]),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<Genre>(
              decoration: InputDecoration(
                labelText: 'Genre',
                prefixIcon: Icon(Icons.category, color: Colors.blue[800]),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              value: _selectedGenre,
              hint: Text('Sélectionner un genre'),
              onChanged: (Genre? newValue) {
                setState(() {
                  _selectedGenre = newValue;
                });
              },
              items: widget.genres.map<DropdownMenuItem<Genre>>((Genre genre) {
                return DropdownMenuItem<Genre>(
                  value: genre,
                  child: Text(genre.nomGenre),
                );
              }).toList(),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: _applyFilter,
              child: Text('Appliquer les Filtres'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
                backgroundColor: Colors.blue[800],
              ),
            ),
            TextButton(
              onPressed: _resetFilters,
              child: Text(
                'Réinitialiser les Filtres',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

