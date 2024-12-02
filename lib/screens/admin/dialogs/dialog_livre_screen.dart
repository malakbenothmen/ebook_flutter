import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class DialogLivreScreen extends StatefulWidget {
  @override
  _AddLivreScreenState createState() => _AddLivreScreenState();
}

class _AddLivreScreenState extends State<DialogLivreScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  String? _selectedGenre;
  final List<String> _genres = ['Genre 1', 'Genre 2', 'Genre 3'];
  String? _imagePath;
  bool _isImagePicking = false;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _checkPermissions(); // Check permissions as soon as the screen loads
  }

  // Method to check permissions at the start
  Future<void> _checkPermissions() async {
    var statusCamera = await Permission.camera.request();
    var statusStorage = await Permission.photos.request();

    if (!statusCamera.isGranted || !statusStorage.isGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please allow access to camera and photos.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Method to pick an image from the gallery using getImage
  Future<void> _pickImage() async {
    print('Picking image...');  // Debugging line
    await _checkPermissions();

    setState(() {
      _isImagePicking = true;
    });

    try {
      final pickedFile = await _picker.getImage(source: ImageSource.gallery);  // Using getImage

      if (pickedFile != null) {
        setState(() {
          _imagePath = pickedFile.path;
          _isImagePicking = false;
        });
      } else {
        setState(() {
          _isImagePicking = false;
        });
      }
    } catch (e) {
      print('Error picking image: $e');  // Debugging line
      setState(() {
        _isImagePicking = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error picking image: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _pickDate() async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (selectedDate != null) {
      _dateController.text = selectedDate.toLocal().toString().split(' ')[0];
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate() && _selectedGenre != null) {
      final newLivre = {
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'nom': _nomController.text,
        'author': _authorController.text,
        'price': _priceController.text,
        'date': _dateController.text,
        'genre': _selectedGenre!,
        'image': _imagePath ?? 'https://via.placeholder.com/100',
      };
      Navigator.pop(context, newLivre);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Veuillez remplir tous les champs'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.blue[800]),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Ajouter Livre',
          style: TextStyle(
            color: Colors.blue[800],
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Container(
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
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _nomController,
                    decoration: InputDecoration(
                      labelText: 'Nom du Livre',
                      prefixIcon: Icon(Icons.book, color: Colors.blue[800]),
                    ),
                    validator: (value) =>
                    value == null || value.isEmpty ? 'Champ requis' : null,
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _authorController,
                    decoration: InputDecoration(
                      labelText: 'Auteur',
                      prefixIcon: Icon(Icons.person, color: Colors.blue[800]),
                    ),
                    validator: (value) =>
                    value == null || value.isEmpty ? 'Champ requis' : null,
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _priceController,
                    decoration: InputDecoration(
                      labelText: 'Prix (dt)',
                      prefixIcon: Icon(Icons.attach_money, color: Colors.blue[800]),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) =>
                    value == null || value.isEmpty ? 'Champ requis' : null,
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _dateController,
                    decoration: InputDecoration(
                      labelText: 'Date de Publication',
                      suffixIcon: IconButton(
                        icon: Icon(Icons.calendar_today, color: Colors.blue[800]),
                        onPressed: _pickDate,
                      ),
                    ),
                    readOnly: true,
                  ),
                  SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _selectedGenre,
                    hint: Text('Sélectionner un Genre'),
                    items: _genres
                        .map((genre) => DropdownMenuItem(value: genre, child: Text(genre)))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedGenre = value;
                      });
                    },
                    validator: (value) => value == null ? 'Sélectionnez un genre' : null,
                  ),
                  SizedBox(height: 16),
                  // "Add Image" Button
                  ElevatedButton(
                    onPressed: _pickImage, // Open the image picker
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text('Ajouter Image'),
                  ),
                  SizedBox(height: 16),
                  // Display selected image below the button
                  _imagePath == null
                      ? Text('Aucune image sélectionnée')
                      : _isImagePicking
                      ? Center(child: CircularProgressIndicator())
                      : Image.file(
                    File(_imagePath!),
                    height: 150,
                    width: 150,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 60),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(
                      'Ajouter Livre',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
