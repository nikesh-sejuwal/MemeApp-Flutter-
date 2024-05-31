import 'package:flutter/material.dart';
import 'package:memeapp/Components/Screens/Log%20in/SignIn_Page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Dialog_Box extends StatelessWidget {
  const Dialog_Box({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        "Logout",
        style: TextStyle(
            color: Colors.red, fontSize: 22, fontWeight: FontWeight.bold),
      ),
      // backgroundColor: Colors.amber.shade800,
      content: Container(
          height: 100,
          width: 80,
          child: Column(
            children: [
              SizedBox(height: 5),
              Text("Sure! You want to logout?",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: Icon(Icons.close, color: Colors.red, size: 35)),
                  IconButton(
                      onPressed: () async {
                        var prefs = await SharedPreferences.getInstance();
                        prefs.setString('headers', '');
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (c) => SignIn_Page()));
                      },
                      icon: Icon(Icons.check, color: Colors.green, size: 35))
                ],
              )
            ],
          )),
    );
  }
}
