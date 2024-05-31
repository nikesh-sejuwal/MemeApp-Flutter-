import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
// import 'package:memeapp/Components/Dialogs/caption_Edit.dart';
import 'package:memeapp/Resources/Resources.dart';
import 'package:memeapp/modalclass/meme_model.dart';
// import 'package:memeapp/modalclass/user_model.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class MemeProvider with ChangeNotifier {
  MemeProvider() {
    getMemes();
  }

  static String? header;

  static void setHeader(String newHeader) {
    header = newHeader;
    print("New header set to $header.");
  }

  List<Meme> memes = [];

  void getMemes() async {
    try {
      if (header == null) {
        throw Exception("Header not set yet.");
      }
      // print("HEADER BeFORE:$header");
      var response = await http.get(Uri.parse('$myIP/memes'),
          headers: {'Authorization': 'Bearer $header'});
      // print("HEADER AFTER: $header");
      // print('MY RESPONSE BODY IS: ${response.body}');
      print('Status code: ${response.statusCode} is is is');
      if (response.statusCode == 200) {
        var decodedInfo = (jsonDecode(response.body) as List<dynamic>);
        memes = decodedInfo
            .map((e) => Meme.parseFromJSON(e as Map<String, dynamic>))
            .toList();
        print("THE MEMES ARE $memes");
        notifyListeners();
      }
    } catch (e) {
      print("Error occurs $e");
    }
  }

  void toggleFunction(String memeId) async {
    try {
      var response = await http.post(
          Uri.parse('$myIP/memes/${memeId}/toggle-like'),
          headers: {"Authorization": "Bearer $header "});

      print(header);
      print(response.statusCode);
      if (response.statusCode == 200) {
        var mydecode = jsonDecode(response.body);
        for (int i = 0; i < memes.length; i++) {
          if (memes[i].id == memeId) {
            print('Match found');
            memes[i].likes = (mydecode['likes'] as List<dynamic>)
                .map((e) => e as String)
                .toList();
            // print("MY RESPONSE IS   ${mydecode}");
            // getMemes();
            // print("THE MATCHS ARE: ${memes[i].likes}");
            notifyListeners();
            break;
          }
          // break;
        }
        // notifyListeners();
      }
    } catch (e) {
      print('errorrrr at toggle: $e');
    }
  }

  void deleteMeme(String memeId) async {
    try {
      var response = await http.delete(Uri.parse('$myIP/memes/$memeId'),
          headers: {"Authorization": "Bearer $header"});
      if (response.statusCode == 200) {
        for (int i = 0; i < memes.length; i++) {
          if (memes[i].id == memeId) {
            print(' MEME ID IS ${memes[i]}');
            memes.removeAt(i);
            notifyListeners();
          }
        }
        print("DELETION");
      }
      if (response.statusCode == 500) {
        throw Exception("No Authorized to delete others meme");
      }
    } catch (e) {
      print("Errorr at the deletion: $e");
    }
  }

  void updateCaption(String memeId, String myCaption) async {
    var response = await http.patch(Uri.parse("$myIP/memes/$memeId"),
        headers: {
          "Authorization": "Bearer $header",
          "Content-type": "application/json"
        },
        body: jsonEncode({"caption": myCaption}));
    if (response.statusCode == 200) {
      for (int i = 0; i < memes.length; i++) {
        if (memes[i].id == memeId) {
          memes[i].caption = jsonDecode(response.body)['meme']['caption'];
          notifyListeners();
        }
      }
    } else {
      print("ERROR ON OTHER THAN 200");
    }
  }
}
