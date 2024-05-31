import 'dart:convert';

import 'package:memeapp/Providers/AuthProvider.dart';
import 'package:memeapp/modalclass/meme_model.dart';
import 'package:http/http.dart' as http;
import '../Resources/Resources.dart';

class User {
  String email;
  String name;
  String phone;
  String? imageURL;
  String id;

  User(
      {required this.email,
      required this.name,
      required this.phone,
      this.imageURL,
      required this.id});

  static User parseFromJSON(Map<String, dynamic> rawUser) {
    return User(
        email: rawUser['email'],
        name: rawUser['name'],
        phone: rawUser['phone'],
        id: rawUser['id'],
        imageURL: rawUser['imageURL']);
  }

  Future<List<Meme>> PostedMemesByUser() async {
    String header = Authprovider.header;
    var response = await http.get(Uri.parse("$myIP/memes/by/$id"),
        headers: {'Authorization': 'Bearer $header'});
    if (response.statusCode == 200) {
      print('MEMES ARE POSTED: ${response.body}');
      return (jsonDecode(response.body) as List<dynamic>)
          .map((e) => Meme.parseFromJSON(e as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception("INVALID RESPONSE");
    }
  }

  Future<List<Meme>> LikeMemesByUser() async {
    String header = Authprovider.header;
    var response = await http.get(Uri.parse("$myIP/memes/liked/$id"),
        headers: {'Authorization': 'Bearer $header'});
    if (response.statusCode == 200) {
      return (jsonDecode(response.body) as List<dynamic>)
          .map((e) => Meme.parseFromJSON(e as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception("INVALID RESPONSE");
    }
  }
}
