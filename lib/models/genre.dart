
class Genre {
   int? idGenre;
   String nomGenre;
   String descGenre;


  Genre(this.nomGenre, this.descGenre,[this.idGenre]);

   // Méthode pour créer un Genre à partir de JSON
   factory Genre.fromJson(Map<String, dynamic> json) {
     return Genre(
       json['nomGenre'] as String,
       json['descGenre'] as String,
       json['idGenre'] as int?,
     );
   }

   // Méthode pour convertir un Genre en JSON
   Map<String, dynamic> toJson() {
     return {
       'idGenre': idGenre,
       'nomGenre': nomGenre,
       'descGenre': descGenre,
     };
   }
}