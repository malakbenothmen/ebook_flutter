import 'genre.dart';

class Livre {
  int? idLivre;
  String nomLivre;
  String nomAuteur;
  double prixLivre;
  DateTime datePublication;
  Genre? genre;

  String? imagePath;

  Livre(this.nomLivre, this.nomAuteur, this.prixLivre,
      this.datePublication, this.genre,
      this.imagePath, [this.idLivre]);



  // Méthode pour créer un Livre à partir de JSON
  factory Livre.fromJson(Map<String, dynamic> json) {
    return Livre(
      json['nomLivre'] as String,
      json['nomAuteur'] as String,
      (json['prixLivre'] as num).toDouble(),
      DateTime.parse(json['datePublication'] as String),
      json['genre'] != null ? Genre.fromJson(json['genre']) : null,
      json['imagePath'] as String?,
      json['idLivre'] as int?,
    );
  }

  // Méthode pour convertir un Livre en JSON
  Map<String, dynamic> toJson() {
    return {
      'idLivre': idLivre,
      'nomLivre': nomLivre,
      'nomAuteur': nomAuteur,
      'prixLivre': prixLivre,
      'datePublication': datePublication.toIso8601String(),
      'genre': genre?.toJson(),
      'imagePath': imagePath,
    };
  }
}

