import 'package:flutter/material.dart';
import 'package:memeapp/Components/Screens/home/Inside_homepage01.dart';
import 'package:memeapp/Components/Screens/home/Inside_homepage02.dart';
import 'package:memeapp/Components/Screens/home/Inside_homepage03.dart';
import 'package:memeapp/modalclass/meme_model.dart';
import '../../modalclass/user_model.dart';

class Likes extends StatefulWidget {
  final String name;
  final String id;
  const Likes({super.key, required this.name, required this.id});

  @override
  State<Likes> createState() => _LikesState();
}

class _LikesState extends State<Likes> {
  late Future<List<Meme>> likedMemesFuture;

  @override
  void initState() {
    super.initState();
    likedMemesFuture =
        User(id: widget.id, email: '', name: '', phone: '').LikeMemesByUser();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: FutureBuilder<List<Meme>>(
        future: likedMemesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
                child: Text("No liked posts to show",
                    style: TextStyle(fontWeight: FontWeight.w600)));
          } else {
            List<Meme> likeMemes = snapshot.data!;
            return Column(
              children: [
                if (likeMemes.isEmpty)
                  Text("No posts to show",
                      style: TextStyle(fontWeight: FontWeight.w600)),
                for (int i = 0; i < likeMemes.length; i++)
                  Column(
                    children: [
                      InsideHomepage01(index: i, meme: likeMemes[i]),
                      InsideHomepage02(index: i, meme: likeMemes[i]),
                      InsideHomepage03(index: i, meme: likeMemes[i]),
                      Divider(color: Colors.black),
                    ],
                  )
              ],
            );
          }
        },
      ),
    );
  }
}
