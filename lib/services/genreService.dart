import 'dart:convert';

import 'package:http/http.dart' as http ;
import 'package:http/http.dart';

import '../models/genre.dart';

Future getAllGenre() async{

  Response response =await  http.get(Uri.parse("http://10.0.2.2:8083/livres/api/genre"));
  return jsonDecode(response.body);

}

Future addGenre(Genre genre)async
{
  Response response = await http.post(Uri.parse("http://10.0.2.2:8083/livres/api/genre"),
      headers:{
        "Content-type":"Application/json"
      },body:jsonEncode(<String,dynamic>{
        "nomGenre":genre.nomGenre,
        "descGenre":genre.descGenre,
      }
      ));

  return response.body;
}


Future updateGenre(Genre genre)async
{
  Response response = await http.put(Uri.parse("http://10.0.2.2:8083/livres/api/genre/update"),
      headers:{
        "Content-type":"Application/json"
      },body:jsonEncode(<String,dynamic>{
        "idGenre":genre.idGenre,
        "nomGenre":genre.nomGenre,
        "descGenre":genre.descGenre,
      }
      ));

  return response.body;
}

Future deleteGenre(int id) async {
  final response = await http.delete(
    Uri.parse("http://10.0.2.2:8083/livres/api/genre/delete/$id"), // Corrigé pour correspondre à la route backend
  );

  if (response.statusCode == 200) {
    // Suppression réussie
    return "Genre deleted successfully";
  } else {
    // En cas d'erreur
    return "Failed to delete genre: ${response.body}";
  }
}

