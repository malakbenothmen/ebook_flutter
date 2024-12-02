import 'dart:convert';

import 'package:http/http.dart' as http ;
import 'package:http/http.dart';

import '../models/livre.dart';


const String baseUrl = "http://10.0.2.2:8083/livres/api";
Future getAllLivre() async{

  Response response =await  http.get(Uri.parse("http://10.0.2.2:8083/livres/api/all"));
  return jsonDecode(response.body);

}

Future deleteLivre(int id) async {
  final response = await http.delete(
    Uri.parse("http://10.0.2.2:8083/livres/api/delliv/$id"),
  );

  if (response.statusCode == 200) {
    // Suppression réussie
    return "Genre deleted successfully";
  } else {
    // En cas d'erreur
    return "Failed to delete genre: ${response.body}";
  }
}


Future<Livre> addLivre(Livre livre) async {
  final response = await http.post(
    Uri.parse("$baseUrl/addliv"),
    headers: {"Content-Type": "application/json"},
    body: json.encode(livre.toJson()),
  );
  if (response.statusCode == 200) {
    return Livre.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to add livre');
  }
}

Future<Livre> updateLivre(Livre livre) async {
  final response = await http.put(
    Uri.parse("$baseUrl/updateliv"),
    headers: {"Content-Type": "application/json"},
    body: json.encode(livre.toJson()),
  );
  if (response.statusCode == 200) {
    return Livre.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to update livre');
  }
}
