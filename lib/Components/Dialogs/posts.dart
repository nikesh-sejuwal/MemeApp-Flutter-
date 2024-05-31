// import 'package:flutter/cupertino.dart';
// import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:memeapp/Components/Screens/home/Inside_homepage01.dart';
import 'package:memeapp/Components/Screens/home/Inside_homepage02.dart';
import 'package:memeapp/Components/Screens/home/Inside_homepage03.dart';
import 'package:memeapp/modalclass/user_model.dart';
import '../../modalclass/meme_model.dart';

class Posts extends StatefulWidget {
  final String name;
  final String id;

  const Posts({super.key, required this.name, required this.id});

  @override
  State<Posts> createState() => _PostsState();
}

class _PostsState extends State<Posts> {
  late Future<List<Meme>> postFuture;
  @override
  void initState() {
    super.initState();
    postFuture =
        User(email: '', name: '', phone: '', id: widget.id).PostedMemesByUser();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: FutureBuilder(
            future: postFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}"));
              } else {
                List<Meme> personsMemes = snapshot.data!;
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
              }
            }));
  }
}
