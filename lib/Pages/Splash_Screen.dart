import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:memeapp/Components/Screens/Log%20in/SignUp_Page.dart';
import 'package:memeapp/Pages/Home_Page.dart';
import 'package:memeapp/Providers/AuthProvider.dart';
import 'package:provider/provider.dart';

// import 'package:memeapp/Resources/Resources.dart';

class Splash_Screen extends StatefulWidget {
  const Splash_Screen({super.key});

  @override
  State<Splash_Screen> createState() => _Splash_ScreenState();
}

class _Splash_ScreenState extends State<Splash_Screen> {
  @override
  void initState() {
    checkToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Colors.yellow.shade600,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Image.asset(
                'lib/Resources/images/memantic_logo.png',
                height: 200,
                width: 300,
              ),
              SizedBox(height: 80),
              LoadingAnimationWidget.hexagonDots(color: Colors.black, size: 50),
              SizedBox(height: 200),
              Text(
                'Memantic version 1.0.0',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  void checkToken() async {
    var user = await Provider.of<Authprovider>(context, listen: false)
        .getUserFromSavedToken();
    await Future.delayed(Duration(seconds: 2));
    if (user == null) {
      Navigator.of(context)
          .pushReplacement(CupertinoPageRoute(builder: (c) => SignUp_Page()));
    } else {
      Navigator.of(context)
          .pushReplacement(CupertinoPageRoute(builder: (c) => Home_Page(
            
          )));
    }
    // var prefs = await SharedPreferences.getInstance();
    // var token = await prefs.getString('headers') ?? '';
    // await Future.delayed(Duration(seconds: 2));
    // if (token.isEmpty) {
    //   Navigator.of(context)
    //       .pushReplacement(CupertinoPageRoute(builder: (c) => SignUp_Page()));
    // }
    // if (token.isNotEmpty) {
    //   Navigator.of(context)
    //       .pushReplacement(CupertinoPageRoute(builder: (C) => Home_Page()));
    // }
  }
}
