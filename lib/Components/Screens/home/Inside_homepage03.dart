import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:memeapp/Resources/Resources.dart';
import 'package:memeapp/modalclass/user_model.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../../../Pages/Profile_Page.dart';
import '../../../Providers/AuthProvider.dart';
import '../../../Providers/MemeProvider.dart';
import '../../../modalclass/meme_model.dart';

class InsideHomepage03 extends StatefulWidget {
  final Meme meme;
  final int index;
  const InsideHomepage03({super.key, required this.meme, required this.index});

  @override
  State<InsideHomepage03> createState() => _InsideHomepage03State();
}

class _InsideHomepage03State extends State<InsideHomepage03> {
  Future<List<User>> fetchLikers(String memeId) async {
    final response = await http.get(
      Uri.parse('$myIP/memes/$memeId/likers'),
      headers: {
        "Authorization": "Bearer ${MemeProvider.header}",
      },
    );

    if (response.statusCode == 200) {
      var likersJson = (jsonDecode(response.body) as List<dynamic>);
      return likersJson.map((e) => User.parseFromJSON(e)).toList();
    } else {
      throw Exception('Failed to load likers');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Consumer2<MemeProvider, Authprovider>(
        builder: (context, memeProvider, aProv, child) {
          return Row(
            children: [
              IconButton(
                onPressed: () {
                  memeProvider.toggleFunction(widget.meme.id);
                },
                icon: widget.meme.likes.contains(aProv.user!.id)
                    ? Icon(
                        Icons.favorite,
                        size: 30,
                        color: Colors.pink,
                      )
                    : Icon(Icons.favorite_border, size: 30),
              ),
              Row(
                children: [
                  Text(
                    '${widget.meme.likes.length}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  TextButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (BuildContext context) {
                          return Container(
                            // height: 400,
                            width: double.infinity,
                            color: Colors.amber.shade100,
                            child: SingleChildScrollView(
                              child: FutureBuilder<List<User>>(
                                future: fetchLikers(widget.meme.id),
                                builder: (context, snapshot) {
                                  if (snapshot.hasError) {
                                    return Center(
                                      child: Text('Error: ${snapshot.error}'),
                                    );
                                  } else if (snapshot.hasData) {
                                    List<User> users = snapshot.data!;
                                    return ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: users.length,
                                      itemBuilder: (context, index) {
                                        return ListTile(
                                          leading: CircleAvatar(
                                            backgroundImage: NetworkImage(
                                                users[index].imageURL ??
                                                    personImg),
                                          ),
                                          title: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                    Navigator.of(context).push(
                                                        MaterialPageRoute(
                                                            builder: (c) =>
                                                                Profile_Page(
                                                                  myUser: users[
                                                                      index],
                                                                )));
                                                  },
                                                  child:
                                                      Text(users[index].name)),
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  } else {
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                },
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: Text(
                      'Likes',
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
