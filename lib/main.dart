import 'package:flutter/material.dart';

import 'package:memeapp/Pages/Splash_Screen.dart';
import 'package:memeapp/Providers/AuthProvider.dart';
import 'package:memeapp/Providers/MemeProvider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider<Authprovider>(
            create: (context) => Authprovider()),
        ChangeNotifierProvider<MemeProvider>(
            create: (context) => MemeProvider())
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false, home: Splash_Screen())));
}

class Main_Page extends StatelessWidget {
  const Main_Page({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Splash_Screen();
  }
}
