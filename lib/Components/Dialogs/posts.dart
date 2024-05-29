// import 'package:flutter/cupertino.dart';
// import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:memeapp/Components/Screens/Inside_homepage01.dart';
import 'package:memeapp/Components/Screens/Inside_homepage02.dart';
import 'package:memeapp/Components/Screens/Inside_homepage03.dart';
// import 'package:memeapp/Providers/AuthProvider.dart';
import 'package:memeapp/Providers/MemeProvider.dart';
// import 'package:memeapp/Resources/Resources.dart';
import 'package:provider/provider.dart';

class Posts extends StatefulWidget {
  final String name;
  final String id;
  const Posts({super.key, required this.name, required this.id});

  @override
  State<Posts> createState() => _PostsState();
}

class _PostsState extends State<Posts> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: FutureBuilder(
        future: Provider.of<MemeProvider>(context, listen: false)
            .PostedMemesByUser(widget.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else {
            return Consumer<MemeProvider>(
              builder: (context, mProv, child) {
                final personsMemes = mProv.personMemes;

                return Column(
                  children: [
                    if (personsMemes.isEmpty)
                      Text("No posts to show",
                          style: TextStyle(fontWeight: FontWeight.w600)),
                    for (int i = 0; i < personsMemes.length; i++)
                      Column(
                        children: [
                          InsideHomepage01(index: i, meme: personsMemes[i]),
                          InsideHomepage02(index: i, meme: personsMemes[i]),
                          InsideHomepage03(index: i, meme: personsMemes[i]),
                          Divider(color: Colors.black),
                        ],
                      )
                  ],
                );
              },
            );
          }
        },
      ),
    );
  }
}
