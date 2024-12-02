import 'package:flutter/material.dart';
import 'package:ebook_flutter/models/genre.dart';
import 'package:ebook_flutter/services/genreService.dart';

class GestionGenreScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestion de Genre',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: Colors.blue[800],
        visualDensity: VisualDensity.adaptivePlatformDensity,
        scaffoldBackgroundColor: Colors.white,
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.blue.shade50, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.blue.shade50, width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.blue[800]!, width: 2),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.blue[800],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 0,
          ),
        ),
      ),
      home: GestionGenrePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class GestionGenrePage extends StatefulWidget {
  @override
  _GestionGenrePageState createState() => _GestionGenrePageState();
}

class _GestionGenrePageState extends State<GestionGenrePage> {
  List<Genre> genres = [];
  bool _isEditMode = false;
  int? _editIndex;

  final TextEditingController _idController = TextEditingController();
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchGenres(); // Charger les genres au démarrage
  }

  Future<void> _fetchGenres() async {
    try {
      var fetchedGenres = await getAllGenre();
      setState(() {
        genres = fetchedGenres.map<Genre>((data) => Genre(data['nomGenre'], data['descGenre'], data['idGenre'])).toList();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur lors du chargement des genres'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _addOrUpdateGenre() async {
    if (_nomController.text.isEmpty || _descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Veuillez remplir tous les champs'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    Genre genre = Genre(
      _nomController.text,
      _descriptionController.text,
      _isEditMode ? int.parse(_idController.text) : null,
    );

    try {
      if (_isEditMode) {
        await updateGenre(genre);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Genre mis à jour avec succès')),
        );
      } else {
        await addGenre(genre);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Genre ajouté avec succès')),
        );
      }
      _fetchGenres();
      _resetForm();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur lors de l\'opération'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _deleteGenre(int index) async {
    bool? confirmDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmer la suppression'),
          content: Text('Êtes-vous sûr de vouloir supprimer ce genre ?'),
          actions: <Widget>[
            TextButton(
              child: Text('Annuler'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            ElevatedButton(
              child: Text('Supprimer'),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    );

    if (confirmDelete == true) {
      try {
        await deleteGenre(genres[index].idGenre!);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Genre supprimé avec succès')),
        );
        _fetchGenres();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors de la suppression du genre'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _resetForm() {
    _idController.clear();
    _nomController.clear();
    _descriptionController.clear();
    setState(() {
      _isEditMode = false;
      _editIndex = null;
    });
  }

  void _editGenre(int index) {
    setState(() {
      _isEditMode = true;
      _editIndex = index;

      _idController.text = genres[index].idGenre.toString();
      _nomController.text = genres[index].nomGenre;
      _descriptionController.text = genres[index].descGenre;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.blue[800], size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Gestion des Genres',
          style: TextStyle(
            color: Colors.blue[800],
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.1),
                        spreadRadius: 3,
                        blurRadius: 5,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _isEditMode ? 'Modifier Genre' : 'Ajouter Genre',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[800],
                        ),
                      ),
                      SizedBox(height: 20),
                      TextField(
                        controller: _idController,
                        decoration: InputDecoration(
                          labelText: 'ID Genre',
                          enabled: false,
                        ),
                      ),
                      SizedBox(height: 16),
                      TextField(
                        controller: _nomController,
                        decoration: InputDecoration(
                          labelText: 'Nom Genre',
                          prefixIcon: Icon(Icons.category, color: Colors.lightBlue),
                        ),
                      ),
                      SizedBox(height: 16),
                      TextField(
                        controller: _descriptionController,
                        decoration: InputDecoration(
                          labelText: 'Description Genre',
                          prefixIcon: Icon(Icons.description, color: Colors.lightBlue),
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _addOrUpdateGenre,
                              style: ElevatedButton.styleFrom(
                                minimumSize: Size(double.infinity, 60),
                              ),
                              child: Text(
                                _isEditMode ? 'Modifier' : 'Ajouter',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          if (_isEditMode)
                            SizedBox(width: 16),
                          if (_isEditMode)
                            ElevatedButton(
                              onPressed: _resetForm,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue[50],
                                foregroundColor: Colors.blue[800],
                                minimumSize: Size(100, 60),
                              ),
                              child: Text(
                                'Annuler',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Liste des Genres',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[800],
                  ),
                ),
                SizedBox(height: 10),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: genres.length,
                  itemBuilder: (context, index) {
                    final genre = genres[index];
                    return Container(
                      margin: EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.withOpacity(0.1),
                            spreadRadius: 3,
                            blurRadius: 5,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ListTile(
                        title: Text(genre.nomGenre),
                        subtitle: Text(genre.descGenre),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit),
                              color: Colors.blue[800],
                              onPressed: () => _editGenre(index),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              color: Colors.red[300],
                              onPressed: () => _deleteGenre(index),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
