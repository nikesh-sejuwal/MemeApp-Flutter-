import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:memeapp/Providers/MemeProvider.dart';
import 'package:memeapp/Resources/Resources.dart';
import 'package:memeapp/modalclass/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Authprovider with ChangeNotifier {
  User? user;
  static String header = '';

  Authprovider() {
    getUserFromSavedToken();
  }

  void setHeader(String H) {
    header = H;
    print('ThE HEADER IS $header');
    MemeProvider.setHeader(header);
    // notifyListeners();
  }

  Future<User?> getUserFromSavedToken() async {
    var prefs = await SharedPreferences.getInstance();
    String? savedToken = await prefs.getString('headers');
    if (savedToken == null) return null;
    if (savedToken.isEmpty) return null;
    setHeader(savedToken);
    // notifyListeners();
    var response = await http.get(Uri.parse('$myIP/users/me'),
        headers: {'Authorization': 'Bearer $savedToken'});
    print('Response body from auth: ${response.body}');
    if (response.statusCode == 200) {
      var decodedInfo = jsonDecode(response.body);
      user = User.parseFromJSON(decodedInfo);

      print("THE BODY IS LLLL ${response.body}");
      notifyListeners();
      return user;
    } else {
      print("ERROR getting User: ${response.body}");
      return null;
    }
  }

  void saveToken() async {
    try {
      var prefs = await SharedPreferences.getInstance();
      await prefs.setString('headers', header);
      print('THE SAVED TOKEN IS $header ');
    } catch (e) {
      print("ERROR FROM sAVE $e");
    }
  }

  // void UpdateName() async {
  //   var response = await http.get(
  //     Uri.parse("$myIP/users/me"),
  //     headers: {
  //       'Authorization': "Bearer $header",
  //     },
  //   );
  // }
}
